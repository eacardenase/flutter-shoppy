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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: ListTile(
            title: Text(grocery.name),
            leading: Container(
              width: 20,
              height: 20,
              color: grocery.category.color,
            ),
          ),
        ),
        Text('${grocery.quantity}')
      ],
    );
  }
}
