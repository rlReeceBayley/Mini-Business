import 'package:flutter/material.dart';
import '../models/supplier.dart';

class AddSupplierScreen extends StatefulWidget {
  final Supplier? supplier;
  const AddSupplierScreen({super.key, this.supplier});

  @override
  State<AddSupplierScreen> createState() => _AddSupplierScreenState();
}

class _AddSupplierScreenState extends State<AddSupplierScreen> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final numberCtrl = TextEditingController();
  final accountCtrl = TextEditingController();


  @override
  void initState() {
    super.initState();
    final supplier = widget.supplier;
    if (supplier != null) {
      nameCtrl.text = supplier.name;
      emailCtrl.text = supplier.email;
      accountCtrl.text = supplier.account;
      numberCtrl.text = supplier.number.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Supplier")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: "Name")),
            TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: "Email")),
            TextField(controller: numberCtrl, decoration: const InputDecoration(labelText: "Number")),
            const SizedBox(height: 20),
            TextField(controller: accountCtrl, decoration: const InputDecoration(labelText: "Account")),
            ElevatedButton(
              onPressed: () {
                final parsedNumber = int.tryParse(numberCtrl.text.trim()) ?? 0;
                if (nameCtrl.text.isNotEmpty) {
                  final returned = Supplier(accountCtrl.text, nameCtrl.text, emailCtrl.text, parsedNumber, '', id: widget.supplier?.id);
                  Navigator.pop(
                    context,
                    returned,
                  );
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
