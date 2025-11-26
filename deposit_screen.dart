import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DepositPage extends StatefulWidget {
  const DepositPage({super.key});

  @override
  State<StatefulWidget> createState() => _DepositPageState();
}

class _DepositPageState extends State<DepositPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  Map<String, dynamic>? depositResult;

  // NEW: store deposit list 
  List<dynamic> depositList = [];

  // NEW: fetch deposit history
  Future<void> _fetchDeposits() async {
    final url = Uri.parse('https://bank-api-mobile-project.vercel.app/deposit');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        depositList = jsonDecode(response.body);
      });
    }
  }

  // Deposit POST Request 
  Future<void> _deposit() async {
    final url = Uri.parse('https://bank-api-mobile-project.vercel.app/deposit');

    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'account_no': _accountController.text,
      'amount': _amountController.text,
    });

    final res = await http.post(url, headers: headers, body: body);

    if (!mounted) return;

    if (res.statusCode == 200 || res.statusCode == 201) {
      final data = jsonDecode(res.body);

      setState(() {
        depositResult = data;
      });

      // Reload deposit list after successful deposit
      _fetchDeposits();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Deposit Successful")));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Deposit Failed")));
    }
  }

  // NEW: run GET when page opens 
  @override
  void initState() {
    super.initState();
    _fetchDeposits();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Deposit"),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 90),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _accountController,
                            decoration: InputDecoration(
                              labelText: "Account Number",
                              prefixIcon: Icon(Icons.arrow_downward, color: Colors.lightBlue.shade200),
                            ),
                            validator: (value) =>
                                value!.isEmpty ? "Please enter account number" : null,
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _amountController,
                            decoration: InputDecoration(
                              labelText: "Amount",
                              prefixIcon: Icon(Icons.attach_money, color: Colors.lightBlue.shade200),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) =>
                                value!.isEmpty ? "Please enter amount" : null,
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _deposit();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text("DEPOSIT", style: TextStyle(fontSize: 16)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // ---------------- SHOW RESULT ----------------
              if (depositResult != null) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Deposit Result:",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 8),
                      Text("Account: ${depositResult!['account_no']}", style: const TextStyle(color: Colors.white70)),
                      Text("Amount: ${depositResult!['amount']}", style: const TextStyle(color: Colors.white70)),
                      if (depositResult!.containsKey('balance'))
                        Text("New Balance: ${depositResult!['balance']}", style: const TextStyle(color: Colors.white70)),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 30),

              // ---------------- SHOW DEPOSIT HISTORY ----------------
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "All Deposits:",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              const SizedBox(height: 10),

              if (depositList.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text("No deposit records found.", style: TextStyle(color: Colors.white70)),
                ),
              if (depositList.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('ID')),
                          DataColumn(label: Text('Date')),
                          DataColumn(label: Text('Amount')),
                        ],
                        rows: depositList.map((item) {
                          return DataRow(cells: [
                            DataCell(Text(item['depositID'].toString())),
                            DataCell(Text(item['date'].toString())),
                            DataCell(Text(item['amount'].toString())),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
