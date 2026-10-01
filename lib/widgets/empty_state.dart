import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.menu_book, size: 64, color: theme.colorScheme.primary),
            const SizedBox(height: 16),
            Text('Nenhum livro ainda',
                style: theme.textTheme.titleLarge, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            const Text(
              'Toque em "Adicionar livro" para começar seu catálogo.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
