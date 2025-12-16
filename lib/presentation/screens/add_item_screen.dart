import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/shopping_list.dart';
import '../providers/shopping_provider.dart';

class AddItemScreen extends StatefulWidget {
  final String listId;
  const AddItemScreen({super.key, required this.listId});
  @override State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController(text: '1');
  final _priceController = TextEditingController();
  String _selectedCategory = 'Groceries';
  final List<String> _categories = ['Groceries','Beverages','Vegetables/Fruits','Dairy','Meat/Fish','Grocery','Household','Cosmetics','Other'];

  @override void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Item'), actions: [IconButton(icon: const Icon(Icons.check), onPressed: _saveItem)]),
      body: Padding(padding: const EdgeInsets.all(16), child: Form(key: _formKey, child: Column(children: [
        TextFormField(controller: _nameController, decoration: const InputDecoration(labelText: 'Item Name', border: OutlineInputBorder(), prefixIcon: Icon(Icons.shopping_bag)), validator: (value) => value == null || value.isEmpty ? 'Enter name' : null),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(child: TextFormField(controller: _quantityController, decoration: const InputDecoration(labelText: 'Quantity', border: OutlineInputBorder(), prefixIcon: Icon(Icons.numbers)), keyboardType: TextInputType.number, validator: (value) {
            if (value == null || value.isEmpty) return 'Enter quantity';
            if (int.tryParse(value) == null) return 'Enter number';
            return null;
          })),
          const SizedBox(width: 16),
          Expanded(child: TextFormField(controller: _priceController, decoration: const InputDecoration(labelText: 'Price (₸)', border: OutlineInputBorder(), prefixIcon: Icon(Icons.attach_money)), keyboardType: TextInputType.number, validator: (value) {
            if (value == null || value.isEmpty) return 'Enter price';
            if (double.tryParse(value) == null) return 'Enter number';
            return null;
          })),
        ]),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(value: _selectedCategory, decoration: const InputDecoration(labelText: 'Category', border: OutlineInputBorder(), prefixIcon: Icon(Icons.category)), items: _categories.map((category) => DropdownMenuItem(value: category, child: Text(category))).toList(), onChanged: (value) {
          if (value != null) setState(() => _selectedCategory = value);
        }),
        const SizedBox(height: 24),
        Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Preview:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          Text('Item: ${_nameController.text}'),
          Text('Quantity: ${_quantityController.text} pcs'),
          Text('Price per piece: ${_priceController.text}₸'),
          Text('Category: $_selectedCategory'),
          const SizedBox(height: 12),
          if (_priceController.text.isNotEmpty && _quantityController.text.isNotEmpty) Text('Total: ${(double.tryParse(_priceController.text) ?? 0) * (int.tryParse(_quantityController.text) ?? 1)}₸', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green)),
        ]))),
        const Spacer(),
        SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: _saveItem, icon: const Icon(Icons.add), label: const Text('Add Item'), style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)))),
      ]))),
    );
  }

  void _saveItem() {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<ShoppingProvider>(context, listen: false);
      final newItem = ShoppingItem(id: DateTime.now().millisecondsSinceEpoch.toString(), name: _nameController.text, quantity: int.parse(_quantityController.text), price: double.parse(_priceController.text), category: _selectedCategory);
      provider.addItemToList(widget.listId, newItem);
      Navigator.pop(context);
    }
  }
}