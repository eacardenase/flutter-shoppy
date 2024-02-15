import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shoppy/data/dummy_items.dart';
import 'package:shoppy/models/grocery.dart';

class GroceriesNotifier extends StateNotifier<List<Grocery>> {
  GroceriesNotifier() : super([...groceries]);

  void addGrocery(Grocery grocery) {
    state = [
      ...state,
      grocery,
    ];
  }
}

final groceriesProvider =
    StateNotifierProvider<GroceriesNotifier, List<Grocery>>(
  (ref) => GroceriesNotifier(),
);
