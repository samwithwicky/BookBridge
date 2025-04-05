import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/book.dart';
import '../providers/book_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';

class SellBookScreen extends StatefulWidget {
  const SellBookScreen({super.key});

  @override
  _SellBookScreenState createState() => _SellBookScreenState();
}

class _SellBookScreenState extends State<SellBookScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _isbnController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _pageCountController = TextEditingController();
  String _selectedGenre = 'Fiction';
  String _selectedLanguage = 'English';
  File? _bookCoverImage;
  bool _isLoading = false;

  final List<String> _genres = [
    'Fiction',
    'Non-fiction',
    'Mystery',
    'Thriller',
    'Romance',
    'Science Fiction',
    'Fantasy',
    'Biography',
    'History',
    'Self-help',
    'Business',
    'Children',
  ];

  final List<String> _languages = [
    'English',
    'Hindi',
    'Spanish',
    'French',
    'German',
    'Chinese',
    'Japanese',
    'Russian',
    'Arabic',
    'Portuguese',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _isbnController.dispose();
    _descriptionController.dispose();
    _pageCountController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _bookCoverImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitBook() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // In a real app, you'd upload the image to storage first
        // and get a URL back
        String coverImageUrl = 'https://via.placeholder.com/150';

        // For demo purposes, we're skipping actual image upload
        if (_bookCoverImage != null) {
          // This would be where you'd upload the image to Firebase Storage
          // coverImageUrl = await _uploadImage(_bookCoverImage!);
        }

        // Create a book object
        // Note: In a real app, you'd get the actual user ID
        final book = Book(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: _titleController.text,
          author: _authorController.text,
          isbn: _isbnController.text,
          owner: 'currentUserId',
          isAvailable: true,
          description: _descriptionController.text,
          genre: _selectedGenre,
          coverImageUrl: coverImageUrl,
          pageCount: int.tryParse(_pageCountController.text) ?? 0,
          language: _selectedLanguage,
        );

        // Add the book to the database
        await Provider.of<BookProvider>(
          context,
          listen: false,
        ).addBook(book, 'currentUserId');

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Book listed successfully!')),
        );

        // Navigate back
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to list book: $e')));
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sell Your Book'), centerTitle: true),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Book Cover Image
                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child:
                              _bookCoverImage != null
                                  ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      _bookCoverImage!,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                  : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(
                                        Icons.add_photo_alternate,
                                        size: 50,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(height: 8),
                                      Text('Add Book Cover Image'),
                                    ],
                                  ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Book Title
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: 'Book Title',
                          prefixIcon: Icon(Icons.book),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the book title';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      // Author
                      TextFormField(
                        controller: _authorController,
                        decoration: const InputDecoration(
                          labelText: 'Author',
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the author';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      // ISBN
                      TextFormField(
                        controller: _isbnController,
                        decoration: const InputDecoration(
                          labelText: 'ISBN',
                          prefixIcon: Icon(Icons.qr_code),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the ISBN';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      // Description
                      TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          prefixIcon: Icon(Icons.description),
                        ),
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a description';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      // Genre dropdown
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Genre',
                          prefixIcon: Icon(Icons.category),
                        ),
                        value: _selectedGenre,
                        items:
                            _genres.map((String genre) {
                              return DropdownMenuItem<String>(
                                value: genre,
                                child: Text(genre),
                              );
                            }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedGenre = newValue;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 12),

                      // Language dropdown
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Language',
                          prefixIcon: Icon(Icons.language),
                        ),
                        value: _selectedLanguage,
                        items:
                            _languages.map((String language) {
                              return DropdownMenuItem<String>(
                                value: language,
                                child: Text(language),
                              );
                            }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedLanguage = newValue;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 12),

                      // Page Count
                      TextFormField(
                        controller: _pageCountController,
                        decoration: const InputDecoration(
                          labelText: 'Page Count',
                          prefixIcon: Icon(Icons.format_list_numbered),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the page count';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      // Submit Button
                      ElevatedButton(
                        onPressed: _submitBook,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'List Your Book',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
