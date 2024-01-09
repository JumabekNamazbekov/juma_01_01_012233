import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(WeatherApp());

class WeatherApp extends StatefulWidget {
  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  String cityName = '';
  String temperature = '';
  String description = '';

  Future<void> getWeatherData(String city) async {
    final apiKey = 'https://api.openweathermap.org/data/2.5/weather?q=$city,&appid=41aa18abb8974c0ea27098038f6feb1b';
    final url =
        'http://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        cityName = data['name'];
        temperature = (data['main']['temp'] - 273.15).toStringAsFixed(1);
        description = data['weather'][0]['description'];
      });
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Weather App'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Enter City Name:',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: TextField(
                onChanged: (value) {
                  cityName = value;
                },
                decoration: InputDecoration(
                  hintText: 'City Name',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                getWeatherData(cityName);
              },
              child: Text('Get Weather'),
            ),
            SizedBox(height: 20),
            Text(
              'City: $cityName',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Text(
              'Temperature: $temperature°C',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Text(
              'Description: $description',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
