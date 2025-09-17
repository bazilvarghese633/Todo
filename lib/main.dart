// lib/main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_b1/repository/todo_repo.dart';
import 'package:todo_b1/screens/home.dart';
import 'firebase_options.dart';
import 'package:todo_b1/bloc/todo_bloc.dart';
import 'package:todo_b1/core/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Firebase for all supported platforms
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("Firebase initialized successfully");

    // Create repository instance
    final todoRepository = TodoRepository();

    // Sign in anonymously for demo purposes
    final success = await todoRepository.signInAnonymously();
    if (!success) {
      print(
        "Failed to sign in anonymously. Please check Firebase Console settings.",
      );
    }

    runApp(MyApp(todoRepository: todoRepository));
  } catch (e) {
    print("Error initializing Firebase: $e");
    // You might want to show an error screen here
    runApp(const ErrorApp());
  }
}

class MyApp extends StatelessWidget {
  final TodoRepository todoRepository;

  const MyApp({super.key, required this.todoRepository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodoBloc(todoRepository: todoRepository),
      child: MaterialApp(
        title: 'Todo B1',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: surface,
          appBarTheme: const AppBarTheme(
            backgroundColor: surface,
            elevation: 0,
          ),
          colorScheme: ColorScheme.dark(
            primary: primary,
            surface: surface,
            onSurface: onSurface,
          ),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}

class ErrorApp extends StatelessWidget {
  const ErrorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, size: 64, color: Colors.red),
              SizedBox(height: 16),
              Text(
                'Firebase initialization failed',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('Please check your Firebase configuration'),
            ],
          ),
        ),
      ),
    );
  }
}
