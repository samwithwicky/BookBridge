import 'package:bookbridge/screens/location_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'themes/themes.dart';

// Screens
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/book_details_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/sell_screen.dart';
import 'screens/cart_screen.dart'; // New cart screen (to be created) // New wishlist screen (to be created)
import 'login/signup.dart';
import 'login/reset_password.dart';

// Providers
import 'providers/auth_provider.dart';
import 'providers/book_provider.dart';
import 'providers/user_provider.dart';
import 'providers/location_provider.dart';
import 'providers/cart_provider.dart'; // New cart provider (to be created)
import 'providers/order_provider.dart'; // New order provider (to be created)// New wishlist provider (to be created)

// Models
import 'models/book.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => BookProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => LocationProvider()),
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
        ), // Add cart provider
        ChangeNotifierProvider(
          create: (context) => OrderProvider(),
        ), // Add order provider // Add wishlist provider
      ],
      child: const BookBridgeApp(),
    ),
  );
}

class BookBridgeApp extends StatelessWidget {
  const BookBridgeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'BookBridge',
          theme: bookBridgeTheme(),
          initialRoute: '/login',
          routes: {
            '/login': (context) => const LoginScreen(),
            '/signup': (context) => const SignUpScreen(),
            '/reset-password': (context) => const ResetPasswordScreen(),
            '/home': (context) => const HomeScreen(),
            '/profile': (context) => const ProfileScreen(),
            '/sell': (context) => const SellBookScreen(),
            '/location': (context) => const LocationSelectionScreen(),
            '/cart': (context) => const CartScreen(),
          },
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case '/book-details':
                final Book book = settings.arguments as Book;
                return MaterialPageRoute(
                  builder: (context) => BookDetailsScreen(book: book),
                );
              default:
                return null;
            }
          },
        );
      },
    );
  }
}
