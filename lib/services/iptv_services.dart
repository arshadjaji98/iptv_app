import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:iptv_app/model/channel.dart';

class IptvService {
  static Future<List<Channel>> fetchChannels() async {
    try {
      final response = await http.get(
        Uri.parse('https://iptv-org.github.io/api/channels.json'),
      );
      print('Status code: ${response.statusCode}');
      print('Response length: ${response.body.length}');
      final List data = jsonDecode(response.body);
      print('Total items: ${data.length}');
      return data
          .map(
            (json) => Channel(
              name: json['name'] ?? '',
              country: json['country'] ?? '',
              streamUrl: 'https://iptv-org.github.io/api/streams.json',
              id: '',
            ),
          )
          .toList();
    } catch (e, st) {
      print('ERROR: $e');
      print('STACK: $st');
      return [];
    }
  }
}
