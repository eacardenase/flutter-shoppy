import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shoppy/data/categories.dart';

import 'package:shoppy/models/grocery.dart';
import 'package:shoppy/screens/new_item_screen.dart';
import 'package:shoppy/widgets/groceries_list.dart';

class GroceriesScreen extends StatefulWidget {
  const GroceriesScreen({super.key});

  @override
  State<GroceriesScreen> createState() => _GroceriesScreenState();
}

class _GroceriesScreenState extends State<GroceriesScreen> {
  final List<Grocery> _groceries = [];
  late Future<List<Grocery>> _loadedGroceries;

  Future<List<Grocery>> _loadGroceries() async {
    final uri = Uri.https(
      'shopping-list-9f8d7-default-rtdb.firebaseio.com',
      'shopping-list.json',
    );

    final response = await http.get(uri);

    final Map<String, dynamic>? responseData = jsonDecode(response.body);
    final List<Grocery> loadedGroceries = [];

    if (response.statusCode >= 400) {
      throw Exception('Failed to fetch grocery items. Please try again later.');
    }

    if (responseData == null) {
      return [];
    }

    for (final item in responseData.entries) {
      final category = categories.entries
          .firstWhere((currentCategory) =>
              currentCategory.value.title == item.value['category'])
          .value;

      final grocery = Grocery(
        id: item.key,
        name: item.value['name'],
        quantity: item.value['quantity'],
        category: category,
      );

      loadedGroceries.add(grocery);
    }

    return loadedGroceries;
  }

  void _addGrocery() async {
    final newGrocery = await Navigator.of(context).push<Grocery>(
      MaterialPageRoute(
        builder: (context) => const NewItemScreen(),
      ),
    );

    if (newGrocery == null) {
      return;
    }

    setState(() {
      _groceries.add(newGrocery);
    });
  }

  void _removeGrocery(Grocery grocery) async {
    setState(() {
      _groceries.remove(grocery);
    });

    final uri = Uri.https(
      'shopping-list-9f8d7-default-rtdb.firebaseio.com',
      'shopping-list/${grocery.id}.json',
    );

    final response = await http.delete(uri);

    if (response.statusCode >= 400) {
      final groceryIndex = _groceries.indexOf(grocery);

      setState(() {
        _groceries.insert(groceryIndex, grocery);
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _loadedGroceries = _loadGroceries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _addGrocery,
            icon: const Icon(
              Icons.add,
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: FutureBuilder(
          future: _loadedGroceries,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError || snapshot.data == null) {
              return Center(
                child: Text(
                  snapshot.error.toString(),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  softWrap: true,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              );
            }

            if (snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  'No groceries found. Add a new one!',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              );
            }

            return GroceriesList(
              groceries: snapshot.data!,
              onRemoveGrocery: _removeGrocery,
            );
          },
        ),
      ),
    );
  }
}
