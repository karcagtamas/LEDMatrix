import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("LED Matrix settings"),
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: Flex(
          direction: Axis.vertical,
          children: [
            Column(
              children: [
                TextField(
                  autocorrect: false,
                  autofillHints: [
                    'Display text'
                  ],
                  obscureText: false,
                  maxLength: 40,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Display text'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
