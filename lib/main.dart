import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/home/screens/home.dart';

Future<void> main() async {
  try {
    await dotenv.load(fileName: ".env");
  } catch (e, stackTrace) {
    print('Failed to load .env file: $e');
    print(stackTrace);
  }
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(
      child: MyApp())
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Home(),
    );
  }
}