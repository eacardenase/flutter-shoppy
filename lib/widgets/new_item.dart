import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:shoppy/data/categories.dart';
import 'package:shoppy/models/category.dart';
import 'package:shoppy/models/grocery.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() => _NewItem();
}

class _NewItem extends State<NewItem> {
  var _isSending = false;
  final _formKey = GlobalKey<FormState>();
  var _enteredName = '';
  var _enteredQuantity = 1;
  var _selectedCategory = categories[Categories.vegetables]!;

  void _saveForm() async {
    final formState = _formKey.currentState!;
    final formIsValid = formState.validate();

    if (!formIsValid) {
      return;
    }

    setState(() {
      _isSending = true;
    });

    formState.save();

    final uri = Uri.https(
      'shopping-list-9f8d7-default-rtdb.firebaseio.com',
      'shopping-list.json',
    );

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': _enteredName,
        'quantity': _enteredQuantity,
        'category': _selectedCategory.title,
      }),
    );

    setState(() {
      _isSending = false;
    });

    _resetForm();

    final Map<String, dynamic> responseData = jsonDecode(response.body);
    final grocery = Grocery(
      id: responseData['name'],
      name: _enteredName,
      quantity: _enteredQuantity,
      category: _selectedCategory,
    );

    if (!context.mounted) {
      return;
    }

    Navigator.of(context).pop(grocery);
  }

  void _resetForm() {
    _formKey.currentState!.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              maxLength: 50,
              decoration: const InputDecoration(
                label: Text('Name'),
              ),
              validator: (value) {
                if (value == null ||
                    value.isEmpty ||
                    value.trim().length <= 1 ||
                    value.trim().length > 50) {
                  return 'Must be between 1 and 50 characters.';
                }

                return null;
              },
              onSaved: (newValue) {
                _enteredName = newValue!;
              },
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      label: Text('Quantity'),
                    ),
                    keyboardType: TextInputType.number,
                    initialValue: _enteredQuantity.toString(),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          int.tryParse(value) == null ||
                          int.parse(value) <= 0) {
                        return 'Must be a valid, positive number.';
                      }

                      return null;
                    },
                    onSaved: (newValue) {
                      _enteredQuantity = int.parse(newValue!);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField(
                    value: _selectedCategory,
                    items: [
                      for (final category in categories.entries)
                        DropdownMenuItem(
                          value: category.value,
                          child: Row(
                            children: [
                              Container(
                                width: 16,
                                height: 16,
                                color: category.value.color,
                              ),
                              const SizedBox(width: 6),
                              Text(category.value.title)
                            ],
                          ),
                        )
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value!;
                      });
                    },
                  ),
                )
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _isSending ? null : _resetForm,
                  child: const Text('Reset'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _isSending ? null : _saveForm,
                  child: _isSending
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(),
                        )
                      : const Text('Save'),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
