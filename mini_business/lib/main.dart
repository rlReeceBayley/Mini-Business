import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'services/db_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // initialize DB and run a one-time migration from SharedPreferences
  try {
    final db = DBService();
    await db.database; // ensure DB is created and ready
    final res = await db.migrateFromSharedPreferences(clearAfter: false);
    debugPrint('Migration result: $res');
  } catch (e) {
    debugPrint('Migration error: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mini-Business',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}
