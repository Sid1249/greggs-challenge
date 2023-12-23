import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  final List<MenuClass> mainMenu;
  final void Function(int)? callback;
  final int? current;

  const MenuScreen(
      this.mainMenu, {super.key,
        this.callback,
        this.current,
      });

  @override
  Widget build(BuildContext context) {
    const _androidStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );
    const _iosStyle = TextStyle(color: Colors.white);
    final style = kIsWeb
        ? _androidStyle
        : Platform.isAndroid
        ? _androidStyle
        : _iosStyle;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Spacer(),
            const SizedBox(height: 40,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton.icon(onPressed: (){}, icon: const Icon(Icons.shopping_cart),
              label: const Text("View Cart"),),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton.icon(onPressed: (){}, icon: const Icon(Icons.dark_mode),
                label: const Text("Switch Theme"),),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton.icon(onPressed: (){}, icon: const Icon(Icons.document_scanner),
                label: const Text("View Resume"),),
            ),

            // Spacer(),
          ],
        ),
      ),
    );
  }
}

class MenuItemWidget extends StatelessWidget {
  final MenuClass? item;
  final Widget? widthBox;
  final TextStyle? style;
  final void Function(int)? callback;
  final bool? selected;

  const MenuItemWidget({
    Key? key,
    this.item,
    this.widthBox,
    this.style,
    this.callback,
    this.selected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => callback!(item!.index),
      style: TextButton.styleFrom(
        foregroundColor: selected! ? const Color(0x44000000) : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            item!.icon,
            color: Colors.white,
            size: 24,
          ),
          widthBox!,
          Expanded(
            child: Text(
              item!.title,
              style: style,
            ),
          )
        ],
      ),
    );
  }
}

class MenuClass {
  final String title;
  final IconData icon;
  final int index;

  const MenuClass(this.title, this.icon, this.index);
}