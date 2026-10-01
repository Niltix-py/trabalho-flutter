import 'package:flutter/material.dart';

import '../models/book.dart';

/// Formulário usado para criar (book == null) e editar um livro.
class BookFormScreen extends StatefulWidget {
  const BookFormScreen({super.key, this.book});

  final Book? book;

  @override
  State<BookFormScreen> createState() => _BookFormScreenState();
}

class _BookFormScreenState extends State<BookFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _title =
      TextEditingController(text: widget.book?.title ?? '');
  late final TextEditingController _author =
      TextEditingController(text: widget.book?.author ?? '');
  late final TextEditingController _notes =
      TextEditingController(text: widget.book?.notes ?? '');
  late BookStatus _status = widget.book?.status ?? BookStatus.wantToRead;
  late double _rating = (widget.book?.rating ?? 0).toDouble();

  bool get _isEditing => widget.book != null;

  @override
  void dispose() {
    _title.dispose();
    _author.dispose();
    _notes.dispose();
    super.dispose();
  }

  String? _required(String? value, String field) {
    if (value == null || value.trim().length < 2) {
      return 'Informe $field (mínimo 2 caracteres).';
    }
    return null;
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final id = widget.book?.id ??
        DateTime.now().microsecondsSinceEpoch.toString();
    Navigator.of(context).pop(
      Book(
        id: id,
        title: _title.text.trim(),
        author: _author.text.trim(),
        status: _status,
        rating: _rating.round(),
        notes: _notes.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ratingLabel = _rating == 0 ? 'Sem nota' : '${_rating.round()} de 5';
    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Editar livro' : 'Novo livro')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    key: const Key('titleField'),
                    controller: _title,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(labelText: 'Título'),
                    validator: (v) => _required(v, 'o título'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    key: const Key('authorField'),
                    controller: _author,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(labelText: 'Autor(a)'),
                    validator: (v) => _required(v, 'o autor'),
                  ),
                  const SizedBox(height: 16),
                  Text('Status', style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: SegmentedButton<BookStatus>(
                      showSelectedIcon: false,
                      segments: [
                        for (final s in BookStatus.values)
                          ButtonSegment(value: s, label: Text(s.label)),
                      ],
                      selected: {_status},
                      onSelectionChanged: (s) =>
                          setState(() => _status = s.first),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('Nota: $ratingLabel',
                      style: Theme.of(context).textTheme.titleSmall),
                  Slider(
                    value: _rating,
                    min: 0,
                    max: 5,
                    divisions: 5,
                    label: ratingLabel,
                    semanticFormatterCallback: (v) =>
                        v == 0 ? 'Sem nota' : '${v.round()} de 5',
                    onChanged: (v) => setState(() => _rating = v),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    key: const Key('notesField'),
                    controller: _notes,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Anotações (opcional)',
                      alignLabelWithHint: true,
                    ),
                    validator: (v) => (v != null && v.length > 200)
                        ? 'Use no máximo 200 caracteres.'
                        : null,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton(
                      key: const Key('saveButton'),
                      onPressed: _save,
                      child: const Text('Salvar'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
