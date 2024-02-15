import 'package:flutter/material.dart';

import 'package:shoppy/models/grocery.dart';
import 'package:shoppy/widgets/grocery_item.dart';

class GroceriesList extends StatelessWidget {
  const GroceriesList({
    super.key,
    required this.groceries,
  });

  final List<Grocery> groceries;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: groceries.length,
      itemBuilder: (context, index) {
        final grocery = groceries[index];

        return GroceryItem(grocery: grocery);
      },
    );
  }
}
//  n