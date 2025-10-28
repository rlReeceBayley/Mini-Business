import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'services/db_service.dart';
import 'local_server.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // initialize DB (SQLite) - no JSON/SharedPreferences migration
  try {
    await DBService().database; // ensure DB is created and ready
  } catch (e) {
    debugPrint('DB initialization error: $e');
  }
  try {
    await startLocalServer(); // runs in background

  } catch (e){
    debugPrint('server initialization error: $e');
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
