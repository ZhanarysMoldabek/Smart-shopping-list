import 'package:flutter/foundation.dart';
import '../../data/models/shopping_list.dart';

class ShoppingProvider extends ChangeNotifier {
  List<ShoppingList> _shoppingLists = [];
  List<ShoppingList> get shoppingLists => _shoppingLists;

  Map<String, double> get categoryExpenses {
    final Map<String, double> expenses = {};
    for (final list in _shoppingLists) {
      for (final item in list.items) {
        if (item.isPurchased) {
          expenses.update(item.category, (value) => value + item.totalPrice, ifAbsent: () => item.totalPrice);
        }
      }
    }
    return expenses;
  }

  double get totalSpent => _shoppingLists.fold(0.0, (sum, list) => sum + list.totalSpent);

  int get totalPurchases => _shoppingLists.fold(0, (sum, list) => sum + list.purchasedItems);

  double get averagePurchase {
    final purchasedItems = _shoppingLists.expand((list) => list.items).where((item) => item.isPurchased).toList();
    if (purchasedItems.isEmpty) return 0;
    final total = purchasedItems.fold(0.0, (sum, item) => sum + item.totalPrice);
    return total / purchasedItems.length;
  }

  void addShoppingList(ShoppingList list) {
    _shoppingLists.add(list);
    notifyListeners();
  }

  void removeShoppingList(String listId) {
    _shoppingLists.removeWhere((list) => list.id == listId);
    notifyListeners();
  }

  void addItemToList(String listId, ShoppingItem item) {
    final index = _shoppingLists.indexWhere((list) => list.id == listId);
    if (index != -1) {
      _shoppingLists[index].addItem(item);
      notifyListeners();
    }
  }

  void removeItemFromList(String listId, String itemId) {
    final index = _shoppingLists.indexWhere((list) => list.id == listId);
    if (index != -1) {
      _shoppingLists[index].removeItem(itemId);
      notifyListeners();
    }
  }

  void toggleItemPurchase(String listId, String itemId) {
    final index = _shoppingLists.indexWhere((list) => list.id == listId);
    if (index != -1) {
      _shoppingLists[index].toggleItemPurchase(itemId);
      notifyListeners();
    }
  }

  void initializeWithSampleData() {
    final weeklyList = ShoppingList(id: '1', name: 'Weekly Groceries', budget: 5000);
    weeklyList.addItem(ShoppingItem(id: '1-1', name: 'Bread', quantity: 2, price: 50, category: 'Groceries', isPurchased: true));
    weeklyList.addItem(ShoppingItem(id: '1-2', name: 'Milk', quantity: 1, price: 80, category: 'Dairy', isPurchased: true));
    weeklyList.addItem(ShoppingItem(id: '1-3', name: 'Apples', quantity: 1, price: 120, category: 'Vegetables/Fruits'));

    final partyList = ShoppingList(id: '2', name: 'Party Supplies', budget: 3000);
    partyList.addItem(ShoppingItem(id: '2-1', name: 'Chips', quantity: 3, price: 150, category: 'Groceries'));
    partyList.addItem(ShoppingItem(id: '2-2', name: 'Drinks', quantity: 10, price: 60, category: 'Beverages'));

    _shoppingLists = [weeklyList, partyList];
    notifyListeners();
  }
}