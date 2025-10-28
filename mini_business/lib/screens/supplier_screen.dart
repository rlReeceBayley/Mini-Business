import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/supplier.dart';
import '../services/db_service.dart';
import 'add_supplier.dart';

class SupplierScreen extends StatefulWidget {
  const SupplierScreen({super.key});

  @override
  State<SupplierScreen> createState() => _SupplierScreenState();
}

class _SupplierScreenState extends State<SupplierScreen> {
  List<Supplier> suppliers = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadSuppliers();
  }

  Future<void> _loadSuppliers() async {
    try {
      final db = DBService();
      suppliers = await db.getSuppliers();
    } catch (e) {
      debugPrint('Error loading suppliers from DB: $e');
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  

  Future<void> _addSupplier() async {
    final created = await Navigator.push<Supplier?>(
      context,
      MaterialPageRoute(builder: (_) => const AddSupplierScreen()),
    );
    if (created != null) {
      try {
        final db = DBService();
        final id = await db.insertSupplier(created);
        created.id = id;
        setState(() {
          suppliers.add(created);
        });
      } catch (e) {
        debugPrint('Error inserting supplier into DB: $e');
      }
    }
  }

  Future<void> _editSupplier(int index) async {
    final edited = await Navigator.push<Supplier?>(
      context,
      MaterialPageRoute(builder: (_) => AddSupplierScreen(supplier: suppliers[index])),
    );
    if (edited != null) {
      try {
        final db = DBService();
        final id = suppliers[index].id;
        if (id != null) {
          await db.updateSupplier(id, edited);
          edited.id = id;
        }
        setState(() {
          suppliers[index] = edited;
        });
      } catch (e) {
        debugPrint('Error updating supplier in DB: $e');
      }
    }
  }

  Future<void> _deleteSupplier(int index) async {
    try {
      final db = DBService();
      final id = suppliers[index].id;
      if (id != null) await db.deleteSupplier(id);
    } catch (e) {
      debugPrint('Error deleting supplier from DB: $e');
    }
    setState(() {
      suppliers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const Center(child: CircularProgressIndicator());

    return Scaffold(
      appBar: AppBar(title: const Text('Suppliers')),
      floatingActionButton: FloatingActionButton(
        onPressed: _addSupplier,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.grey.shade200,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: const [
                Expanded(flex: 2, child: Text('Name', style: TextStyle(fontWeight: FontWeight.bold))),
                SizedBox(width: 8),
                Expanded(flex: 3, child: Text('Email', style: TextStyle(fontWeight: FontWeight.bold))),
                SizedBox(width: 8),
                Expanded(flex: 1, child: Text('Phone', style: TextStyle(fontWeight: FontWeight.bold))),
                SizedBox(width: 8),
                Expanded(flex: 1, child: Text('Account', style: TextStyle(fontWeight: FontWeight.bold))),
              ],
            ),
          ),
          Expanded(
            child: suppliers.isEmpty
                ? const Center(child: Text('No suppliers saved'))
                : ListView.separated(
                    itemCount: suppliers.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final supplier = suppliers[index];
                      return Dismissible(
                        key: ValueKey(supplier.hashCode + index),
                        // Allow swiping both ways; we'll handle actions in confirmDismiss
                        direction: DismissDirection.horizontal,
                        // Left swipe (endToStart) - delete
                        secondaryBackground: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        // Right swipe (startToEnd) - edit
                        background: Container(
                          color: Colors.blue,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(left: 20),
                          child: const Icon(Icons.edit, color: Colors.white),
                        ),
                        confirmDismiss: (direction) async {
                          if (direction == DismissDirection.endToStart) {
                            // delete
                            await _deleteSupplier(index);
                            return true; // allow dismissal (removes the widget)
                          } else if (direction == DismissDirection.startToEnd) {
                            // edit - open editor and do NOT dismiss
                            await _editSupplier(index);
                            return false; // do not dismiss
                          }
                          return false;
                        },
                        child: InkWell(
                          onTap: () => _editSupplier(index),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            child: Row(
                              children: [
                                Expanded(flex: 2, child: Text(supplier.name, overflow: TextOverflow.ellipsis)),
                                const SizedBox(width: 8),
                                Expanded(flex: 3, child: Text(supplier.email, overflow: TextOverflow.ellipsis)),
                                const SizedBox(width: 8),
                                Expanded(flex: 1, child: Text(supplier.number.toString())),
                                const SizedBox(width: 8),
                                Expanded(flex: 1, child: Text(supplier.account, overflow: TextOverflow.ellipsis)),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
