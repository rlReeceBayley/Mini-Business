import 'package:flutter/material.dart';
import '../models/client.dart';

class AddClientScreen extends StatefulWidget {
  final Client? client;
  const AddClientScreen({super.key, this.client});

  @override
  State<AddClientScreen> createState() => _AddClientScreenState();
}

class _AddClientScreenState extends State<AddClientScreen> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final numberCtrl = TextEditingController();
  final accountCtrl = TextEditingController();
  final List<String> options = ["Retail", "Trade", "Key Account"];
  String? selectedOption;

  @override
  void initState() {
    super.initState();
    final client = widget.client;
    if (client != null) {
      nameCtrl.text = client.name;
      emailCtrl.text = client.email;
      accountCtrl.text = client.account;
      numberCtrl.text = client.number.toString();
      selectedOption = client.pricing;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Client")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: "Name")),
            TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: "Email")),
            TextField(controller: numberCtrl, decoration: const InputDecoration(labelText: "Number")),
            const SizedBox(height: 20),
            
            Wrap(
                spacing: 10,
                children: options.map((option) {
                  return ChoiceChip(
                    label: Text(option),
                    selected: selectedOption == option,
                    onSelected: (bool selected) {
                      setState(() {
                        selectedOption = selected ? option : null;
                      });
                    },
                    selectedColor: Colors.blue,
                    labelStyle: TextStyle(
                      color: selectedOption == option ? Colors.white : Colors.black,
                    ),
                  );
                }).toList(),
                
              ),
              TextField(controller: accountCtrl, decoration: const InputDecoration(labelText: "Account")),
            ElevatedButton(
              onPressed: () {
                final parsedNumber = int.tryParse(numberCtrl.text.trim()) ?? 0;
                if (nameCtrl.text.isNotEmpty) {
                  // preserve id when editing
                  final returned = Client(accountCtrl.text, nameCtrl.text, emailCtrl.text, parsedNumber, selectedOption ?? '', id: widget.client?.id);
                  Navigator.pop(context, returned);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a name')));
                }
              },
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
