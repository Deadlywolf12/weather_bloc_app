import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class WeatherBotService {
  final double lat;
  final double long;

  WeatherBotService(
      {required this.lat, required this.long}); // replace with actual URL

  Future<String> sendReq(String message) async {
    // const String webhookUrl =
    //     'https://dialogflow-webhook-production-d10f.up.railway.app/webhook';
    const String webhookUrl = 'http://192.168.1.107:5000/webhook';
    // Get current location

    // Create request body
    Map<String, dynamic> body = {
      "queryResult": {"queryText": message},
      "originalDetectIntentRequest": {
        "payload": {"latitude": lat, "longitude": long}
      }
    };

    // Send POST request to webhook

    final response = await http.post(
      Uri.parse(webhookUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['fulfillmentText'] ?? "No response.";
    } else {
      return "Sorry sometime went wrong";
    }
  }
}
