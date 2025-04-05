import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  final String id;
  final String title;
  final String author;
  final String isbn;
  final String owner;
  final bool isAvailable;
  final String description;
  final String genre;
  final String coverImageUrl;
  final int pageCount;
  final String language;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.isbn,
    required this.owner,
    required this.isAvailable,
    required this.description,
    required this.genre,
    required this.coverImageUrl,
    required this.pageCount,
    required this.language,
  });

  factory Book.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Book(
      id: doc.id,
      title: data['title'] ?? '',
      author: data['author'] ?? '',
      isbn: data['isbn'] ?? '',
      owner: data['owner'] ?? '',
      isAvailable: data['isAvailable'] ?? true,
      description: data['description'] ?? '',
      genre: data['genre'] ?? '',
      coverImageUrl: data['coverImageUrl'] ?? 'https://via.placeholder.com/150',
      pageCount: data['pageCount'] ?? 0,
      language: data['language'] ?? 'English',
    );
  }
}
