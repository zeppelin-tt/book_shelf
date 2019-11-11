import 'package:book_shelf/repo/InputRepo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'BookShelfPage.dart';
import 'repo/BooksRepo.dart';
import 'resources.dart';

void main() => runApp(
    MultiProvider(
        providers: [
          RepositoryProvider(builder: (_) => BooksRepo()),
          RepositoryProvider(builder: (_) => InputRepo()),
        ],
        child: Application()
    ),
);

class Application extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OKToast(
      dismissOtherOnShow: true,
      radius: 4,
      backgroundColor: Colors.black.withOpacity(0.7),
      position: ToastPosition.bottom,
      textStyle: TextStyle(fontSize: 20.0),
      child: MaterialApp(
        theme: AppThemes.mainTheme,
        debugShowCheckedModeBanner: false,
        home: BookShelfPage(),
      ),
    );
  }
}
