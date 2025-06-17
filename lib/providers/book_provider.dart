import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/book.dart';

class BookProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Book> _books = [];
  bool _isLoading = false;

  List<Book> get books => _books;
  bool get isLoading => _isLoading;

  Future<void> addBook(Book book, String userId) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _firestore.collection('books').add({
        'title': book.title,
        'author': book.author,
        'isbn': book.isbn,
        'owner': userId,
        'isAvailable': true,
        'description': book.description,
        'genre': book.genre,
        'coverImageUrl': book.coverImageUrl,
        'pageCount': book.pageCount,
        'language': book.language,
      });

      // Update user's owned books
      await _firestore.collection('users').doc(userId).update({
        'booksOwned': FieldValue.arrayUnion([book.isbn]),
      });

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw Exception('Failed to add book: ${e.toString()}');
    }
  }

  Future<void> fetchBooks() async {
    try {
      _isLoading = true;
      notifyListeners();

      QuerySnapshot querySnapshot = await _firestore.collection('books').get();
      _books =
          querySnapshot.docs.map((doc) => Book.fromFirestore(doc)).toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw Exception('Failed to fetch books: ${e.toString()}');
    }
  }

  Future<bool> borrowBook(String bookId) async {
    try {
      // Implement borrow book logic
      await _firestore.collection('books').doc(bookId).update({
        'isAvailable': false,
      });

      // Refresh books list
      await fetchBooks();
      return true;
    } catch (e) {
      throw Exception('Failed to borrow book: ${e.toString()}');
    }
  }

  Future<void> updateBookAvailability(String bookId, bool isAvailable) async {
    try {
      await _firestore.collection('books').doc(bookId).update({
        'isAvailable': isAvailable,
      });

      // Refresh books list
      await fetchBooks();
    } catch (e) {
      throw Exception('Failed to update book availability: ${e.toString()}');
    }
  }
}
