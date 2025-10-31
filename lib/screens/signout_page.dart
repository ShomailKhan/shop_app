import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignoutPage extends StatelessWidget {
  const SignoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: ElevatedButton(
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            SystemNavigator.pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            fixedSize: Size(MediaQuery.of(context).size.width * 1, 60),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            'sign out',
            style: Theme.of(
              context,
            ).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
