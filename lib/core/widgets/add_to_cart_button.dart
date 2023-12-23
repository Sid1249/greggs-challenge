import 'package:flutter/material.dart';

class AddToCartButton extends StatelessWidget {
  final int itemCount;
  final Function() onIncrement;
  final Function() onDecrement;

  const AddToCartButton({
    Key? key,
    required this.itemCount,
    required this.onIncrement,
    required this.onDecrement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if(itemCount == 0) onIncrement();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.blue, Colors.lightBlue],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: SizedBox(
          height: 24, // Fixed height for the button
          child: Center(
            child: itemCount == 0
                ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Add To Basket',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.surface)
                ),
              ],
            )
                : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: GestureDetector(
                    onTap: onDecrement,
                    child: Icon(
                      Icons.remove,
                      color: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    '$itemCount',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme!.surface,
                    ),
                  ),
                ),
                Padding(padding:
                  const EdgeInsets.only(right: 8.0),                  child: GestureDetector(
                    onTap: onIncrement,
                    child: Icon(
                      Icons.add,
                      color: Theme.of(context).colorScheme!.surface,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
