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
  List<Grocery> _groceries = [];
  var _isLoading = true;
  String? _errorMessage;

  void _loadGroceries() async {
    final uri = Uri.https(
      'shopping-list-9f8d7-default-rtdb.firebaseio.com',
      'shopping-list.json',
    );

    final response = await http.get(uri);

    if (response.statusCode >= 400) {
      setState(() {
        _errorMessage = 'Failed to fetch data. Please try again later.';
        _isLoading = false;
      });

      return;
    }

    final Map<String, dynamic> listData = jsonDecode(response.body);
    final List<Grocery> loadedGroceries = [];

    for (final item in listData.entries) {
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

    setState(() {
      _groceries = loadedGroceries;
      _isLoading = false;
    });
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
    final uri = Uri.https(
      'shopping-list-9f8d7-default-rtdb.firebaseio.com',
      'shopping-list/${grocery.id}.json',
    );

    final response = await http.delete(uri);

    if (response.statusCode >= 400) {
      setState(() {
        _errorMessage = 'Failed to delete the grocery. Please try again later.';
        _isLoading = false;
      });

      return;
    }

    setState(() {
      _groceries.remove(grocery);
    });
  }

  @override
  void initState() {
    super.initState();

    _loadGroceries();
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = const Center(
      child: Text(
        'No groceries found. Add a new one!',
        style: TextStyle(
          fontSize: 16,
        ),
      ),
    );

    if (_isLoading) {
      mainContent = const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_groceries.isNotEmpty) {
      mainContent = GroceriesList(
        groceries: _groceries,
        onRemoveGrocery: _removeGrocery,
      );
    }

    if (_errorMessage != null) {
      mainContent = Center(
        child: Text(
          _errorMessage!,
          textAlign: TextAlign.center,
          maxLines: 2,
          softWrap: true,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      );
    }

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
        child: mainContent,
      ),
    );
  }
}
