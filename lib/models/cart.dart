import '../models/book.dart';

class CartItem {
  final Book book;
  final int rentalDays;
  final double rentalPrice;
  final double deliveryCharge;
  final double cautionDeposit;

  CartItem({
    required this.book,
    required this.rentalDays,
    required this.rentalPrice,
    required this.deliveryCharge,
    required this.cautionDeposit,
  });

  double get totalPrice => rentalPrice + deliveryCharge + cautionDeposit;
}

class Cart {
  List<CartItem> items = [];

  double get subtotal => items.fold(0, (sum, item) => sum + item.rentalPrice);
  double get deliveryTotal =>
      items.fold(0, (sum, item) => sum + item.deliveryCharge);
  double get depositTotal =>
      items.fold(0, (sum, item) => sum + item.cautionDeposit);
  double get total => subtotal + deliveryTotal + depositTotal;

  void addItem(CartItem item) {
    // Check if book already exists in cart
    final existingIndex = items.indexWhere(
      (element) => element.book.id == item.book.id,
    );
    if (existingIndex >= 0) {
      // Replace existing item
      items[existingIndex] = item;
    } else {
      items.add(item);
    }
  }

  void removeItem(String bookId) {
    items.removeWhere((item) => item.book.id == bookId);
  }

  void clear() {
    items.clear();
  }
}
