import 'package:flutter/material.dart';

import 'package:shoppy/models/grocery.dart';
import 'package:shoppy/widgets/grocery_item.dart';

class GroceriesList extends StatelessWidget {
  const GroceriesList({
    super.key,
    required this.groceries,
    required this.onRemoveGrocery,
  });

  final List<Grocery> groceries;
  final void Function(Grocery) onRemoveGrocery;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: groceries.length,
      itemBuilder: (context, index) {
        final grocery = groceries[index];

        return GroceryItem(
          grocery: grocery,
          onRemoveGrocery: onRemoveGrocery,
        );
      },
    );
  }
}
//  n