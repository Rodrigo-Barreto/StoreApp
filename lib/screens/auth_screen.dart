import 'dart:math';

import 'package:app/components/auth_card.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(215, 117, 255, 0.5),
                  Color.fromRGBO(255, 117, 215, 0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 70,
                  ),
                  transform: Matrix4.rotationZ(-3 * pi / 100)..translate(-10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.red,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 8,
                        color: Colors.black26,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    "My Shop",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Anton',
                        fontSize: 45,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                AuthCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
