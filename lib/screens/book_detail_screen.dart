import 'package:flutter/material.dart';

import '../models/book.dart';
import 'book_form_screen.dart';

class BookDetailScreen extends StatefulWidget {
  const BookDetailScreen({super.key, required this.book});

  final Book book;

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  late Book _book = widget.book;

  Future<void> _edit() async {
    final edited = await Navigator.of(context).push<Book>(
      MaterialPageRoute(builder: (_) => BookFormScreen(book: _book)),
    );
    if (edited != null) setState(() => _book = edited);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rating = _book.rating == 0 ? 'Sem nota' : '${_book.rating} de 5';

    // Ao voltar, devolve o livro (possivelmente editado) para a lista.
    return PopScope<Book>(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) Navigator.of(context).pop(_book);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Detalhes'),
          actions: [
            IconButton(
              key: const Key('editButton'),
              tooltip: 'Editar livro',
              icon: const Icon(Icons.edit),
              onPressed: _edit,
            ),
          ],
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_book.title, style: theme.textTheme.headlineSmall),
                  const SizedBox(height: 4),
                  Text('de ${_book.author}', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      Chip(label: Text(_book.status.label)),
                      Chip(
                        avatar: const Icon(Icons.star, size: 18),
                        label: Text(rating),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text('Anotações', style: theme.textTheme.titleSmall),
                  const SizedBox(height: 4),
                  Text(_book.notes.isEmpty ? 'Sem anotações.' : _book.notes),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
