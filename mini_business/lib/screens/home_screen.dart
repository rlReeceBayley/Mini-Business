import 'package:flutter/material.dart';
import 'client_screen.dart';
import 'supplier_screen.dart';
import 'stock_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _fabOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mini Business'),
        foregroundColor: Colors.black,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 35),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {},
                    child: const Text('Invoice'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 35),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {},
                    child: const Text('Quote'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(vertical: 35),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                          setState(() => _fabOpen = false);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const StockScreen()),
                          );},
                    child: const Text('Stock'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 35),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {},
                    child: const Text('Purchase Order'),
                  ),
                ),
              ],
            ),
          ),

          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Recent Sales',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),

          Expanded(
            child: Center(
              child: Text(
                'Placeholder for Recent Sales',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Stack(
        clipBehavior: Clip.none,
        children: [
          if (_fabOpen) ...[
            Positioned(
              bottom: 140,
              right: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      FloatingActionButton.small(
                        heroTag: 'clients',
                        onPressed: () {
                          setState(() => _fabOpen = false);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const ClientScreen()),
                          );
                        },
                        tooltip: 'Clients',
                        child: const Icon(Icons.people),
                      ),
                      const SizedBox(height: 6),
                      const Text('Clients', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Column(
                    children: [
                      FloatingActionButton.small(
                        heroTag: 'suppliers',
                        onPressed: () {
                          setState(() => _fabOpen = false);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const SupplierScreen()),
                          );
                        },
                        tooltip: 'Suppliers',
                        child: const Icon(Icons.store),
                      ),
                      const SizedBox(height: 6),
                      const Text('Suppliers', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Column(
                    children: [
                      FloatingActionButton.small(
                        heroTag: 'goods',
                        onPressed: () {},
                        tooltip: 'Goods Received',
                        child: const Icon(Icons.inventory),
                      ),
                      const SizedBox(height: 6),
                      const Text('Receiving', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Column(
                    children: [
                      FloatingActionButton.small(
                        heroTag: 'credits',
                        onPressed: () {},
                        tooltip: 'Credits',
                        child: const Icon(Icons.credit_card),
                      ),
                      const SizedBox(height: 6),
                      const Text('Credits', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Column(
                    children: [
                      FloatingActionButton.small(
                        heroTag: 'accounting',
                        onPressed: () {},
                        tooltip: 'Accounting',
                        child: const Icon(Icons.account_balance),
                      ),
                      const SizedBox(height: 6),
                      const Text('Accounting', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
          ],
          Positioned(
            bottom: 16,
            right: 0,
            child: FloatingActionButton(
              child: Icon(_fabOpen ? Icons.close : Icons.menu),
              onPressed: () => setState(() => _fabOpen = !_fabOpen),
            ),
          ),
        ],
      ),
    );
  }
}

