import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  FlutterBlue flutterBlue;
  StreamSubscription sub;
  String text = "";
  TextEditingController _controller;
  double brightness = 0.0;
  double speed = 0;

  void initState() {
    super.initState();
    _controller = TextEditingController(text: text);
    flutterBlue = FlutterBlue.instance;
    scan();
    getSettings();
  }

  void dispose() {
    _controller.dispose();
    this.sub.cancel();
    super.dispose();
  }

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
                  autofillHints: ['Display text'],
                  obscureText: false,
                  maxLength: 40,
                  controller: _controller,
                  onChanged: (val) {
                    setState(() {
                      this.text = val;
                    });
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Display text'),
                ),
                Text(
                  'Brightness',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Slider(
                  value: brightness,
                  onChanged: (double value) {
                    setState(() {
                      brightness = value;
                    });
                  },
                  min: 0.0,
                  max: 15.0,
                  divisions: 15,
                  label: brightness.round().toString(),
                ),
                Text(
                  'Speed',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Slider(
                  value: speed,
                  onChanged: (double value) {
                    setState(() {
                      speed = value;
                    });
                  },
                  min: 0.0,
                  max: 1000.0,
                  divisions: 1000,
                  label: speed.round().toString(),
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.spaceAround,
                  children: [
                    RaisedButton(
                      onPressed: sendSettings,
                      textColor: Colors.white,
                      color: Colors.green,
                      child: Text('Send'),
                    ),
                    RaisedButton(
                      onPressed: getSettings,
                      textColor: Colors.white,
                      color: Colors.red,
                      child: Text('Refresh'),
                    ),
                    RaisedButton(
                      onPressed: setToDefault,
                      textColor: Colors.white,
                      color: Colors.blue,
                      child: Text('Set to Default'),
                    ),
                  ],
                ),
                ButtonBar(
                  children: [
                    RaisedButton(
                      onPressed: scan,
                      child: Text('Try to Refresh'),
                    )
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void scan() {
    flutterBlue.startScan(timeout: Duration(seconds: 5));

    if (this.sub != null) {
      this.sub.cancel();
      this.sub = null;
    }

    this.sub = flutterBlue.scanResults.listen((results) {
      for (ScanResult r in results) {
        print('${r.device.name} found! rssi ${r.rssi}');
      }
    });

    flutterBlue.stopScan();
  }

  void sendSettings() {}

  void getSettings() {
    this._controller.text = this.text;
    this.setState(() {
      this.text = "";
      this.speed = 120;
      this.brightness = 1;
    });
  }

  void setToDefault() {
    this._controller.text = this.text;
    this.setState(() {
      this.text = "";
      this.speed = 120;
      this.brightness = 1;
    });
  }
}
