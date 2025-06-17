import 'package:bookbridge/providers/location_provider.dart';
import 'package:flutter/material.dart';
import 'package:bookbridge/models/book.dart';
import 'package:bookbridge/screens/book_details_screen.dart';
import 'package:bookbridge/services/book_service.dart';
import 'package:provider/provider.dart';

const IconData shoppingCart = IconData(0xe59c, fontFamily: 'MaterialIcons');

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final BookService _bookService = BookService();
  List<Book> _featuredBooks = [];
  List<Book> _recommendedBooks = [];
  bool _isLoading = true;
  int _selectedIndex = 0; // Track the selected bottom navigation item

  @override
  void initState() {
    super.initState();
    _fetchBooks();

    // Check if we have a delivery location
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final locationProvider = Provider.of<LocationProvider>(
        context,
        listen: false,
      );
      if (locationProvider.locations.isEmpty) {
        // Show dialog to add location
        _showLocationPrompt();
      }
    });
  }

  void _showLocationPrompt() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            title: const Text('Set Delivery Location'),
            content: const Text(
              'Please set a delivery location to continue shopping.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/location');
                },
                child: const Text('Set Location'),
              ),
            ],
          ),
    );
  }

  Future<void> _fetchBooks() async {
    try {
      setState(() {
        _isLoading = true;
      });

      _featuredBooks = await _bookService.getFeaturedBooks();
      _recommendedBooks = await _bookService.getRecommendedBooks();

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load books: $e')));
    }
  }

  // Method to handle bottom navigation item taps
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        // Home screen, do nothing as we're already here
        break;
      case 1:
        // Navigate to Profile screen
        Navigator.pushNamed(context, '/sell');
        break;
      case 2:
        // Navigate to Profile screen
        Navigator.pushNamed(context, '/cart');
        break;
      case 3:
        // Navigate to Profile screen
        Navigator.pushNamed(context, '/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BookBridge')),

      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                onRefresh: _fetchBooks,
                child: ListView(
                  children: [
                    _buildSectionTitle('Featured Books'),
                    _buildBookHorizontalList(_featuredBooks),
                    _buildSectionTitle('Recommended for You'),
                    _buildBookHorizontalList(_recommendedBooks),
                  ],
                ),
              ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.deepOrangeAccent,
        selectedItemColor: Colors.white, // Selected item color white
        unselectedItemColor:
            Colors.white54, // Unselected items slightly transparent
        currentIndex: _selectedIndex, // Track the current selected index
        onTap: _onItemTapped, // Handle item taps
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Store'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Sell'),
          BottomNavigationBarItem(icon: Icon(Icons.shop), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(title, style: Theme.of(context).textTheme.headlineSmall),
    );
  }

  Widget _buildBookHorizontalList(List<Book> books) {
    return SizedBox(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: books.length,
        itemBuilder: (context, index) {
          return _buildBookCard(books[index]);
        },
      ),
    );
  }

  Widget _buildBookCard(Book book) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookDetailsScreen(book: book),
          ),
        );
      },
      child: Container(
        width: 150,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                book.coverImageUrl,
                height: 200,
                width: 150,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.white,
                    height: 200,
                    width: 150,
                    child: const Icon(Icons.book, color: Colors.black),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Text(
              book.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
