import 'package:flutter/material.dart';

class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  const LoadingOverlay({Key? key, required this.isLoading}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Stack(
            children: [
              Opacity(
                opacity: 0.3,
                child:
                    ModalBarrier(dismissible: false, color: Colors.black),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text('Applying theme...'),
                    ),
                  ],
                ),
              ),
            ],
          )
        : const SizedBox.shrink();
  }
}
