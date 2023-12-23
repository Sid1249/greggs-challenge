import 'package:flutter/material.dart';

class CartBottomBar extends StatelessWidget {

  final int numCartItems;
  final VoidCallback onViewCartPressed;

  const CartBottomBar({super.key,
    required this.numCartItems,
    required this.onViewCartPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(4),
          topRight: Radius.circular(4),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$numCartItems item added',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.surface,
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
            onPressed: onViewCartPressed,
            child: Text(
              'View Cart',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold)
            ),
          ),
        ],
      ),
    );
  }
}