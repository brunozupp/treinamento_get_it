import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {

  final String? message;

  const LoadingPage({
    Key? key,
    this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(
            height: 20,
          ),
          Text(
            message ?? "Carregando informações"
          )
        ],
      ),
    );
  }
}
