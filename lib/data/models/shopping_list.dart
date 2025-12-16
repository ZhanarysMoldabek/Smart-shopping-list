import 'package:flutter/foundation.dart';

class ShoppingItem {
  String id;
  String name;
  int quantity;
  double price;
  String category;
  bool isPurchased;
  DateTime createdAt;
  DateTime? purchasedAt;

  ShoppingItem({required this.id, required this.name, this.quantity = 1, this.price = 0.0, this.category = 'Other', this.isPurchased = false, DateTime? createdAt, this.purchasedAt}) : createdAt = createdAt ?? DateTime.now();

  double get totalPrice => price * quantity;

  ShoppingItem copyWith({String? id, String? name, int? quantity, double? price, String? category, bool? isPurchased, DateTime? createdAt, DateTime? purchasedAt}) {
    return ShoppingItem(id: id ?? this.id, name: name ?? this.name, quantity: quantity ?? this.quantity, price: price ?? this.price, category: category ?? this.category, isPurchased: isPurchased ?? this.isPurchased, createdAt: createdAt ?? this.createdAt, purchasedAt: purchasedAt ?? this.purchasedAt);
  }

  @override String toString() => 'ShoppingItem(id: $id, name: $name, quantity: $quantity, price: $price)';
}

class ShoppingList {
  String id;
  String name;
  DateTime createdAt;
  double budget;
  List<ShoppingItem> items;
  bool isCompleted;

  ShoppingList({required this.id, required this.name, required this.budget, List<ShoppingItem>? items, DateTime? createdAt, this.isCompleted = false}) : items = items ?? [], createdAt = createdAt ?? DateTime.now();

  double get totalSpent => items.where((item) => item.isPurchased).fold(0.0, (sum, item) => sum + item.totalPrice);
  double get remainingBudget => budget - totalSpent;
  double get progress => budget > 0 ? totalSpent / budget : 0;
  int get totalItems => items.length;
  int get purchasedItems => items.where((item) => item.isPurchased).length;

  ShoppingList copyWith({String? id, String? name, double? budget, List<ShoppingItem>? items, bool? isCompleted}) {
    return ShoppingList(id: id ?? this.id, name: name ?? this.name, budget: budget ?? this.budget, items: items ?? this.items, isCompleted: isCompleted ?? this.isCompleted);
  }

  void addItem(ShoppingItem item) => items.add(item);
  void removeItem(String itemId) => items.removeWhere((item) => item.id == itemId);

  void toggleItemPurchase(String itemId) {
    final index = items.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      items[index] = items[index].copyWith(isPurchased: !items[index].isPurchased, purchasedAt: items[index].isPurchased ? null : DateTime.now());
    }
  }

  @override String toString() => 'ShoppingList(id: $id, name: $name, items: ${items.length})';
}