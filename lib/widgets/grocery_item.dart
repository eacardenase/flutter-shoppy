import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shoppy/models/grocery.dart';
import 'package:shoppy/providers/groceries_provider.dart';

class GroceryItem extends ConsumerWidget {
  const GroceryItem({
    super.key,
    required this.grocery,
  });

  final Grocery grocery;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: ValueKey(grocery),
      onDismissed: (direction) {
        ref.read(groceriesProvider.notifier).removeGrocery(grocery);
      },
      child: ListTile(
        title: Text(grocery.name),
        leading: Container(
          width: 25,
          height: 25,
          color: grocery.category.color,
        ),
        trailing: Text('${grocery.quantity}'),
      ),
    );
  }
}
