import 'package:flutter/material.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() => _NewItem();
}

class _NewItem extends State<NewItem> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'The Form',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
