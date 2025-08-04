import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voxta_app/Providers/Login_provider.dart';
import 'package:voxta_app/textStyles.dart';

class TermsAndConditionScreen extends StatelessWidget {
  const TermsAndConditionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Terms & Instructions'),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  SectionHeader('📜 Terms of Service'),
                  SizedBox(height: 10),
                  SectionText(
                      'By using this app, you agree not to post harmful, illegal, or offensive content. '
                      'You must be at least 13 years old to use this app. We reserve the right to suspend accounts that violate our rules.'),
              
                  SizedBox(height: 10),
                  SectionHeader('🔒 Privacy Policy'),
                  SizedBox(height: 10),
                  SectionText(
                      'We value your privacy. Your messages, calls, and media are encrypted. '
                      'We do not sell or share your personal data with third parties without your consent.'),
              
                  SizedBox(height: 10),
                  SectionHeader('📱 App Instructions'),
                  SizedBox(height: 10),
                  SectionText(
                      '- 📸 Post a status by tapping the "+" button on the home screen.\n'
                      '- 💬 Chat with friends by tapping their profile.\n'
                      '- 📞 Make audio/video calls using the call icon in chat.\n'
                      '- 🔍 Use search to find people and follow them.\n'
                      '- 🔔 Stay updated with notifications on likes, follows, and messages.'),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: Size(double.infinity, 40),
                ),
                onPressed: () {
                  if(!loginProvider.isAccept){
                    loginProvider.isAccepted();
                  }
                  Navigator.pop(context); 
                },
                child: Text(
                  'I Agree and Continue',
                  style: TextStyles.nxtbtn,
                  ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  const SectionHeader(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }
}

class SectionText extends StatelessWidget {
  final String text;
  const SectionText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        color: Colors.black87,
        height: 1.4,
      ),
    );
  }
}
