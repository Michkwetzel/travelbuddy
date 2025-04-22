import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GoogleSignInButton extends StatelessWidget {
  final VoidCallback onPressed;

  const GoogleSignInButton({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 230,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/images/icons8-google.svg',
              fit: BoxFit.contain,
              height: 30,
            ),
            SizedBox(
              width: 6,
            ),
            Text(
              'Sign in with Google',
              style: TextStyle(fontSize: 14, fontFamily: 'Roboto', fontWeight: FontWeight.w400, color: Colors.black87),
            )
          ],
        ),
      ),
    );
  }
}
