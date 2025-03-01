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

// History screen
class HistoryScreen extends StatelessWidget {
  final List<Map<String, dynamic>> activityHistory;
  String? selectedType;

  HistoryScreen({required this.activityHistory});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Activity History')),
      body: ListView.builder(
        itemCount: activityHistory.length,
        itemBuilder: (context, index) {
          final activity = activityHistory[index];
          final isHighlighted =
              selectedType != null && selectedType == activity['type'];
          return ListTile(
            title: Text(activity['activity']),
            subtitle: Text('Price: ${activity['price']}'),
          );
        },
      ),
    );
  }
}

// Initialize variable and create UI
class _MyHomePageState extends State<MyHomePage> {
  String _activity = '';
  double _price = 0.0;

  String? _selectedType;

  List<Map<String, dynamic>> _activityHistory = []; // Add history list

  Future<void> _fetchActivity() async {
    //Filter activity by type
    String url = 'https://bored.api.lewagon.com/api/activity';
    if (_selectedType != null && _selectedType!.isNotEmpty) {
      url += '?type=$_selectedType';
    }

    final response = await http.get(
      Uri.parse('https://bored.api.lewagon.com/api/activity'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        //Fetch activity and set state
        _activity = data['activity'];
        _price = data['price'].toDouble();

        // Add activity to history list
        _activityHistory.insert(0, {
          'activity': _activity,
          'price': _price,
          'type': data['type'],
        });
        if (_activityHistory.length > 50) {
          _activityHistory.removeLast();
        }
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
            //Fetch activity button
            ElevatedButton(onPressed: _fetchActivity, child: Text('XXXX')),
            SizedBox(height: 20),
            Text('Activity: $_activity'),
            Text('Price: $_price'),

            // History button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            HistoryScreen(activityHistory: _activityHistory),
                  ),
                );
              },
              child: Text('History'),
            ),

            // Activity type dropdown
            DropdownButton<String>(
              value: _selectedType,
              hint: Text('Select Activity Type'),
              items:
                  <String>[
                    'education',
                    'recreational',
                    'social',
                    'diy',
                    'charity',
                    'cooking',
                    'relaxation',
                    'music',
                    'busy',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedType = newValue;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
