import 'package:shoppy/data/categories.dart';
import 'package:shoppy/models/category.dart';
import 'package:shoppy/models/grocery.dart';

final groceries = [
  Grocery(
      id: 'a',
      name: 'Milk',
      quantity: 1,
      category: categories[Categories.dairy]!),
  Grocery(
      id: 'b',
      name: 'Bananas',
      quantity: 5,
      category: categories[Categories.fruit]!),
  Grocery(
      id: 'c',
      name: 'Beef Steak',
      quantity: 1,
      category: categories[Categories.meat]!),
];
