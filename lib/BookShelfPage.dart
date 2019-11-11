import 'package:animated_stream_list/animated_stream_list.dart';
import 'package:book_shelf/model/InputValidator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:oktoast/oktoast.dart';

import 'model/Book.dart';
import 'repo/BooksRepo.dart';
import 'repo/InputRepo.dart';
import 'resources.dart';

class BookShelfPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    BooksRepo _booksRepo = RepositoryProvider.of<BooksRepo>(context);
    InputRepo _inputRepo = RepositoryProvider.of<InputRepo>(context);
    _booksRepo.getFromApi();
    return _booksRepo.isNotLoaded() ? Spinner() : Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _inputRepo.setBook('', '');
          _showAlert(context, StringUnit.addBook, () {
            _booksRepo.add(Book(title: _inputRepo.title, author: _inputRepo.author));
            showToast('${strings[StringUnit.addBookToast]} ${_inputRepo.title}');
          });
        },
        child: AppIcons.addIcon,
        backgroundColor: AppColors.floatingButton,
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(strings[StringUnit.prompt],
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            ),
            Expanded(
                child: _buildStreamList(_booksRepo)
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStreamList(BooksRepo _booksRepo) =>
      AnimatedStreamList<Book>(
          initialList: [],
          streamList: _booksRepo.observe,
          itemBuilder: (Book book, int index, BuildContext context, Animation<double> animation) =>
              _createBook(context, book, animation),
          itemRemovedBuilder: (Book book, int index, BuildContext context, Animation<double> animation) =>
              _removeBook(context, book, animation));

  Widget _createBook(BuildContext context, Book book, Animation<double> animation) {
    BooksRepo _booksRepo = RepositoryProvider.of<BooksRepo>(context);
    InputRepo _inputRepo = RepositoryProvider.of<InputRepo>(context);
    return SizeTransition(
      axis: Axis.vertical,
      sizeFactor: animation,
      child: GestureDetector(
        onLongPress: () {
          _inputRepo.setBook(book.title, book.author);
          _showAlert(context, StringUnit.editBook, () {
            book.author = _inputRepo.author;
            book.title = _inputRepo.title;
            _booksRepo.update(book);
            showToast('${strings[StringUnit.editBookToast]} ${_inputRepo.title}');
          });
        },
        child: Card(
          color: AppColors.randomColor(),
          child: ListTile(
            title: Text(book.title),
            subtitle: Text(book.author),
            trailing:
            InkWell(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: AppIcons.deleteIcon,
              ),
              customBorder: CircleBorder(),
              onTap: () {
                _booksRepo.delete(book.id);
                showToast('${strings[StringUnit.removedBookToast]} ${_inputRepo.title}');
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _removeBook(BuildContext context, Book book, Animation<double> animation) {
    return SizeTransition(
      axis: Axis.vertical,
      sizeFactor: animation,
      child: Card(
        child: ListTile(
          title: Text(book.title),
          subtitle: Text(book.author),
        ),
      ),
    );
  }

  Future<void> _showAlert(BuildContext context, StringUnit operation, VoidCallback onPressConfirm) {
    InputRepo _inputRepo = RepositoryProvider.of<InputRepo>(context);
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StreamBuilder<InputValidator>(
              initialData: InputValidator(validTitle: true, validAuthor: true),
              stream: _inputRepo.observeValidation(),
              builder: (context, snapshot) {
                return BookAlert(
                    authorInput: AlertField(
                      initialText: operation == StringUnit.editBook ? _inputRepo.title : '',
                      onChanged: (value) => _inputRepo.setTitle(value),
                      descriptionWidget: Text(strings[StringUnit.title], style: TextStyle(color: Colors.white70)),
                      errorText: snapshot.data.validTitle ? null : 'Title Can\'t Be Empty',
                      autofocus: true,
                    ),
                    bookNameInput: AlertField(
                      initialText: operation == StringUnit.editBook ? _inputRepo.author : '',
                      onChanged: (value) => _inputRepo.setAuthor(value),
                      descriptionWidget: Text(strings[StringUnit.author], style: TextStyle(color: Colors.white70)),
                      errorText: snapshot.data.validAuthor ? null : 'Autor Can\'t Be Empty',
                    ),
                    buttonName: strings[operation],
                    onPressButton: () {
                      _inputRepo.setConfirm();
                      if (_inputRepo.title != '' && _inputRepo.author != '') {
                        onPressConfirm();
                        Navigator.of(context).pop();
                      }
                    }
                );
              }
          );
        }
    );
  }
}

class BookAlert extends StatelessWidget {
  final Widget authorInput;
  final Widget bookNameInput;
  final String buttonName;
  final VoidCallback onPressButton;

  BookAlert({this.authorInput, this.bookNameInput, this.buttonName, this.onPressButton});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.blueGrey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            authorInput,
            bookNameInput,
          ],
        ),
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 30.0, right: 30.0, bottom: 30.0),
          child: SizedBox(
            width: 255,
            child: FlatButton(
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(15.0),
              ),
              color: Colors.white.withOpacity(0.5),
              textColor: Colors.black,
              child: Text(buttonName),
              onPressed: onPressButton,
            ),
          ),
        )
      ],
    );
  }
}

class AlertField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final Widget descriptionWidget;
  final String initialText;
  final bool autofocus;
  final String errorText;

  AlertField({
    this.onChanged,
    this.descriptionWidget,
    this.initialText = '',
    this.autofocus = false,
    this.errorText
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 15.0,),
        descriptionWidget,
        SizedBox(height: 5.0,),
        TextFormField(
          initialValue: initialText,
          maxLength: 27,
          maxLines: 1,
          textAlign: TextAlign.start,
          textDirection: TextDirection.ltr,
          autofocus: autofocus,
          style: TextStyle(color: Colors.white70),
          onChanged: onChanged,
          decoration: InputDecoration(
            errorText: errorText,
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white70, width: 5.0)
            ),
            contentPadding: EdgeInsets.only(left: 15, top: 15, right: 10),
          ),
        ),
      ],
    );
  }
}

class Spinner extends StatelessWidget {

  Spinner();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitWave(
        color: Colors.white,
        type: SpinKitWaveType.start,
      ),
    );
  }
}
