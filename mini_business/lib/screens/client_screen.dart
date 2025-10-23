import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

import '../models/client.dart';
import 'add_client.dart';

class ClientScreen extends StatefulWidget {
  const ClientScreen({super.key});

  @override
  State<ClientScreen> createState() => _ClientScreenState();
}

class _ClientScreenState extends State<ClientScreen> {
  static const _prefsKey = 'clients_json';
  List<Client> clients = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadClients();
  }

  Future<void> _loadClients() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_prefsKey);
      if (raw != null && raw.isNotEmpty) {
        final List<dynamic> decoded = json.decode(raw) as List<dynamic>;
        clients = decoded.map((e) => Client.fromJson(Map<String, dynamic>.from(e as Map))).toList();
      }
    } on MissingPluginException catch (e) {
      // Plugin isn't registered on this platform (often happens during
      // hot-reload after adding a plugin or on unsupported platforms).
      // Fall back to in-memory only and inform via debug log.
      debugPrint('SharedPreferences plugin missing: $e');
    } catch (e) {
      debugPrint('Error loading clients: $e');
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> _saveClients() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encoded = json.encode(clients.map((c) => c.toJson()).toList());
      await prefs.setString(_prefsKey, encoded);
    } on MissingPluginException catch (e) {
      debugPrint('SharedPreferences plugin missing (save): $e');
    } catch (e) {
      debugPrint('Error saving clients: $e');
    }
  }

  Future<void> _addClient() async {
    final created = await Navigator.push<Client?>(
      context,
      MaterialPageRoute(builder: (_) => const AddClientScreen()),
    );
    if (created != null) {
      setState(() {
        clients.add(created);
      });
      await _saveClients();
    }
  }

  Future<void> _editClient(int index) async {
    final edited = await Navigator.push<Client?>(
      context,
      MaterialPageRoute(builder: (_) => AddClientScreen(client: clients[index])),
    );
    if (edited != null) {
      setState(() {
        clients[index] = edited;
      });
      await _saveClients();
    }
  }

  Future<void> _deleteClient(int index) async {
    setState(() {
      clients.removeAt(index);
    });
    await _saveClients();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const Center(child: CircularProgressIndicator());

    return Scaffold(
      appBar: AppBar(title: const Text('Clients')),
      floatingActionButton: FloatingActionButton(
        onPressed: _addClient,
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
                Expanded(flex: 1, child: Text('Number', style: TextStyle(fontWeight: FontWeight.bold))),
                SizedBox(width: 8),
                Expanded(flex: 1, child: Text('Pricing', style: TextStyle(fontWeight: FontWeight.bold))),
                SizedBox(width: 8),
                Expanded(flex: 1, child: Text('Account', style: TextStyle(fontWeight: FontWeight.bold))),
              ],
            ),
          ),
          Expanded(
            child: clients.isEmpty
                ? const Center(child: Text('No clients saved'))
                : ListView.separated(
                    itemCount: clients.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final client = clients[index];
                      return Dismissible(
                        key: ValueKey(client.hashCode + index),
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
                            await _deleteClient(index);
                            return true; // allow dismissal (removes the widget)
                          } else if (direction == DismissDirection.startToEnd) {
                            // edit - open editor and do NOT dismiss
                            await _editClient(index);
                            return false; // do not dismiss
                          }
                          return false;
                        },
                        child: InkWell(
                          onTap: () => _editClient(index),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            child: Row(
                              children: [
                                Expanded(flex: 2, child: Text(client.name, overflow: TextOverflow.ellipsis)),
                                const SizedBox(width: 8),
                                Expanded(flex: 3, child: Text(client.email, overflow: TextOverflow.ellipsis)),
                                const SizedBox(width: 8),
                                Expanded(flex: 1, child: Text(client.number.toString())),
                                const SizedBox(width: 8),
                                Expanded(flex: 1, child: Text(client.pricing, overflow: TextOverflow.ellipsis)),
                                const SizedBox(width: 8),
                                Expanded(flex: 1, child: Text(client.account, overflow: TextOverflow.ellipsis)),
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
