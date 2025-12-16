import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Settings')),
    body: ListView(children: [
      ListTile(leading: const Icon(Icons.palette), title: const Text('App Theme'), trailing: const Icon(Icons.chevron_right), onTap: () {}),
      ListTile(leading: const Icon(Icons.notifications), title: const Text('Notifications'), trailing: const Icon(Icons.chevron_right), onTap: () {}),
      ListTile(leading: const Icon(Icons.language), title: const Text('Language'), trailing: const Icon(Icons.chevron_right), onTap: () {}),
      ListTile(leading: const Icon(Icons.delete), title: const Text('Clear Data'), onTap: () {}),
      const Divider(),
      ListTile(leading: const Icon(Icons.info), title: const Text('About App'), onTap: () {}),
      ListTile(leading: const Icon(Icons.star), title: const Text('Rate App'), onTap: () {}),
    ]),
  );
}