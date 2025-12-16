import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ShoppingItemCard extends StatelessWidget {
  final String name;
  final int quantity;
  final double price;
  final String category;
  final bool isPurchased;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onTogglePurchased;

  const ShoppingItemCard({
    super.key,
    required this.name,
    required this.quantity,
    required this.price,
    required this.category,
    required this.isPurchased,
    required this.onTap,
    required this.onDelete,
    required this.onTogglePurchased,
  });

  Color _getCategoryColor(String category) {
    final colors = {
      'Продукты': Colors.blue,
      'Напитки': Colors.orange,
      'Овощи/Фрукты': Colors.green,
      'Молочные продукты': Colors.lightBlue,
      'Мясо/Рыба': Colors.red,
      'Бакалея': Colors.brown,
      'Хоз. товары': Colors.cyan,
      'Косметика': Colors.pink,
      'Другое': Colors.grey,
    };
    return colors[category] ?? Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => onTogglePurchased(),
            backgroundColor: isPurchased ? Colors.orange : Colors.green,
            foregroundColor: Colors.white,
            icon: isPurchased ? Icons.undo : Icons.check,
            label: isPurchased ? 'Вернуть' : 'Куплено',
          ),
          SlidableAction(
            onPressed: (context) => onDelete(),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Удалить',
          ),
        ],
      ),
      child: Card(
        elevation: 1,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        color: isPurchased ? Colors.grey.shade100 : null,
        child: ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getCategoryColor(category).withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getCategoryIcon(category),
              color: _getCategoryColor(category),
              size: 20,
            ),
          ),
          title: Text(
            name,
            style: TextStyle(
              fontSize: 16,
              decoration:
              isPurchased ? TextDecoration.lineThrough : TextDecoration.none,
              color: isPurchased ? Colors.grey : null,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$quantity шт. • $category',
                style: TextStyle(
                  fontSize: 12,
                  color: isPurchased ? Colors.grey : null,
                ),
              ),
              Text(
                '${(price * quantity).toStringAsFixed(2)}₽',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isPurchased ? Colors.grey : Colors.green.shade800,
                ),
              ),
            ],
          ),
          trailing: Checkbox(
            value: isPurchased,
            onChanged: (value) => onTogglePurchased(),
            activeColor: Colors.green,
          ),
          onTap: onTap,
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    final icons = {
      'Продукты': Icons.bakery_dining,
      'Напитки': Icons.local_drink,
      'Овощи/Фрукты': Icons.eco,
      'Молочные продукты': Icons.breakfast_dining,
      'Мясо/Рыба': Icons.set_meal,
      'Бакалея': Icons.kitchen,
      'Хоз. товары': Icons.cleaning_services,
      'Косметика': Icons.spa,
      'Другое': Icons.more_horiz,
    };
    return icons[category] ?? Icons.shopping_cart;
  }
}