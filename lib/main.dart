import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/login.dart';
import 'screens/dashboard.dart';
import 'screens/access_denied.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://mraiwhzmmvnfemqokegd.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1yYWl3aHptbXZuZmVtcW9rZWdkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTU0MTE3MjYsImV4cCI6MjA3MDk4NzcyNn0.DqP_Xd3iNqlsQ41P3wpILYRhwOaQd6r3gWYK4qcWFo8',
  );
  runApp(const FamilyNestApp());
}

class FamilyNestApp extends StatelessWidget {
  const FamilyNestApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FamilyNest',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/access-denied': (context) => const AccessDeniedScreen(),
      },
    );
  }
}
