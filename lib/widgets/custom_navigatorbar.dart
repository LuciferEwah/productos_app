import 'package:flutter/material.dart';

class CustomNavigatorBar extends StatelessWidget {
  final ValueNotifier<int> currentIndex;

  const CustomNavigatorBar({Key? key, required this.currentIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: currentIndex,
      builder: (context, index, _) {
        return BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.production_quantity_limits),
                label: 'Productos'),
            BottomNavigationBarItem(
                icon: Icon(Icons.star_border_sharp), label: 'Planes')
          ],
          elevation: 0,
          currentIndex: index,
          onTap: (newIndex) {
            currentIndex.value = newIndex;
          },
        );
      },
    );
  }
}
