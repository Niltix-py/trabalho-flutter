enum BookStatus {
  wantToRead('Quero ler'),
  reading('Lendo'),
  read('Lido');

  const BookStatus(this.label);
  final String label;
}

class Book {
  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.status,
    this.rating = 0,
    this.notes = '',
  });

  final String id;
  final String title;
  final String author;
  final BookStatus status;

  /// 0 = sem nota; 1 a 5 = nota.
  final int rating;
  final String notes;

  Book copyWith({
    String? title,
    String? author,
    BookStatus? status,
    int? rating,
    String? notes,
  }) {
    return Book(
      id: id,
      title: title ?? this.title,
      author: author ?? this.author,
      status: status ?? this.status,
      rating: rating ?? this.rating,
      notes: notes ?? this.notes,
    );
  }
}
