import 'package:flutter/material.dart';
import '../models/client.dart';

class AddClientScreen extends StatefulWidget {
  const AddClientScreen({super.key});

  @override
  State<AddClientScreen> createState() => _AddClientScreenState();
}

typedef ColorEntry = DropdownMenuEntry<ColorLabel>;

// DropdownMenuEntry labels and values for the first dropdown menu.
enum ColorLabel {
  blue('Blue', Colors.blue),
  pink('Pink', Colors.pink),
  green('Green', Colors.green),
  yellow('Orange', Colors.orange),
  grey('Grey', Colors.grey);

  const ColorLabel(this.label, this.color);
  final String label;
  final Color color;
}

class _AddClientScreenState extends State<AddClientScreen> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final numberCtrl = TextEditingController();
  final pricingCtrl = TextEditingController();
  final accountCtrl = TextEditingController();
  final List<String> options = ["Retail", "Trade", "Key Account"];
  String? selectedOption;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Client")),
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
                if (nameCtrl.text.isNotEmpty) {
                  Navigator.pop(context, Client(nameCtrl.text, emailCtrl.text));
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
