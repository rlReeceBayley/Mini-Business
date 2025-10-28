import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  /// Migrate existing JSON stored in SharedPreferences into SQLite tables.
  ///
  /// This method is idempotent: it checks for existing rows using simple
  /// natural keys (clients: name+account, suppliers: name+account, stock: code)
  /// and only inserts rows that don't already exist. If [clearAfter] is true
  /// the old SharedPreferences keys will be removed after migration.
  Future<Map<String, int>> migrateFromSharedPreferences({bool clearAfter = false}) async {
    final result = {'clients': 0, 'suppliers': 0, 'stock': 0};
    final prefs = await SharedPreferences.getInstance();

    // Clients
    try {
      final rawClients = prefs.getString('clients_json');
      if (rawClients != null && rawClients.isNotEmpty) {
        final List<dynamic> decoded = json.decode(rawClients) as List<dynamic>;
        final existing = await getClients();
        for (final e in decoded) {
          final map = Map<String, dynamic>.from(e as Map);
          final client = Client.fromJson(map);
          final exists = existing.any((c) => c.name == client.name && c.account == client.account);
          if (!exists) {
            final id = await insertClient(client);
            client.id = id;
            result['clients'] = result['clients']! + 1;
          }
        }
        if (clearAfter) await prefs.remove('clients_json');
      }
    } catch (e) {
      debugPrint('Error migrating clients: $e');
    }

    // Suppliers
    try {
      final rawSuppliers = prefs.getString('suppliers_json');
      if (rawSuppliers != null && rawSuppliers.isNotEmpty) {
        final List<dynamic> decoded = json.decode(rawSuppliers) as List<dynamic>;
        final existing = await getSuppliers();
        for (final e in decoded) {
          final map = Map<String, dynamic>.from(e as Map);
          final supplier = Supplier.fromJson(map);
          final exists = existing.any((s) => s.name == supplier.name && s.account == supplier.account);
          if (!exists) {
            final id = await insertSupplier(supplier);
            supplier.id = id;
            result['suppliers'] = result['suppliers']! + 1;
          }
        }
        if (clearAfter) await prefs.remove('suppliers_json');
      }
    } catch (e) {
      debugPrint('Error migrating suppliers: $e');
    }

    // Stock
    try {
      final rawStock = prefs.getString('stock_json');
      if (rawStock != null && rawStock.isNotEmpty) {
        final List<dynamic> decoded = json.decode(rawStock) as List<dynamic>;
        final existing = await getStock();
        for (final e in decoded) {
          final map = Map<String, dynamic>.from(e as Map);
          final stockItem = Stock.fromJson(map);
          final exists = existing.any((s) => s.code == stockItem.code);
          if (!exists) {
            final id = await insertStock(stockItem);
            stockItem.id = id;
            result['stock'] = result['stock']! + 1;
          }
        }
        if (clearAfter) await prefs.remove('stock_json');
      }
    } catch (e) {
      debugPrint('Error migrating stock: $e');
    }

    return result;
  }
}
