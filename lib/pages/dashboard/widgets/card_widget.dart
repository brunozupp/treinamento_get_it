import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {

  final String title;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  const CardWidget({
    Key? key,
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black45,
                blurRadius: 2,
                blurStyle: BlurStyle.outer,
              ),
            ]
          ),
          child: Column(
            children: [
              const Spacer(),
              Icon(
                icon,
                color: iconColor,
                size: 70,
              ),
              const Spacer(),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 24
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
