import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shoppy/models/grocery.dart';

class GroceriesNotifier extends StateNotifier<List<Grocery>> {
  GroceriesNotifier() : super([]);

  void addGrocery(Grocery grocery) {
    state = [
      ...state,
      grocery,
    ];
  }

  void removeGrocery(Grocery grocery) {
    state = state
        .where((currentGrocery) => currentGrocery.id != grocery.id)
        .toList();
  }
}

final groceriesProvider =
    StateNotifierProvider<GroceriesNotifier, List<Grocery>>(
  (ref) => GroceriesNotifier(),
);
