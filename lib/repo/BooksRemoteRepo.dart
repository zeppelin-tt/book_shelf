import 'package:book_shelf/repo/DbProvider.dart';

import '../model/Book.dart';

class BooksRemoteRepo {

  DbProvider _dbProvider;

  BooksRemoteRepo() {
    _dbProvider = DbProvider.db;
  }

  Future<List<Book>> getAll() async {
    final db = await _dbProvider.database;
    var result = await db.query('books');
    List<Book> list = result.isNotEmpty
        ? result.map((b) => Book.fromMap(b)).toList()
        : [];
    return list;
  }

  Future<int> create(Book book) async {
    final db = await _dbProvider.database;
    final table = await db.rawQuery('SELECT MAX(id)+1 as id FROM books');
    return await db.rawInsert('INSERT INTO books (id, title, author) VALUES (?,?,?)', [table.first['id'], book.title, book.author]);
  }

  Future<int> update(Book book) async {
    final db = await _dbProvider.database;
    return await db.update('books', book.toMap(), where: 'id = ?', whereArgs: [book.id]);
  }

  Future<int> delete(int id) async {
    final db = await _dbProvider.database;
    return db.delete('books', where: "id = ?", whereArgs: [id]);
  }

}