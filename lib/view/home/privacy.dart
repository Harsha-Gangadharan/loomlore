import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text("Privacy Policy",
         style: GoogleFonts.berkshireSwash(
              color: Color(0xff410502),
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: const Text(
          'Privacy Policy\n\n'
          'This privacy policy applies to the app (hereby referred to as "Application") for mobile devices that was created by (hereby referred to as "Service Provider") as a Free service. '
          'This service is intended for use "AS IS".\n\n'
          'Information Collection and Use\n\n'
          'The Application collects information when you download and use it. This information may include information such as:\n\n'
          'Your device\'s Internet Protocol address (e.g. IP address), the pages of the Application that you visit, the time and date of your visit, the time spent on those pages, '
          'the time spent on the Application, the operating system you use on your mobile device.\n\n'
          'The Application does not gather precise information about the location of your mobile device.\n\n'
          'The Service Provider may use the information you provided to contact you from time to time to provide you with important information, required notices, and marketing promotions.\n\n'
          'For a better experience, while using the Application, the Service Provider may require you to provide certain personally identifiable information. The information that the Service Provider requests will be retained by them and used as described in this privacy policy.\n\n'
          'Third Party Access\n\n'
          'Only aggregated, anonymized data is periodically transmitted to external services to aid the Service Provider in improving the Application and their service. The Service Provider may share your information with third parties in the ways that are described in this privacy statement.\n\n'
          'Please note that the Application utilizes third-party services that have their own Privacy Policy about handling data. Below are the links to the Privacy Policy of the third-party service providers used by the Application:\n\n'
          'Google Play Services\n\n'
          'The Service Provider may disclose User Provided and Automatically Collected Information as required by law, such as to comply with a subpoena, or similar legal process; when they believe in good faith that disclosure is necessary to protect their rights, protect your safety or the safety of others, investigate fraud, or respond to a government request; '
          'with their trusted services providers who work on their behalf, do not have an independent use of the information we disclose to them, and have agreed to adhere to the rules set forth in this privacy statement.\n\n'
          'Opt-Out Rights\n\n'
          'You can stop all collection of information by the Application easily by uninstalling it. You may use the standard uninstall processes as may be available as part of your mobile device or via the mobile application marketplace or network.\n\n'
          'Data Retention Policy\n\n'
          'The Service Provider will retain User Provided data for as long as you use the Application and for a reasonable time thereafter. If you would like them to delete User Provided Data that you have provided via the Application, please contact them, and they will respond in a reasonable time.\n\n'
          'Children\n\n'
          'The Service Provider does not use the Application to knowingly solicit data from or market to children under the age of 13. The Application does not address anyone under the age of 13. '
          'The Service Provider does not knowingly collect personally identifiable information from children under 13 years of age. In the case the Service Provider discovers that a child under 13 has provided personal information, '
          'the Service Provider will immediately delete this from their servers. If you are a parent or guardian and you are aware that your child has provided us with personal information, please contact the Service Provider so that they will be able to take the necessary actions.\n\n'
          'Security\n\n'
          'The Service Provider is concerned about safeguarding the confidentiality of your information. The Service Provider provides physical, electronic, and procedural safeguards to protect information the Service Provider processes and maintains.\n\n'
          'Changes\n\n'
          'This Privacy Policy may be updated from time to time for any reason. The Service Provider will notify you of any changes to the Privacy Policy by updating this page with the new Privacy Policy. '
          'You are advised to consult this Privacy Policy regularly for any changes, as continued use is deemed approval of all changes.\n\n'
          'This privacy policy is effective as of 2024-09-07\n\n'
          'Your Consent\n\n'
          'By using the Application, you are consenting to the processing of your information as set forth in this Privacy Policy now and as amended by us.\n\n'
          'Contact Us\n\n'
          'If you have any questions regarding privacy while using the Application, or have questions about the practices, please contact the Service Provider via email.\n\n'
          'This privacy policy page was generated by App Privacy Policy Generator.',
        ),
      ),
    );
  }
}
