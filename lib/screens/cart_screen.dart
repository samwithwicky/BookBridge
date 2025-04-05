import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/order_provider.dart';
import '../providers/location_provider.dart';
import '../models/cart.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _confirmClearCart(context),
          ),
        ],
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          if (cartProvider.itemCount == 0) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.shopping_cart_outlined,
                    size: 100,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Your cart is empty',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/home'),
                    child: const Text('Browse Books'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartProvider.cart.items.length,
                  itemBuilder: (context, index) {
                    final cartItem = cartProvider.cart.items[index];
                    return CartItemCard(cartItem: cartItem);
                  },
                ),
              ),
              _buildOrderSummary(context, cartProvider),
            ],
          );
        },
      ),
    );
  }

  Widget _buildOrderSummary(BuildContext context, CartProvider cartProvider) {
    double rentalTotal = cartProvider.total;
    double deliveryCharge = _calculateDeliveryCharge(cartProvider);
    double cautionDeposit = _calculateCautionDeposit(cartProvider);
    double grandTotal = _calculateGrandTotal(cartProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Rental'),
              Text(
                '₹${rentalTotal.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Delivery Charge'),
              Text(
                '₹${deliveryCharge.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Caution Deposit'),
              Text(
                '₹${cautionDeposit.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Grand Total',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                '₹${grandTotal.toStringAsFixed(2)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Inside CartScreen, add this before checkout button
          // Replace the Consumer<LocationProvider> section in _buildOrderSummary method with this:
          Consumer<LocationProvider>(
            builder: (context, locationProvider, _) {
              return Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.deepOrange),
                        const SizedBox(width: 8),
                        const Text(
                          'Delivery Address',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed:
                              () => Navigator.pushNamed(context, '/location'),
                          child: const Text('Change'),
                        ),
                      ],
                    ),
                    if (locationProvider.selectedLocation != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 32),
                        child: Text(
                          locationProvider.selectedLocation!.formattedAddress,
                          style: const TextStyle(fontSize: 14),
                        ),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.only(left: 32),
                        child: TextButton(
                          onPressed:
                              () => Navigator.pushNamed(context, '/location'),
                          child: const Text('Select a delivery location'),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
          ElevatedButton(
            onPressed:
                _isProcessing
                    ? null
                    : () => _proceedToCheckout(context, cartProvider),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child:
                _isProcessing
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Proceed to Checkout'),
          ),
        ],
      ),
    );
  }

  double _calculateDeliveryCharge(CartProvider cartProvider) {
    // Simple delivery charge calculation - could be more complex in real app
    return cartProvider.itemCount * 20.0;
  }

  double _calculateCautionDeposit(CartProvider cartProvider) {
    // Simple caution deposit calculation - typically 50% of book value
    double deposit = 0.0;
    for (var item in cartProvider.cart.items) {
      deposit += item.rentalPrice * 0.5;
    }
    return deposit;
  }

  double _calculateGrandTotal(CartProvider cartProvider) {
    // Get the total rental price of all books
    double rentalTotal = cartProvider.total;

    // Add delivery charge and caution deposit
    double deliveryCharge = _calculateDeliveryCharge(cartProvider);
    double cautionDeposit = _calculateCautionDeposit(cartProvider);

    return rentalTotal + deliveryCharge + cautionDeposit;
  }

  void _proceedToCheckout(BuildContext context, CartProvider cartProvider) {
    final locationProvider = Provider.of<LocationProvider>(
      context,
      listen: false,
    );

    if (locationProvider.selectedLocation == null) {
      // Prompt user to select a delivery location
      Navigator.pushNamed(context, '/location');
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    // Place order logic
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    orderProvider
        .placeOrder(
          userId: 'currentUserId', // In a real app, get from AuthProvider
          cart: cartProvider.cart,
          deliveryLocation: locationProvider.selectedLocation!,
        )
        .then((orderId) {
          // Order placed successfully
          setState(() {
            _isProcessing = false;
          });
          cartProvider.clearCart();

          // Show success dialog then navigate to orders screen
          showDialog(
            context: context,
            barrierDismissible: false,
            builder:
                (context) => AlertDialog(
                  title: const Text('Order Placed Successfully'),
                  content: Text('Your order ID is $orderId'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushReplacementNamed(context, '/orders');
                      },
                      child: const Text('View Orders'),
                    ),
                  ],
                ),
          );
        })
        .catchError((error) {
          setState(() {
            _isProcessing = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to place order: $error')),
          );
        });
  }

  void _confirmClearCart(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Clear Cart'),
            content: const Text(
              'Are you sure you want to remove all items from your cart?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Provider.of<CartProvider>(context, listen: false).clearCart();
                  Navigator.pop(context);
                },
                child: const Text('Clear'),
              ),
            ],
          ),
    );
  }
}

class CartItemCard extends StatelessWidget {
  final CartItem cartItem;

  const CartItemCard({super.key, required this.cartItem});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Book cover image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                cartItem.book.coverImageUrl,
                width: 80,
                height: 120,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 80,
                    height: 120,
                    color: Colors.grey[300],
                    child: const Icon(Icons.book, color: Colors.grey),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            // Book details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cartItem.book.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'by ${cartItem.book.author}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text('Rental: ${cartItem.rentalDays} days'),
                  Text(
                    'Price: ₹${cartItem.rentalPrice.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // Remove button
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () {
                Provider.of<CartProvider>(
                  context,
                  listen: false,
                ).removeFromCart(cartItem.book.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
