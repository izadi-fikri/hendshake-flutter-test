import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Add http import
import 'dart:convert'; // Add json import

// Entry point of the app
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Flutter Test', home: MyHomePage());
  }
}

// Initialize state
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

// Initialize variable and create UI
class _MyHomePageState extends State<MyHomePage> {
  String _activity = '';
  double _price = 0.0;

  Future<void> _fetchActivity() async {
    final response = await http.get(
      Uri.parse('https://bored.api.lewagon.com/api/activity'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _activity = data['activity'];
        _price = data['price'].toDouble();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flutter Test')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(onPressed: _fetchActivity, child: Text('XXXX')),
            SizedBox(height: 20),
            Text('Activity: $_activity'),
            Text('Price: $_price'),
          ],
        ),
      ),
    );
  }
}
