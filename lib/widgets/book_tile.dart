import 'package:flutter/material.dart';

import '../models/book.dart';

/// Item da lista. Extraído porque é repetido para cada livro e concentra
/// a apresentação (título, autor, status, nota) e a semântica de leitura.
class BookTile extends StatelessWidget {
  const BookTile({super.key, required this.book, required this.onTap});

  final Book book;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final rating = book.rating == 0 ? 'sem nota' : 'nota ${book.rating} de 5';
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Semantics(
        button: true,
        label:
            '${book.title}, de ${book.author}. ${book.status.label}, $rating. Toque para ver detalhes.',
        child: ExcludeSemantics(
          child: ListTile(
            minVerticalPadding: 12,
            title: Text(book.title, maxLines: 2, overflow: TextOverflow.ellipsis),
            subtitle: Text(
              '${book.author} · ${book.status.label}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: book.rating == 0
                ? null
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, size: 18),
                      const SizedBox(width: 2),
                      Text('${book.rating}'),
                    ],
                  ),
            onTap: onTap,
          ),
        ),
      ),
    );
  }
}
