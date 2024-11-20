import 'dart:async';
import 'package:flutter/material.dart';
import 'package:jc_hk/utils/theme.helper.dart';

void alertError(BuildContext context, String message) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: TextStyle(color: theme.colorScheme.primaryContainer),
      ),
      duration: const Duration(seconds: 5),
      backgroundColor:
          theme.colorScheme.onError, // You can customize the color here
    ),
  );
}

void alertSuccess(BuildContext context, String message) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: TextStyle(color: theme.colorScheme.primaryContainer),
      ),
      duration: const Duration(seconds: 5),
      backgroundColor:
          theme.colorScheme.onSecondary, // You can customize the color here
    ),
  );
}

void alertModalFailed(BuildContext context, String message) {
  showModalBottomSheet(
    context: context,
    isDismissible: false,
    builder: (context) {
      Timer(const Duration(seconds: 3), () {
        Navigator.of(context).pop(); // Close the bottom sheet after 3 seconds
      });

      return Container(
        width: MediaQuery.of(context).size.width, // Set width to screen width
        padding: const EdgeInsets.all(8.0),
        decoration: const BoxDecoration(color: Color.fromARGB(255, 248, 31, 1)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      );
    },
  );
}
