import 'package:flutter/material.dart';
import 'package:kontena_hk/utils/theme.helper.dart';

// ignore: must_be_immutable
class BottomNavigationCustom extends StatelessWidget {
  int selectedIndex;
  void Function(int) onTap;

  BottomNavigationCustom({
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
      items: const [
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
