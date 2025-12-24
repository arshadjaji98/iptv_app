import 'package:flutter/material.dart';
import 'package:iptv_app/model/channel.dart';
import 'package:iptv_app/services/iptv_services.dart';
import 'player_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Channel> allChannels = [];
  List<Channel> filteredChannels = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadChannels();
  }

  Future<void> loadChannels() async {
    final channels = await IptvService.fetchChannels();
    setState(() {
      allChannels = channels;
      filteredChannels = channels;
      loading = false;
    });
  }

  void search(String query) {
    setState(() {
      filteredChannels = allChannels
          .where((c) => c.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('IPTV')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search channel...',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: search,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredChannels.length,
                    itemBuilder: (context, index) {
                      final channel = filteredChannels[index];
                      return ListTile(
                        title: Text(channel.name),
                        subtitle: Text(channel.country),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PlayerScreen(channel),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
