import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/stock.dart';
 
import '../settings/settings_service.dart';
import '../services/db_service.dart';

class AddStockScreen extends StatefulWidget {
  final Stock? stock;
  const AddStockScreen({super.key, this.stock});

  @override
  State<AddStockScreen> createState() => _AddStockScreenState();
}

class _AddStockScreenState extends State<AddStockScreen> {
  final codeCtrl = TextEditingController();
  final nameCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();
  final supplierCtrl = TextEditingController();
  List<String> supplierOptions = [];
  final countCtrl = TextEditingController();
  final costCtrl = TextEditingController();
  final categoryCtrl = TextEditingController();
  final priceCtrl = TextEditingController();
  final List<TextEditingController> variationCtrls = [];
  final settings = SettingsService();
  bool _supplierListenerAdded = false;

  @override
  void initState() {
    super.initState();
    // Create a controller for each price variation label
    for (int i = 0; i < settings.priceVariationLabels.length; i++) {
      variationCtrls.add(TextEditingController());
    }
    _loadSuppliers();
    
    final stock = widget.stock;
    if (stock != null) {
      codeCtrl.text = stock.code;
      nameCtrl.text = stock.name;
      descriptionCtrl.text = stock.description;
      supplierCtrl.text = stock.supplier;
      categoryCtrl.text = stock.category;
      countCtrl.text = stock.count.toString();
      costCtrl.text = stock.cost.toString();
      
      // Populate variations from existing stock
      for (int i = 0; i < stock.variations.length && i < variationCtrls.length; i++) {
        variationCtrls[i].text = stock.variations[i].toString();
      }
    }
  }

  Future<void> _loadSuppliers() async {
    try {
      final db = DBService();
      final suppliers = await db.getSuppliers();
      setState(() {
        supplierOptions = suppliers.map((s) => s.name).toList();
      });
    } catch (e) {
      debugPrint('Error loading suppliers for autocomplete: $e');
    }
  }

  void addPriceTextField() {
    setState(() {
      variationCtrls.add(TextEditingController());
    });
  }

  @override
  void dispose() {
    // dispose controllers
    codeCtrl.dispose();
    nameCtrl.dispose();
    descriptionCtrl.dispose();
    supplierCtrl.dispose();
    countCtrl.dispose();
    costCtrl.dispose();
    categoryCtrl.dispose();
    priceCtrl.dispose();
    for (final c in variationCtrls) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Stock")),
      body: SingleChildScrollView(
  padding: const EdgeInsets.all(16),
  child: Column(
    children: [
      LayoutBuilder(
    builder: (context, constraints) {
      final leftFields = <Widget>[
        TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: "Name")),
        const SizedBox(height: 8),
        TextField(controller: codeCtrl, decoration: const InputDecoration(labelText: "Item Code")),
        const SizedBox(height: 8),
        TextField(controller: descriptionCtrl, decoration: const InputDecoration(labelText: "Description")),
        TextField(controller: categoryCtrl, decoration: const InputDecoration(labelText: "Category")),
      ];

      final rightFields = <Widget>[
        // Autocomplete for supplier (reads names from saved suppliers)
        SizedBox(
          width: double.infinity,
          child: Autocomplete<String>(
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text.isEmpty) return const Iterable<String>.empty();
              return supplierOptions.where((option) => option.toLowerCase().contains(textEditingValue.text.toLowerCase()));
            },
            fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
              // initialize and add a single listener to copy user input into supplierCtrl
              controller.text = supplierCtrl.text;
              controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));
              if (!_supplierListenerAdded) {
                controller.addListener(() {
                  supplierCtrl.text = controller.text;
                });
                _supplierListenerAdded = true;
              }
              return TextField(
                controller: controller,
                focusNode: focusNode,
                decoration: const InputDecoration(labelText: "Supplier"),
              );
            },
            onSelected: (String selection) {
              supplierCtrl.text = selection;
            },
            optionsViewBuilder: (context, onSelected, options) {
              return Align(
                alignment: Alignment.topLeft,
                child: Material(
                  elevation: 4.0,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 200, maxWidth: 300),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: options.length,
                      itemBuilder: (BuildContext context, int index) {
                        final String option = options.elementAt(index);
                        return ListTile(
                          title: Text(option),
                          onTap: () => onSelected(option),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: costCtrl,
          decoration: const InputDecoration(labelText: "Cost"),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: countCtrl,
          decoration: const InputDecoration(labelText: "Number of Items"),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
        const SizedBox(height: 18),
        // Price variations with fixed labels
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Price Variations', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                for (var i = 0; i < settings.priceVariationLabels.length; i++)
                  SizedBox(
                    width: 160,
                    child: TextField(
                      controller: variationCtrls[i],
                      decoration: InputDecoration(
                        labelText: settings.priceVariationLabels[i],
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ];

      if (constraints.maxWidth >= 600) {
        // two columns side-by-side on wide screens
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: Column(children: leftFields)),
            const SizedBox(width: 16),
            Expanded(child: Column(children: rightFields)),
            // then below the chips / category / save button add them after the Row
            
          ],
        );
      } else {
        // stacked vertically on narrow screens
        return Column(
          children: [
            ...leftFields,
            const SizedBox(height: 12),
            ...rightFields,
          ],
        );
      }
    },
  ),
      const SizedBox(height: 16),
      // Pricing variations chips / category / save button
      const SizedBox(height: 8),
      ElevatedButton(
        onPressed: () {
          final parsedcost = double.tryParse(costCtrl.text.trim()) ?? 0.0;
          final parsedCount = int.tryParse(countCtrl.text.trim()) ?? 0;
          final parsedVariations = variationCtrls.map((c) => double.tryParse(c.text) ?? 0.0).toList();
          final priceLabels = settings.priceVariationLabels.join(', ');
          if (nameCtrl.text.isNotEmpty) {
            Navigator.pop(
              context,
              Stock(
                codeCtrl.text,
                nameCtrl.text,
                descriptionCtrl.text,
                supplierCtrl.text,
                categoryCtrl.text,
                parsedCount,
                parsedcost,
                priceLabels,
                parsedVariations,
              ),
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
