import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kontena_hk/utils/theme.helper.dart';

void alertError(BuildContext context, String message) {
  final overlay = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      bottom:
          MediaQuery.of(context).viewPadding.bottom + 16, // Di bawah status bar
      left: 16,
      right: 16,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: theme.colorScheme.error, // Warna background snackbar
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.secondary,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            message,
            style: TextStyle(
              color: theme.colorScheme.primaryContainer,
              fontSize: 16,
            ),
          ),
        ),
      ),
    ),
  );

  // Menambahkan OverlayEntry ke layar
  overlay.insert(overlayEntry);

  // Menghapus OverlayEntry setelah beberapa detik
  Future.delayed(const Duration(seconds: 3)).then((_) => overlayEntry.remove());
  // ScaffoldMessenger.of(context).hideCurrentSnackBar();

  // ScaffoldMessenger.of(context).showSnackBar(
  //   SnackBar(
  //     content: Text(
  //       message,
  //       style: TextStyle(color: theme.colorScheme.primaryContainer),
  //     ),
  //     duration: const Duration(seconds: 5),
  //     backgroundColor:
  //         theme.colorScheme.onError, // You can customize the color here
  //   ),
  // );
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
        decoration: BoxDecoration(color: theme.colorScheme.error),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              style: TextStyle(
                color: theme.colorScheme.primaryContainer,
              ),
            ),
          ],
        ),
      );
    },
  );
}

void alertModalSuccess(BuildContext context, String message) {
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
        decoration: BoxDecoration(color: theme.colorScheme.onSecondary),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              style: TextStyle(
                color: theme.colorScheme.primaryContainer,
              ),
            ),
          ],
        ),
      );
    },
  );
}
