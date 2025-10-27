// lib/homepage.dart
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController targetController = TextEditingController();
  TextEditingController savingController = TextEditingController();
  TextEditingController startingController = TextEditingController();

  String? periodOption = "Weekly"; // dropdown option
  String result = "";
  String? message;

  void calculateGoal() {
    setState(() {
      message = null;
      result = "";

      double? target = double.tryParse(targetController.text);
      double? saving = double.tryParse(savingController.text);
      double start = double.tryParse(startingController.text) ?? 0;

      if (target == null || saving == null) {
        message = "Please enter valid numbers.";
        return;
      }

      if (target <= 0 || saving <= 0) {
        message = "Target and saving must be greater than 0.";
        return;
      }

      if (start >= target) {
        result = "You already reached your goal!";
        return;
      }

      double remain = target - start;
      double weeks = remain / saving;
      int wholeWeeks = weeks.floor();
      int days = ((weeks - wholeWeeks) * 7).round();

      if (periodOption == "Monthly") {
        double months = weeks / 4;
        result = "You need about ${months.toStringAsFixed(1)} months to reach RM${target.toStringAsFixed(2)}.";
      } else {
        result = "You need about $wholeWeeks weeks and $days days to reach RM${target.toStringAsFixed(2)}.";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Savings Goal Tracker")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                "Plan your savings and estimate how long will it takes to reach your goal.",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // Target amount input
              TextField(
                controller: targetController,
                decoration: const InputDecoration(
                  labelText: "Target Amount (RM)",
                  hintText: "Enter target amount",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.payments),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),

              // Saving per period
              TextField(
                controller: savingController,
                decoration: const InputDecoration(
                  labelText: "Saving (RM)",
                  hintText: "Enter saving per week/month",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.savings),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),

              // Starting balance
              TextField(
                controller: startingController,
                decoration: const InputDecoration(
                  labelText: "Starting Balance (RM)",
                  hintText: "Optional starting amount",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.account_balance_wallet),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),

              // Dropdown for frequency
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButton<String>(
                  value: periodOption,
                  isExpanded: true,
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(value: "Weekly", child: Text("Weekly")),
                    DropdownMenuItem(value: "Monthly", child: Text("Monthly")),
                  ],
                  onChanged: (value) {
                    setState(() {
                      periodOption = value!;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Calculate button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: calculateGoal,
                  child: const Text("Calculate"),
                ),
              ),
              const SizedBox(height: 20),

              // Message display
              if (message != null)
                Text(
                  message!,
                  style: const TextStyle(color: Colors.red),
                ),

              // Result display
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  result.isEmpty ? "Result: --" : result,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
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
