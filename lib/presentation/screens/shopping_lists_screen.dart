import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/shopping_provider.dart';
import 'add_item_screen.dart';
import '../../data/models/shopping_list.dart';

class ShoppingListsScreen extends StatefulWidget {
  const ShoppingListsScreen({super.key});

  @override
  State<ShoppingListsScreen> createState() => _ShoppingListsScreenState();
}

class _ShoppingListsScreenState extends State<ShoppingListsScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ShoppingProvider>(context);
    final shoppingLists = provider.shoppingLists;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Lists'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () {
              _showDateDialog(context);
            },
          ),
        ],
      ),
      body: shoppingLists.isEmpty
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 80,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No shopping lists',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            Text(
              'Create your first list!',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: shoppingLists.length,
        itemBuilder: (context, index) {
          final list = shoppingLists[index];
          final progress = list.progress;

          return GestureDetector(
            onTap: () {
              _showListDetails(context, list);
            },
            child: Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.green.shade100,
                          child: Icon(
                            Icons.shopping_cart,
                            color: Colors.green.shade800,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                list.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                '${list.totalItems} items • ${list.purchasedItems} purchased',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.chevron_right),
                          onPressed: () {
                            _showListDetails(context, list);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey.shade200,
                      color: progress > 0.8 ? Colors.red : Colors.green,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${list.totalSpent.toStringAsFixed(0)}₸ / ${list.budget.toStringAsFixed(0)}₸',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'Remaining: ${list.remainingBudget.toStringAsFixed(0)}₸',
                          style: TextStyle(
                            fontSize: 14,
                            color: list.remainingBudget < 0
                                ? Colors.red
                                : Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showCreateListDialog(context);
        },
        icon: const Icon(Icons.add),
        label: const Text('New List'),
      ),
    );
  }

  void _showCreateListDialog(BuildContext context) {
    final nameController = TextEditingController();
    final budgetController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create New List'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'List Name',
                  border: OutlineInputBorder(),
                  hintText: 'Example: Weekly groceries',
                ),
                autofocus: true,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: budgetController,
                decoration: const InputDecoration(
                  labelText: 'Budget (₸)',
                  border: OutlineInputBorder(),
                  hintText: '5000',
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    budgetController.text.isNotEmpty) {
                  final provider =
                  Provider.of<ShoppingProvider>(context, listen: false);
                  final newList = ShoppingList(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: nameController.text,
                    budget: double.parse(budgetController.text),
                  );
                  provider.addShoppingList(newList);
                  Navigator.pop(context);
                }
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  void _showListDetails(BuildContext context, ShoppingList list) {
    final provider = Provider.of<ShoppingProvider>(context, listen: false);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: MediaQuery.of(context).size.height * 0.8,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    list.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value: list.progress,
                backgroundColor: Colors.grey.shade200,
                color: list.progress > 0.8 ? Colors.red : Colors.green,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Spent: ${list.totalSpent.toStringAsFixed(0)}₸'),
                  Text('Budget: ${list.budget.toStringAsFixed(0)}₸'),
                  Text('Remaining: ${list.remainingBudget.toStringAsFixed(0)}₸'),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Items',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('${list.items.length} items'),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: list.items.isEmpty
                    ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_bag_outlined,
                        size: 60,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text('No items in list'),
                    ],
                  ),
                )
                    : ListView.builder(
                  itemCount: list.items.length,
                  itemBuilder: (context, index) {
                    final item = list.items[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: Checkbox(
                          value: item.isPurchased,
                          onChanged: (value) {
                            provider.toggleItemPurchase(list.id, item.id);
                          },
                        ),
                        title: Text(
                          item.name,
                          style: TextStyle(
                            decoration: item.isPurchased
                                ? TextDecoration.lineThrough
                                : null,
                            color: item.isPurchased
                                ? Colors.grey
                                : null,
                          ),
                        ),
                        subtitle: Text(
                          '${item.quantity} pcs • ${item.totalPrice.toStringAsFixed(0)}₸ • ${item.category}',
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            provider.removeItemFromList(list.id, item.id);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddItemScreen(listId: list.id),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Item'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Date Filter'),
          content: const Text('Date selection will appear here'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}