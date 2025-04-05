import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/book.dart';

enum LendingStatus { requested, approved, rejected, returned, overdue }

class LendingTransaction {
  final String id;
  final Book book;
  final String borrowerId;
  final String ownerId;
  final DateTime requestDate;
  final DateTime? lendDate;
  final DateTime? returnDate;
  final LendingStatus status;

  LendingTransaction({
    required this.id,
    required this.book,
    required this.borrowerId,
    required this.ownerId,
    required this.requestDate,
    this.lendDate,
    this.returnDate,
    required this.status,
  });

  factory LendingTransaction.fromFirestore(DocumentSnapshot doc, Book book) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return LendingTransaction(
      id: doc.id,
      book: book,
      borrowerId: data['borrowerId'],
      ownerId: data['ownerId'],
      requestDate: (data['requestDate'] as Timestamp).toDate(),
      lendDate:
          data['lendDate'] != null
              ? (data['lendDate'] as Timestamp).toDate()
              : null,
      returnDate:
          data['returnDate'] != null
              ? (data['returnDate'] as Timestamp).toDate()
              : null,
      status: LendingStatus.values.byName(data['status']),
    );
  }
}

class LendingProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<LendingTransaction> _transactions = [];
  bool _isLoading = false;

  List<LendingTransaction> get lendingHistory => _transactions;
  bool get isLoading => _isLoading;

  Future<void> fetchLendingHistory() async {
    try {
      _isLoading = true;
      notifyListeners();

      // Fetch both the transactions and the associated books
      QuerySnapshot transactionsSnapshot =
          await _firestore.collection('lending_transactions').get();

      // Fetch books for each transaction
      List<LendingTransaction> transactions = [];
      for (var doc in transactionsSnapshot.docs) {
        DocumentSnapshot bookDoc =
            await _firestore.collection('books').doc(doc.get('bookId')).get();

        Book book = Book.fromFirestore(bookDoc);
        transactions.add(LendingTransaction.fromFirestore(doc, book));
      }

      _transactions = transactions;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw Exception('Failed to fetch lending history: ${e.toString()}');
    }
  }

  Future<void> requestBookLending(Book book, String borrowerId) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _firestore.collection('lending_transactions').add({
        'bookId': book.id,
        'borrowerId': borrowerId,
        'ownerId': book.owner,
        'requestDate': FieldValue.serverTimestamp(),
        'status': LendingStatus.requested.name,
      });

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw Exception('Failed to request book lending: ${e.toString()}');
    }
  }

  Future<void> updateLendingStatus(
    String transactionId,
    LendingStatus status,
  ) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _firestore
          .collection('lending_transactions')
          .doc(transactionId)
          .update({
            'status': status.name,
            if (status == LendingStatus.approved)
              'lendDate': FieldValue.serverTimestamp(),
            if (status == LendingStatus.returned)
              'returnDate': FieldValue.serverTimestamp(),
          });

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw Exception('Failed to update lending status: ${e.toString()}');
    }
  }
}
