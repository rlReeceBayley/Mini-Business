import 'package:flutter/material.dart';

import '../models/stock.dart';
import '../settings/settings_service.dart';
import '../services/db_service.dart';
import 'add_stock.dart';

class StockScreen extends StatefulWidget{
  const StockScreen({super.key});

  @override
  State<StatefulWidget> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen>  {
  List<Stock> stock = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadStock();
  }

  Future<void> _loadStock() async {
    try {
      final db = DBService();
      stock = await db.getStock();

      final settings = SettingsService();
      final expectedVariationCount = settings.priceVariationLabels.length;
      for (final stockItem in stock) {
        if (stockItem.variations.length < expectedVariationCount) {
          stockItem.variations.addAll(List.filled(expectedVariationCount - stockItem.variations.length, 0.0));
        } else if (stockItem.variations.length > expectedVariationCount) {
          stockItem.variations = stockItem.variations.sublist(0, expectedVariationCount);
        }
      }
    } catch (e) {
      debugPrint('Error loading stocks from DB: $e');
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  

  Future<void> _addStock() async {
    final created = await Navigator.push<Stock?>(
      context,
      MaterialPageRoute(builder: (_) => const AddStockScreen()),
    );
    if (created != null) {
      try {
        final db = DBService();
        final id = await db.insertStock(created);
        created.id = id;
        setState(() {
          stock.add(created);
        });
      } catch (e) {
        debugPrint('Error inserting stock into DB: $e');
      }
    }
  }

  Future<void> _editStock(int index) async {
    final edited = await Navigator.push<Stock?>(
      context,
      MaterialPageRoute(builder: (_) => AddStockScreen(stock: stock[index])),
    );
    if (edited != null) {
      try {
        final db = DBService();
        final id = stock[index].id;
        if (id != null) {
          await db.updateStock(id, edited);
          edited.id = id;
        }
        setState(() {
          stock[index] = edited;
        });
      } catch (e) {
        debugPrint('Error updating stock in DB: $e');
      }
    }
  }

  Future<void> _deleteStock(int index) async {
    try {
      final db = DBService();
      final id = stock[index].id;
      if (id != null) await db.deleteStock(id);
    } catch (e) {
      debugPrint('Error deleting stock from DB: $e');
    }
    setState(() {
      stock.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const Center (child: CircularProgressIndicator());
    
    return Scaffold(
      appBar :AppBar(title: const Text('Stock')),
      floatingActionButton: FloatingActionButton(
        onPressed: _addStock, 
        child: const Icon(Icons.add),
        ),
        body: Column(
          children: [
            Container(
              color: Colors.grey.shade200,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Expanded(flex: 2, child: Text('Code', style: TextStyle(fontWeight: FontWeight.bold))),
                  SizedBox(width: 8),
                  Expanded(flex: 3, child: Text('Name', style: TextStyle(fontWeight: FontWeight.bold))),
                  SizedBox(width: 8),
                  Expanded(flex: 1, child: Text('Count', style: TextStyle(fontWeight: FontWeight.bold))),
                  SizedBox(width: 8),
                  Expanded(flex: 1, child: Text('Category', style: TextStyle(fontWeight: FontWeight.bold))),
                  SizedBox(width: 8),
                  Expanded(flex: 1, child: Text('Cost', style: TextStyle(fontWeight: FontWeight.bold))),
                  SizedBox(width: 8),
                  Expanded(flex: 1, child: Text('Price', style: TextStyle(fontWeight: FontWeight.bold)))
                ],
              ),
            ),
            Expanded(child: stock.isEmpty
            ? const Center(child: Text("No Stock has been added, let's change that :D"))
            : ListView.separated(itemCount: stock.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final item = stock[index];
                      return Dismissible(
                        key: ValueKey(stock.hashCode + index),
                        direction: DismissDirection.horizontal,
                        secondaryBackground: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.delete, color: Colors.white)
                          ),
                          background: Container(
                            color: Colors.blue,
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: 20),
                            child: const Icon(Icons.edit, color: Colors.white,),
                          ),
                          confirmDismiss: (direction) async {
                            if (direction == DismissDirection.endToStart) {
                              // delete
                              await _deleteStock(index);
                              return true; // allow dismissal (removes the widget)
                            } else if (direction == DismissDirection.startToEnd) {
                              // edit - open editor and do NOT dismiss
                              await _editStock(index);
                              return false; // do not dismiss
                            }
                            return false;
                          },
                          child: InkWell(
                            onTap: ()=> _editStock(index),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              child: Row(children: [
                                Expanded(flex:2 , child: Text(item.code, overflow: TextOverflow.ellipsis,)),
                                const SizedBox(width: 8),
                                Expanded(flex:3 , child: Text(item.name, overflow: TextOverflow.ellipsis,)),
                                const SizedBox(width: 8),
                                Expanded(flex:1 , child: Text(item.count.toString(), overflow: TextOverflow.ellipsis,)),
                                const SizedBox(width: 8),
                                Expanded(flex:1 , child: Text(item.category, overflow: TextOverflow.ellipsis,)),
                                const SizedBox(width: 8),
                                Expanded(flex:1 , child: Text(item.cost.toString(), overflow: TextOverflow.ellipsis,)),
                                const SizedBox(width: 8),
                                Expanded(flex:1 , child: Text(item.variations.toString(), overflow: TextOverflow.ellipsis,)),
                                const SizedBox(width: 8),
                              ],),),
                          )
                        );                   
                      }
                    )
            )
          ],
        ),

    );
  }
}