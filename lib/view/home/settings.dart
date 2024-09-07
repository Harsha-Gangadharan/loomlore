import 'package:flutter/material.dart';
import 'package:flutterlore/view/home/privacy.dart';
import 'package:flutterlore/view/home/terms.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text('Privacy Policy'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PrivacyPolicy()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About Us'),
            onTap: () {
              // Navigate to About Us page 
            },
          ),
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text('Share'),
            onTap: () {
              // Implement sharing functionality
            },
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('Terms and Conditions'),
            onTap: () {
               Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TermsConditions()),
              );  // Navigate to Terms and Conditions page 
            },
          ),
        ],
      ),
    );
  }
}
