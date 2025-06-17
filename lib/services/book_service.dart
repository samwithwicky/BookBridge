import 'package:bookbridge/models/book.dart';

class BookService {
  // In a real-world application, these would typically come from an API or database
  Future<List<Book>> getFeaturedBooks() async {
    // Simulating network delay
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      Book(
        id: '1',
        title: 'The Great Gatsby',
        author: 'F. Scott Fitzgerald',
        isbn: '9780743273565',
        owner: 'Library Main Branch',
        isAvailable: true,
        coverImageUrl: 'https://example.com/gatsby-cover.jpg',
        description: 'A novel about the decadence and excess of the Jazz Age.',
        genre: 'Classic Literature',
        pageCount: 180,
        language: 'English',
      ),
      Book(
        id: '2',
        title: 'To Kill a Mockingbird',
        author: 'Harper Lee',
        isbn: '9780446310789',
        owner: 'Community Library',
        isAvailable: true,
        coverImageUrl: 'https://example.com/mockingbird-cover.jpg',
        description:
            'A powerful story of racial injustice and moral growth in the American South.',
        genre: 'Fiction',
        pageCount: 281,
        language: 'English',
      ),
      Book(
        id: '3',
        title: '1984',
        author: 'George Orwell',
        isbn: '9780451524935',
        owner: 'University Library',
        isAvailable: false,
        coverImageUrl: 'https://example.com/1984-cover.jpg',
        description:
            'A dystopian novel exploring totalitarianism and surveillance.',
        genre: 'Science Fiction',
        pageCount: 328,
        language: 'English',
      ),
    ];
  }

  Future<List<Book>> getRecommendedBooks() async {
    // Simulating network delay
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      Book(
        id: '4',
        title: 'The Alchemist',
        author: 'Paulo Coelho',
        isbn: '9780062315007',
        owner: 'City Library',
        isAvailable: true,
        coverImageUrl: 'https://example.com/alchemist-cover.jpg',
        description: 'A philosophical novel about following one\'s dreams.',
        genre: 'Fiction',
        pageCount: 208,
        language: 'English',
      ),
      Book(
        id: '5',
        title: 'Dune',
        author: 'Frank Herbert',
        isbn: '9780441172719',
        owner: 'Science Fiction Club',
        isAvailable: true,
        coverImageUrl: 'https://example.com/dune-cover.jpg',
        description:
            'An epic science fiction novel set in a complex interstellar society.',
        genre: 'Science Fiction',
        pageCount: 412,
        language: 'English',
      ),
      Book(
        id: '6',
        title: 'The Hobbit',
        author: 'J.R.R. Tolkien',
        isbn: '9780547928227',
        owner: 'Fantasy Readers Association',
        isAvailable: false,
        coverImageUrl: 'https://example.com/hobbit-cover.jpg',
        description: 'A fantasy novel about the adventure of Bilbo Baggins.',
        genre: 'Fantasy',
        pageCount: 310,
        language: 'English',
      ),
    ];
  }

  // New method to filter books by genre
  Future<List<Book>> getBooksByGenre(String genre) async {
    // In a real implementation, this would query a database
    List<Book> allBooks = await Future.wait([
      getFeaturedBooks(),
      getRecommendedBooks(),
    ]).then((lists) => lists.expand((list) => list).toList());

    return allBooks
        .where((book) => book.genre.toLowerCase() == genre.toLowerCase())
        .toList();
  }

  // New method to check book availability
  Future<bool> checkBookAvailability(String bookId) async {
    // In a real implementation, this would check a database
    List<Book> allBooks = await Future.wait([
      getFeaturedBooks(),
      getRecommendedBooks(),
    ]).then((lists) => lists.expand((list) => list).toList());

    final book = allBooks.firstWhere((b) => b.id == bookId);
    return book.isAvailable;
  }

  // New method to get book details by ID
  Future<Book?> getBookById(String bookId) async {
    // In a real implementation, this would query a database
    List<Book> allBooks = await Future.wait([
      getFeaturedBooks(),
      getRecommendedBooks(),
    ]).then((lists) => lists.expand((list) => list).toList());

    try {
      return allBooks.firstWhere((book) => book.id == bookId);
    } catch (e) {
      return null;
    }
  }
}
