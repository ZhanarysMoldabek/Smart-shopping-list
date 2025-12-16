import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF4CAF50);
  static const Color primaryDark = Color(0xFF388E3C);
  static const Color primaryLight = Color(0xFFC8E6C9);
  static const Color accent = Color(0xFFFF9800);
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color divider = Color(0xFFBDBDBD);
}

class AppTextStyles {
  static const TextStyle headline1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle headline2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyText1 = TextStyle(
    fontSize: 16,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyText2 = TextStyle(
    fontSize: 14,
    color: AppColors.textSecondary,
  );
}

class AppIcons {
  static const IconData shoppingCart = Icons.shopping_cart;
  static const IconData add = Icons.add;
  static const IconData check = Icons.check;
  static const IconData delete = Icons.delete;
  static const IconData edit = Icons.edit;
  static const IconData settings = Icons.settings;
  static const IconData statistics = Icons.bar_chart;
  static const IconData calendar = Icons.calendar_today;
}