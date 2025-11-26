import 'package:flutter/material.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact Us"),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade800, Colors.blue.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Card(
            margin: const EdgeInsets.all(20),
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.contact_phone, size: 60, color: Colors.lightBlue.shade200),
                  const SizedBox(height: 20),
                  const Text(
                    'Get in Touch',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'For any inquiries, please contact us at:',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Phone: 086703456',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Email: support@modernbank.com',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
