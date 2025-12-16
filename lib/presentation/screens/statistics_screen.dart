import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/shopping_provider.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ShoppingProvider>(context);
    final categoryExpenses = provider.categoryExpenses;
    final totalSpent = provider.totalSpent;
    final totalPurchases = provider.totalPurchases;
    final averagePurchase = provider.averagePurchase;

    final sortedCategories = categoryExpenses.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'Overall Statistics',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem(
                          'Total Spent',
                          '${totalSpent.toStringAsFixed(0)}₸',
                          Icons.attach_money,
                          Colors.green,
                        ),
                        _buildStatItem(
                          'Average Bill',
                          '${averagePurchase.toStringAsFixed(0)}₸',
                          Icons.calculate,
                          Colors.blue,
                        ),
                        _buildStatItem(
                          'Purchases',
                          totalPurchases.toString(),
                          Icons.shopping_bag,
                          Colors.orange,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Expenses by Category',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (sortedCategories.isEmpty)
                      const Center(
                        child: Text('No purchase data'),
                      )
                    else
                      ...sortedCategories.map((entry) {
                        final percentage =
                        totalSpent > 0 ? entry.value / totalSpent : 0.0;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 12,
                                        height: 12,
                                        decoration: BoxDecoration(
                                          color: _getCategoryColor(entry.key),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(entry.key),
                                    ],
                                  ),
                                  Text(
                                    '${entry.value.toStringAsFixed(0)}₸',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              LinearProgressIndicator(
                                value: percentage,
                                backgroundColor: Colors.grey[200],
                                color: _getCategoryColor(entry.key),
                                minHeight: 6,
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Active Lists',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (provider.shoppingLists.isEmpty)
                      const Center(
                        child: Text('No active lists'),
                      )
                    else
                      ...provider.shoppingLists.map((list) {
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.green.shade100,
                            child: Icon(
                              Icons.shopping_cart,
                              color: Colors.green.shade800,
                              size: 20,
                            ),
                          ),
                          title: Text(list.name),
                          subtitle: Text(
                            '${list.purchasedItems}/${list.totalItems} items',
                          ),
                          trailing: Chip(
                            label: Text(
                              '${(list.progress * 100).toStringAsFixed(0)}%',
                            ),
                            backgroundColor: list.progress > 0.8
                                ? Colors.red.shade100
                                : Colors.green.shade100,
                          ),
                          onTap: () {},
                        );
                      }).toList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(
          icon,
          size: 30,
          color: color,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Color _getCategoryColor(String category) {
    final colors = {
      'Groceries': Colors.blue,
      'Beverages': Colors.orange,
      'Vegetables/Fruits': Colors.green,
      'Dairy': Colors.lightBlue,
      'Meat/Fish': Colors.red,
      'Grocery': Colors.brown,
      'Household': Colors.cyan,
      'Cosmetics': Colors.pink,
      'Other': Colors.grey,
    };
    return colors[category] ?? Colors.grey;
  }
}