import 'package:flutter/material.dart';
import 'package:jc_housekeeping/utils/theme.helper.dart';

class BottomBar extends StatelessWidget {
  int selectedIndex;
  void Function(int) onTap;

  BottomBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });
  // @override
  // void initState() {
  //   super.initState();
  // }

  // @override
  // void dispose() {
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Room',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.volunteer_activism),
          label: 'Lost & Found',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: theme.colorScheme.primary,
      onTap: onTap,
    );
  }
}
