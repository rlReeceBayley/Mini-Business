import 'package:flutter/material.dart';
import 'add_client.dart';
import '../models/client.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Client> clients = [];

  void addClient(Client client) {
    setState(() {
      clients.add(client);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mini Business"), foregroundColor: Colors.black,),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final newClient = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddClientScreen()),
          );
          if (newClient != null) addClient(newClient);
        },
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
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      foregroundColor: Colors.white,
                      fixedSize: Size(125, 75)
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
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      foregroundColor: Colors.white,
                      fixedSize: Size(125, 75),
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
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      foregroundColor: Colors.white,
                      fixedSize: Size(125, 75)
                    ),
                    onPressed: () {},
                    child: const Text('Stock'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      foregroundColor: Colors.white,
                      fixedSize: Size(125, 75)
                    ),
                    onPressed: () {},
                    child: const Text('Credit'),
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
            child: ListView.builder(
              itemCount: clients.length,
              itemBuilder: (context, index) {
                final client = clients[index];
                return ListTile(
                  title: Text(client.name),
                  subtitle: Text(client.email),
                );
              },
            ),
          ),
          
        ],
      ),
    );
  }
}
