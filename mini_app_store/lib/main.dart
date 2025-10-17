import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/product.dart';
import 'providers.dart';
import 'screens/home_screen.dart';
import 'screens/details_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // ⚙️ If you're using Firebase later, uncomment the next two lines:
  // await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider(
      create: (_) => FavoritesProvider(),
      child: const MiniStoreApp(),
    ),
  );
}

class MiniStoreApp extends StatelessWidget {
  const MiniStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mini Store',
      theme: ThemeData(
        colorSchemeSeed: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      routes: {
        DetailsScreen.routeName: (ctx) => const DetailsScreenWrapper(),
      },
    );
  }
}

// ...existing code...
class DetailsScreenWrapper extends StatelessWidget {
  const DetailsScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final route = ModalRoute.of(context);
    final args = route?.settings.arguments;
    if (args is! Product) {
      return Scaffold(
        appBar: AppBar(title: const Text('Details')),
        body: const Center(child: Text('Product not found')),
      );
    }
    return DetailsScreen(product: args);
  }
}
