import 'dart:async';
import 'dart:io' show Platform;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
// For desktop (Linux/macOS/Windows) support we initialize the ffi implementation
// which provides a databaseFactory for the global openDatabase API.
import 'package:sqflite_common_ffi/sqflite_ffi.dart' as ffi;

import '../models/client.dart';
import '../models/supplier.dart';
import '../models/stock.dart';

class DBService {
  static final DBService _instance = DBService._internal();
  factory DBService() => _instance;
  DBService._internal();

  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    // On desktop platforms the default sqflite global databaseFactory may not
    // be initialized. Use sqflite_common_ffi and assign its factory so the
    // global openDatabase (used below) works across all platforms.
    if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
      ffi.sqfliteFfiInit();
      databaseFactory = ffi.databaseFactoryFfi;
    }

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'mini_business.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // clients
    await db.execute('''
      CREATE TABLE clients (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT,
        number INTEGER,
        account TEXT,
        pricing TEXT
      )
    ''');

    // suppliers
    await db.execute('''
      CREATE TABLE suppliers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        account TEXT,
        name TEXT,
        email TEXT,
        number INTEGER,
        pricing TEXT
      )
    ''');

    // stock
    await db.execute('''
      CREATE TABLE stock (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        code TEXT,
        name TEXT,
        description TEXT,
        supplier TEXT,
        category TEXT,
        count INTEGER,
        cost REAL,
        price TEXT,
        variations TEXT
      )
    ''');

    // settings (simple key/value)
    await db.execute('''
      CREATE TABLE settings (
        key TEXT PRIMARY KEY,
        value TEXT
      )
    ''');
  }

  // ------- Clients CRUD -------
  Future<int> insertClient(Client c) async {
    final db = await database;
    return await db.insert('clients', c.toMap());
  }

  Future<List<Client>> getClients() async {
    final db = await database;
    final rows = await db.query('clients');
    return rows.map((r) => Client.fromMap(r)).toList();
  }

  Future<int> updateClient(int id, Client c) async {
    final db = await database;
    return await db.update('clients', c.toMap(), where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteClient(int id) async {
    final db = await database;
    return await db.delete('clients', where: 'id = ?', whereArgs: [id]);
  }

  // ------- Suppliers CRUD -------
  Future<int> insertSupplier(Supplier s) async {
    final db = await database;
    return await db.insert('suppliers', s.toMap());
  }

  Future<List<Supplier>> getSuppliers() async {
    final db = await database;
    final rows = await db.query('suppliers');
    return rows.map((r) => Supplier.fromMap(r)).toList();
  }

  Future<int> updateSupplier(int id, Supplier s) async {
    final db = await database;
    return await db.update('suppliers', s.toMap(), where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteSupplier(int id) async {
    final db = await database;
    return await db.delete('suppliers', where: 'id = ?', whereArgs: [id]);
  }

  // ------- Stock CRUD -------
  Future<int> insertStock(Stock s) async {
    final db = await database;
    return await db.insert('stock', s.toMap());
  }

  Future<List<Stock>> getStock() async {
    final db = await database;
    final rows = await db.query('stock');
    return rows.map((r) => Stock.fromMap(r)).toList();
  }

  Future<int> updateStock(int id, Stock s) async {
    final db = await database;
    return await db.update('stock', s.toMap(), where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteStock(int id) async {
    final db = await database;
    return await db.delete('stock', where: 'id = ?', whereArgs: [id]);
  }

  // ------- Settings -------
  Future<void> setSetting(String key, String value) async {
    final db = await database;
    await db.insert('settings', {'key': key, 'value': value}, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<String?> getSetting(String key) async {
    final db = await database;
    final rows = await db.query('settings', where: 'key = ?', whereArgs: [key]);
    if (rows.isEmpty) return null;
    return rows.first['value'] as String?;
  }
}
