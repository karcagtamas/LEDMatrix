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
  List<BluetoothDevice> deviceList = new List<BluetoothDevice>();
  String text = "";
  TextEditingController _controller;
  double brightness = 0.0;
  double speed = 0;

  void initState() {
    super.initState();
    _controller = TextEditingController(text: text);
    flutterBlue = FlutterBlue.instance;
    flutterBlue.state.listen((state) {
      if (state == BluetoothState.off) {
      } else if (state == BluetoothState.on) {
        scan();
      }
    });
    // getSettings();
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
              ],
            ),
            Column(
              children: [
                Text('Bluetooth Devices'),
                ListView.builder(
                  itemCount: this.deviceList.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return this.generateTile(this.deviceList.elementAt(index));
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> scan() async {
    flutterBlue.connectedDevices
        .asStream()
        .listen((List<BluetoothDevice> devices) {
      for (BluetoothDevice device in devices) {
        addDevice(device);
      }
    });

    flutterBlue.scanResults.listen((List<ScanResult> results) {
      for (ScanResult result in results) {
        addDevice(result.device);
      }
    });

    if (await flutterBlue.isScanning.first) {
      flutterBlue.stopScan();
    }
    flutterBlue.startScan();
  }

  ListTile generateTile(BluetoothDevice device) {
    return (ListTile(
      title: Text(device.name),
    ));
  }

  void sendSettings() {
    print(this.text);
    print(this.speed);
    print(this.brightness);
  }

  void addDevice(final BluetoothDevice device) {
    if (!this.deviceList.contains(device)) {
      setState(() {
        this.deviceList.add(device);
      });
    }
  }

  void getSettings() {
    this.scan();
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
    sendSettings();
  }
}
