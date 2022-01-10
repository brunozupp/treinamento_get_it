import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {

  final String error;
  final VoidCallback onRefresh;

  const ErrorPage({
    Key? key,
    required this.error,
    required this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.red,
        title: const Text(
          "Oops, Erro :("
        ),
      ),
      body: Column(
        children: [
          const Spacer(),
          Text(
            error
          ),
          const Spacer(),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(
              bottom: 10
            ),
            child: ElevatedButton(
              onPressed: onRefresh, 
              child: const Text(
                "Atualizar",
              )
            ),
          ),
        ],
      ),
    );
  }
}
