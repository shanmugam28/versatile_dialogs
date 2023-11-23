import 'package:flutter/material.dart';

class LoadingDialog {
  final String? message;
  final bool barrierDismissible;


  LoadingDialog([
    this.message,
    this.barrierDismissible = false,
  ]);

  show(BuildContext context) async {
    return await showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        Size screenSize = MediaQuery.of(context).size;
        bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

        return Center(
          child: Material(
            elevation: 10.0,
            borderRadius: BorderRadius.circular(4.0),
            child: Container(
              width: (isPortrait ? screenSize.width : screenSize.height) * 0.85,
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  if (message != null) Text(message!),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  dismiss(BuildContext context) => Navigator.of(context).pop();
}
