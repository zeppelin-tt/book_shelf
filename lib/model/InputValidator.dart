class InputValidator {
  bool _isValidTitle;
  bool _isValidAuthor;

  InputValidator({validTitle, validAuthor})
      : this._isValidTitle = validTitle,
        this._isValidAuthor = validAuthor;

  bool get validTitle => this._isValidTitle;

  bool get validAuthor => this._isValidAuthor;

  bool get allValid => this._isValidTitle && this._isValidAuthor;

}