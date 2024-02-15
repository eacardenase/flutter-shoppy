import 'package:flutter/material.dart';

import 'package:shoppy/models/grocery.dart';

class GroceryItem extends StatelessWidget {
  const GroceryItem({
    super.key,
    required this.grocery,
  });

  final Grocery grocery;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(grocery.name),
      leading: Container(
        width: 25,
        height: 25,
        color: grocery.category.color,
      ),
      trailing: Text('${grocery.quantity}'),
    );
  }
}
