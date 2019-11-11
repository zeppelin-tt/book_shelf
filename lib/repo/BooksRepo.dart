import 'dart:async';

import 'package:rxdart/rxdart.dart';

import '../model/Book.dart';
import 'BooksRemoteRepo.dart';

class BooksRepo {

  BooksRemoteRepo _remoteRepo;
  List<Book> _books;

  BehaviorSubject<List<Book>> _subjects;

  BooksRepo() {
    _remoteRepo = BooksRemoteRepo();
    _books = [];
    _subjects = BehaviorSubject.seeded([]);
  }


  List<Book> get books => this._books;

  bool isNotLoaded() => _books == null;

  getFromApi() async {
    this._books = await _remoteRepo.getAll();
    _subjects.add(this._books);
  }

  add(Book book) async {
    if (book.id != null || book.author == null || book.title == null || book.author.isEmpty || book.title.isEmpty) {
      //TODO: выводить исключения
    }
    _remoteRepo.create(book).then((id) {
      book.id = id;
      this._books.add(book);
      _subjects.add(this._books);
    });
  }

  update(Book book) async {
    int index = _books.map((b) => b.id).toList().indexOf(book.id);
    if (book.id == null) {
      //TODO: выводить исключение
    }
    if (!_books.contains(book)) {
      _remoteRepo.update(book).then((value) {
        _books[index] = book;
        _subjects.add(this._books);
      });
    }
  }

  delete(int id) async {
    _remoteRepo.delete(id).then((value) {
      this._books = this._books.where((b) => b.id != id).toList();
      _subjects.add(this._books);
    });
  }

  Stream<List<Book>> get observe => _subjects.stream;

}
