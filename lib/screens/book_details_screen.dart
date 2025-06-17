import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/book.dart';
import '../providers/book_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/location_provider.dart';

class BookDetailsScreen extends StatefulWidget {
  final Book book;

  const BookDetailsScreen({super.key, required this.book});

  @override
  _BookDetailsScreenState createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  final BookProvider _bookService = BookProvider();
  bool _isLoading = false;
  int _rentalDays = 7; // Default rental period
  final double _pricePerDay = 10; // Default price per day

  void _borrowBook() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final success = await _bookService.borrowBook(widget.book.id);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${widget.book.title} borrowed successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to borrow ${widget.book.title}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _addToCart() {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    // Calculate prices
    final rentalPrice = _pricePerDay * _rentalDays;
    const deliveryCharge = 50.5;
    final cautionDeposit = rentalPrice * 0.5; // 50% of rental price as deposit

    cartProvider.addToCart(
      book: widget.book,
      rentalDays: _rentalDays,
      rentalPrice: rentalPrice,
      deliveryCharge: deliveryCharge,
      cautionDeposit: cautionDeposit,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.book.title} added to cart'),
        backgroundColor: Colors.green,
        action: SnackBarAction(
          label: 'VIEW CART',
          onPressed: () {
            Navigator.pushNamed(context, '/cart');
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rentalPrice = _pricePerDay * _rentalDays;

    return Scaffold(
      appBar: AppBar(title: Text(widget.book.title)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Book Cover
            Hero(
              tag: 'book_cover_${widget.book.id}',
              child: Image.network(
                widget.book.coverImageUrl,
                height: 400,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 400,
                    color: Colors.grey,
                    child: const Icon(
                      Icons.book,
                      size: 100,
                      color: Colors.white,
                    ),
                  );
                },
              ),
            ),

            // Book Details
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.book.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'by ${widget.book.author}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),

                  // Book Metadata
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildMetadataChip('Genre', widget.book.genre),
                      _buildMetadataChip(
                        'Pages',
                        widget.book.pageCount.toString(),
                      ),
                      _buildMetadataChip('Language', widget.book.language),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Price details
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.deepOrange.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Rental Price',
                          style: Theme.of(context).textTheme.titleMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('₹${_pricePerDay.toStringAsFixed(2)} / day'),
                            Text(
                              '₹${rentalPrice.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Text('Rental period:'),
                            const Spacer(),
                            DropdownButton<int>(
                              value: _rentalDays,
                              items:
                                  [7, 14, 21, 30].map((days) {
                                    return DropdownMenuItem<int>(
                                      value: days,
                                      child: Text('$days days'),
                                    );
                                  }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _rentalDays = value!;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Description
                  // Description
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.book.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),

                  const SizedBox(height: 24),

                  // Button Row
                  Column(
                    children: [
                      // Location display
                      Consumer<LocationProvider>(
                        builder: (context, locationProvider, _) {
                          return Container(
                            padding: const EdgeInsets.all(8),
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: Colors.deepOrange,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child:
                                      locationProvider.selectedLocation != null
                                          ? Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Deliver to:',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey.shade700,
                                                ),
                                              ),
                                              Text(
                                                locationProvider
                                                    .selectedLocation!
                                                    .formattedAddress,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          )
                                          : const Text(
                                            'Select delivery location',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                ),
                                TextButton(
                                  onPressed:
                                      () => Navigator.pushNamed(
                                        context,
                                        '/location',
                                      ),
                                  child: const Text('Change'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                      // Buttons in a separate row
                      Row(
                        children: [
                          // Borrow Button
                          Expanded(
                            child:
                                _isLoading
                                    ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                    : ElevatedButton(
                                      onPressed: _borrowBook,
                                      style: ElevatedButton.styleFrom(
                                        minimumSize: const Size(
                                          double.infinity,
                                          50,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                      child: const Text('Rent Book'),
                                    ),
                          ),
                          const SizedBox(width: 12),
                          // Add to Cart Button
                          Expanded(
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.shopping_cart),
                              label: const Text('Add to Cart'),
                              onPressed: _addToCart,
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 50),
                                backgroundColor: Colors.deepOrange,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetadataChip(String label, String value) {
    return Chip(
      label: Column(
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
      backgroundColor: Colors.white,
      side: const BorderSide(color: Colors.deepOrange),
      labelStyle: const TextStyle(color: Colors.deepOrange),
    );
  }
}
