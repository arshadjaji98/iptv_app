import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:iptv_app/model/channel.dart';

class IptvService {
  static Future<List<Channel>> fetchChannels() async {
    try {
      // Fetch channels metadata
      final channelsResponse = await http.get(
        Uri.parse('https://iptv-org.github.io/api/channels.json'),
      );

      // Fetch streams data
      final streamsResponse = await http.get(
        Uri.parse('https://iptv-org.github.io/api/streams.json'),
      );

      final List channelsData = jsonDecode(channelsResponse.body);
      final List streamsData = jsonDecode(streamsResponse.body);

      // Map channels and assign first playable stream URL
      final List<Channel> channels = channelsData.map((c) {
        final stream = streamsData.firstWhere(
          (s) =>
              s['channel'] == c['id'] &&
              s['url'] != null &&
              (s['url'].toString().endsWith('.m3u8') ||
                  s['url'].toString().endsWith('.mp4')),
          orElse: () => null,
        );

        return Channel(
          id: c['id'] ?? '',
          name: c['name'] ?? 'Unknown',
          country: c['country'] ?? 'Unknown',
          streamUrl: stream != null ? stream['url'] : '',
        );
      }).toList();

      if (kDebugMode) {
        print('Loaded channels: ${channels.length}');
        print(channels.map((c) => '${c.name} => ${c.streamUrl}').toList());
      }

      return channels;
    } catch (e, st) {
      if (kDebugMode) {
        print('ERROR: $e');
        print('STACKTRACE: $st');
      }
      return [];
    }
  }
}
