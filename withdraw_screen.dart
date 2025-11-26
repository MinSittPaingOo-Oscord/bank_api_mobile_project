import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class WithdrawPage extends StatefulWidget {
  const WithdrawPage({super.key});

  @override
  State<StatefulWidget> createState() => _WithdrawPageState();
}

class _WithdrawPageState extends State<WithdrawPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  // NEW: Withdrawal List 
  List<dynamic> withdrawList = [];

  // NEW: Fetch all withdrawal records
  Future<void> _fetchWithdraws() async {
    final url = Uri.parse(
      'https://bank-api-mobile-project.vercel.app/withdraw',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        withdrawList = jsonDecode(response.body);
      });
    }
  }

  // Withdrawal POST Request 
  Future<void> _withdraw() async {
    final url = Uri.parse(
      'https://bank-api-mobile-project.vercel.app/withdraw',
    );

    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'account_no': _accountController.text,
      'amount': _amountController.text,
    });

    final res = await http.post(url, headers: headers, body: body);

    if (!mounted) return;

    if (res.statusCode == 200 || res.statusCode == 201) {
      _showSnackBar('Withdraw Successful');

      _fetchWithdraws();
    } else {
      _showSnackBar('Withdraw Failed');
    }
  }

  void _showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  void initState() {
    super.initState();
    _fetchWithdraws();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Withdrawal"),
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
                              prefixIcon: Icon(Icons.arrow_upward, color: Colors.lightBlue.shade200),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter account number";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _amountController,
                            decoration: InputDecoration(
                              labelText: "Amount",
                              prefixIcon: Icon(Icons.money_off, color: Colors.lightBlue.shade200),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter amount";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _withdraw();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text("WITHDRAW", style: TextStyle(fontSize: 16)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "All Withdrawals:",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              const SizedBox(height: 10),

              if (withdrawList.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text("No withdraw records found.", style: TextStyle(color: Colors.white70)),
                ),

              if (withdrawList.isNotEmpty)
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
                        rows: withdrawList.map((item) {
                          return DataRow(cells: [
                            DataCell(Text(item['withdrawID'].toString())),
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
