import 'package:flutter/material.dart';
import 'Screens/deposit_screen.dart';
import 'Screens/withdraw_screen.dart';
import 'Screens/contact_us_screen.dart';

class BalancePage extends StatelessWidget {
  const BalancePage({super.key});

  final List<Map<String, dynamic>> balanceData = const [
    {"balanceID": 1, "balance": 999953000},
  ];

  @override
  Widget build(BuildContext context) {
    int balance = balanceData[0]["balance"];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Balance"),
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Available Balance',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '\$${balance.toString()}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                elevation: 8,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildInfoColumn('Last Deposit', '+\$500'),
                      _buildInfoColumn('Last Withdrawal', '-\$200'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String title, String value) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

void main() {
  runApp(const BankingApp());
}

class BankingApp extends StatelessWidget {
  const BankingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Banking System",
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      themeMode: ThemeMode.dark,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade800, Colors.blue.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 80),
            Icon(Icons.account_balance, size: 80, color: Colors.lightBlue.shade200),
            const SizedBox(height: 20),
            const Text(
              'Modern Bank',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 50),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                padding: const EdgeInsets.all(20),
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                children: [
                  _buildMenuCard(context, 'Deposit', Icons.account_balance, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const DepositPage()),
                    );
                  }),
                  _buildMenuCard(context, 'Withdraw', Icons.account_balance_wallet, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const WithdrawPage()),
                    );
                  }),
                  _buildMenuCard(context, 'Check Balance', Icons.attach_money, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const BalancePage()),
                    );
                  }),
                  _buildMenuCard(context, 'Contact Us', Icons.contact_mail, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ContactUsPage()),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.lightBlue.shade200),
            const SizedBox(height: 15),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
