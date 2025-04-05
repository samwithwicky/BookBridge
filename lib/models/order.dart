import '../models/cart.dart';
import '../models/location.dart';

enum OrderStatus {
  pending,
  processing,
  outForDelivery,
  delivered,
  returned,
  cancelled,
}

class Things {
  final String id;
  final String userId;
  final List<CartItem> items;
  final UserLocation deliveryLocation;
  final double subtotal;
  final double deliveryCharges;
  final double cautionDeposit;
  final double total;
  final DateTime orderDate;
  final OrderStatus status;
  final String? trackingInfo;

  Things({
    required this.id,
    required this.userId,
    required this.items,
    required this.deliveryLocation,
    required this.subtotal,
    required this.deliveryCharges,
    required this.cautionDeposit,
    required this.total,
    required this.orderDate,
    required this.status,
    this.trackingInfo,
  });

  factory Things.fromCart({
    required String id,
    required String userId,
    required Cart cart,
    required UserLocation deliveryLocation,
    required DateTime orderDate,
  }) {
    return Things(
      id: id,
      userId: userId,
      items: List.from(cart.items),
      deliveryLocation: deliveryLocation,
      subtotal: cart.subtotal,
      deliveryCharges: cart.deliveryTotal,
      cautionDeposit: cart.depositTotal,
      total: cart.total,
      orderDate: orderDate,
      status: OrderStatus.pending,
    );
  }

  // For Firestore conversion (would be implemented in a real app)
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'items':
          items
              .map(
                (item) => {
                  'bookId': item.book.id,
                  'rentalDays': item.rentalDays,
                  'rentalPrice': item.rentalPrice,
                  'deliveryCharge': item.deliveryCharge,
                  'cautionDeposit': item.cautionDeposit,
                },
              )
              .toList(),
      'deliveryLocation': {
        'address': deliveryLocation.address,
        'city': deliveryLocation.city,
        'state': deliveryLocation.state,
        'postalCode': deliveryLocation.postalCode,
        'landmark': deliveryLocation.landmark,
      },
      'subtotal': subtotal,
      'deliveryCharges': deliveryCharges,
      'cautionDeposit': cautionDeposit,
      'total': total,
      'orderDate': orderDate,
      'status': status.name,
      'trackingInfo': trackingInfo,
    };
  }
}
