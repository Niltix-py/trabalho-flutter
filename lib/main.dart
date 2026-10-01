import 'package:flutter/material.dart';

import 'screens/book_list_screen.dart';
import 'theme.dart';

void main() => runApp(const MeusLivrosApp());

class MeusLivrosApp extends StatelessWidget {
  const MeusLivrosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meus Livros',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const BookListScreen(),
    );
  }
}
