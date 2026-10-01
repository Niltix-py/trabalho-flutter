import 'package:flutter/material.dart';

import '../models/book.dart';
import '../widgets/book_tile.dart';
import '../widgets/empty_state.dart';
import 'book_detail_screen.dart';
import 'book_form_screen.dart';

class BookListScreen extends StatefulWidget {
  const BookListScreen({super.key});

  @override
  State<BookListScreen> createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  final List<Book> _books = [];

  Future<void> _addBook() async {
    final created = await Navigator.of(context).push<Book>(
      MaterialPageRoute(builder: (_) => const BookFormScreen()),
    );
    if (created != null) {
      setState(() => _books.add(created));
    }
  }

  Future<void> _openDetail(Book book) async {
    final updated = await Navigator.of(context).push<Book>(
      MaterialPageRoute(builder: (_) => BookDetailScreen(book: book)),
    );
    if (updated != null) {
      setState(() {
        final i = _books.indexWhere((b) => b.id == updated.id);
        if (i != -1) _books[i] = updated;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meus Livros')),
      body: _books.isEmpty
          ? const EmptyState()
          : ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 88),
              itemCount: _books.length,
              itemBuilder: (context, i) => BookTile(
                book: _books[i],
                onTap: () => _openDetail(_books[i]),
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        key: const Key('addButton'),
        onPressed: _addBook,
        icon: const Icon(Icons.add),
        label: const Text('Adicionar livro'),
      ),
    );
  }
}
