import 'package:book_shelf/model/InputValidator.dart';
import 'package:rxdart/rxdart.dart';

class InputRepo {
  String _title;
  String _author;

  InputValidator _tryConfirm;

  final BehaviorSubject<String> _subjectTitle;
  final BehaviorSubject<String> _subjectAuthor;
  final BehaviorSubject<InputValidator> _subjectConfirm;

  InputRepo()
      : this._title = '',
        this._author = '',
        this._tryConfirm = InputValidator(),
        _subjectTitle = BehaviorSubject.seeded(''),
        _subjectAuthor = BehaviorSubject.seeded(''),
        _subjectConfirm = BehaviorSubject.seeded(InputValidator());

  InputRepo.withParams({String title, String author})
      : this._title = title,
        this._author = author,
        this._tryConfirm = InputValidator(),
        _subjectTitle = BehaviorSubject.seeded(title),
        _subjectAuthor = BehaviorSubject.seeded(author),
        _subjectConfirm = BehaviorSubject.seeded(InputValidator());


  String get title => this._title;

  String get author => this._author;

  setTitle(String title) {
    this._title = title;
    _subjectTitle.add(title);
  }

  setAuthor(String author) {
    this._author = author;
    _subjectAuthor.add(author);
  }

  setBook(String title, String author) {
    setTitle(title);
    setAuthor(author);
  }

  // это наглый хак, чтобы создать Observable<InputValidator> observeValidation() именно с таким дженериком!...
  // Но ведь работает же, черт его дери!
  // Лучше не смог придумать(
  setConfirm() {
    this._tryConfirm = InputValidator();
    _subjectConfirm.add(this._tryConfirm);
  }

  Observable<String> observeTitle() => _subjectTitle.stream;

  Observable<String> observeAuthor() => _subjectAuthor.stream;

  Observable<InputValidator> observeConfirmation() => _subjectConfirm.stream;

  Observable<InputValidator> observeValidation() {
    return observeConfirmation().withLatestFrom2<String, String, InputValidator>(observeTitle(), observeAuthor(), (a, b, c) =>
        InputValidator(validTitle: b != '', validAuthor: c != ''));
  }

}
