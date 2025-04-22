import 'package:flutter/material.dart';

class DrawerFunctionButton extends StatelessWidget {
  final VoidCallback onTap;
  final AnimationController controller;
  final Icon icon;
  final String text;

  const DrawerFunctionButton({super.key, required this.controller, required this.onTap, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 35),
      child: ClipRect(
        child: AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              return TextButton.icon(
                icon: icon,
                label: Text(
                  text,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black, decoration: TextDecoration.none, fontFamily: 'Roboto'),
                ),
                onPressed: onTap,
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  alignment: Alignment.centerLeft,
                ),
              );
            }),
      ),
    );
  }
}
