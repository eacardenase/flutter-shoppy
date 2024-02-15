import 'package:flutter/material.dart';

import 'package:shoppy/data/dummy_items.dart';
import 'package:shoppy/widgets/groceries_list.dart';

class GroceriesScreen extends StatelessWidget {
  const GroceriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: GroceriesList(groceries: groceries),
      ),
    );
  }
}
