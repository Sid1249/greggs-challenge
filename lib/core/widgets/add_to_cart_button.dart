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
                ? const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Add To Basket',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
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
                    child: const Icon(
                      Icons.remove,
                      // onPressed: onDecrement,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    '$itemCount',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(padding:
                  const EdgeInsets.only(right: 8.0),                  child: GestureDetector(
                    onTap: onIncrement,
                    child: const Icon(
                      Icons.add,
                      // onPressed: onDecrement,
                      color: Colors.white,
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
