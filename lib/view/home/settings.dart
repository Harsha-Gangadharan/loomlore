import 'package:flutter/material.dart';
import 'package:flutterlore/view/home/privacy.dart';
import 'package:flutterlore/view/home/terms.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';  // Import FontAwesome

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
              _showAboutUsDialog(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text('Share'),
            onTap: () {
              _shareApp();  // Share app functionality
            },
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('Terms and Conditions'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TermsConditions()),
              );
            },
          ),
         
        ],
      ),
    );
  }

  void _showAboutUsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('About Us'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/logo.png', // Your image asset path
                height: 100,
              ),
              const SizedBox(height: 20),
              const Text(
                'Loom Lore is a dress design app that helps users design their own dresses. '
                'Users can communicate with fashion designers and participate in fashion shows, where the designers serve as judges. '
                'Additionally, users can view designers\' creations and explore color combinations that match different outfits.',
                textAlign: TextAlign.justify,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _shareApp() {
    final String message = 'Check out Loom Lore, a unique dress design app! Download it now from: <Your App Link>';
    Share.share(message);  // General share functionality
  }

  Future<void> _shareViaWhatsApp() async {
    final String message = 'Check out Loom Lore! Download it now from: <Your App Link>';
    final Uri whatsappUrl = Uri.parse('whatsapp://send?text=$message');

    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl);
    } else {
      print('WhatsApp not installed');
    }
  }

  Future<void> _shareViaInstagram() async {
    final String message = 'Check out Loom Lore! Download it now from: <Your App Link>';
    final Uri instagramUrl = Uri.parse('instagram://share');

    if (await canLaunchUrl(instagramUrl)) {
      await launchUrl(instagramUrl);
    } else {
      print('Instagram not installed');
    }
  }
}
