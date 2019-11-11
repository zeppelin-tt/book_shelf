import 'package:flutter/material.dart';

class Book {
  int id;
  String title;
  String author;

  Book({
    this.id,
    @required this.title,
    @required this.author,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'title': this.title,
      'author': this.author,
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return new Book(
      id: map['id'] as int,
      title: map['title'] as String,
      author: map['author'] as String,
    );
  }

}
