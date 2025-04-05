import 'package:flutter/foundation.dart';
import '../models/book.dart';
import '../models/cart.dart';

class CartProvider with ChangeNotifier {
  final Cart _cart = Cart();

  Cart get cart => _cart;
  int get itemCount => _cart.items.length;

  // Calculate the total rental price from all cart items
  double get total {
    double sum = 0.0;
    for (var item in _cart.items) {
      sum += item.rentalPrice;
    }
    return sum;
  }

  void addToCart({
    required Book book,
    required int rentalDays,
    required double rentalPrice,
    required double deliveryCharge,
    required double cautionDeposit,
  }) {
    final cartItem = CartItem(
      book: book,
      rentalDays: rentalDays,
      rentalPrice: rentalPrice,
      deliveryCharge: deliveryCharge,
      cautionDeposit: cautionDeposit,
    );

    _cart.addItem(cartItem);
    notifyListeners();
  }

  void removeFromCart(String bookId) {
    _cart.removeItem(bookId);
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }
}
