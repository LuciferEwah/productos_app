import 'package:flutter/material.dart';

class CustomNavigatorBar extends StatelessWidget {
  final int currentIndex;
  final PageController pageController;

  const CustomNavigatorBar({
    Key? key,
    required this.currentIndex,
    required this.pageController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.list),
          label: 'Productos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.sticky_note_2),
          label: 'Planes',
        )
      ],
    );
  }
}
