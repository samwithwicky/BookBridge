import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/cart.dart';
import '../models/order.dart';
import '../models/location.dart';

class OrderProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Order> _orders = [];
  bool _isLoading = false;

  List<Order> get orders => _orders;
  bool get isLoading => _isLoading;

  Future<String> placeOrder({
    required String userId,
    required Cart cart,
    required UserLocation deliveryLocation,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Create a new document reference
      final orderRef = _firestore.collection('orders').doc();

      // Create order from cart
      final order = Things.fromCart(
        id: orderRef.id,
        userId: userId,
        cart: cart,
        deliveryLocation: deliveryLocation,
        orderDate: DateTime.now(),
      );

      // Save to Firestore
      await orderRef.set(order.toFirestore());

      // Update book availability
      for (var item in cart.items) {
        await _firestore.collection('books').doc(item.book.id).update({
          'isAvailable': false,
        });
      }

      _isLoading = false;
      notifyListeners();

      // Return the order ID
      return order.id;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw Exception('Failed to place order: ${e.toString()}');
    }
  }

  Future<void> fetchUserOrders(String userId) async {
    try {
      _isLoading = true;
      notifyListeners();

      // This is a simplified version - in a real app, you'd need to fetch books data too
      // ignore: unused_local_variable
      final ordersSnapshot =
          await _firestore
              .collection('orders')
              .where('userId', isEqualTo: userId)
              .orderBy('orderDate', descending: true)
              .get();

      // This is just a placeholder - actual implementation would require
      // fetching books for each order item
      _orders = [];

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw Exception('Failed to fetch orders: ${e.toString()}');
    }
  }
}
