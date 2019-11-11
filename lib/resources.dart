
import 'dart:math';

import 'package:flutter/material.dart';

strungUnit(StringUnit stringUnit) {
  return strings[stringUnit];
}

enum StringUnit {
  addBook,
  editBook,
  addBookToast,
  editBookToast,
  removedBookToast,
  prompt,
  title,
  author,
  empty
}

// это я пытался сделать как в Java типо Enum со значениями, но получилосб не очень.
// Переделывать не стал...
final Map<StringUnit, String> strings = {
  StringUnit.addBook: 'Add Book',
  StringUnit.editBook: 'Edit Book',
  StringUnit.addBookToast: 'Added the book',
  StringUnit.editBookToast: 'Edited the book',
  StringUnit.removedBookToast: 'Removed the book',
  StringUnit.prompt: 'use long press to edit',
  StringUnit.title: 'Title',
  StringUnit.author: 'Author',
  StringUnit.empty: '',
};

class AppColors {
  static const backgroundColor = Colors.black;
  static const iconColor = Colors.blueGrey;
  static const floatingButton = Color(0xFF37474F);

  static final colorList = [
    Colors.red[300],
    Colors.orange[300],
    Colors.green[300],
    Colors.blue[300],
    Colors.blueGrey[300],
    Colors.cyan[300],
    Colors.brown[300],
    Colors.amber[200],
    Colors.yellowAccent[200],
    Colors.indigoAccent[200],
    Colors.greenAccent[400],
    Colors.grey[400],
    Colors.grey[400],
    Colors.lightBlue[300],
  ];

  static Color randomColor() {
    return colorList[Random().nextInt(colorList.length)];
  }
}

class AppIcons {
  static const deleteIcon = Icon(Icons.delete_outline, color: Color(0xFF37474F), size: 30.0);
  static const addIcon = Icon(Icons.add, color: Colors.white, size: 30.0);
}

class AppThemes {
  static final mainTheme = ThemeData(
      scaffoldBackgroundColor: AppColors.backgroundColor,
      primaryTextTheme: const TextTheme(
        title:  const TextStyle(
          color: Colors.black
        )
      )
  );
}