import 'dart:math';

import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:sample_bot/schemas/loandetails_schema.dart';

final setLoanDetailsCard = CatalogItem(
  name: 'set_loan_details_card',
  dataSchema: setLoanDetailsSchema,
  widgetBuilder: (context) {
    final json = context.data as Map<String, Object?>;

    return SetLoanDetailsCardWidget(
      genContext: context,
      loanAmount: (json['loanAmount'] as num).toDouble(),
      tenure: (json['tenure'] as num).toDouble(),
      interestRate: (json['interestRate'] as num).toDouble(),
    );
  },
);

class SetLoanDetailsCardWidget extends StatefulWidget {
  final CatalogItemContext genContext;
  final double loanAmount;
  final double tenure;
  final double interestRate;

  const SetLoanDetailsCardWidget({
    super.key,
    required this.genContext,
    required this.loanAmount,
    required this.tenure,
    required this.interestRate,
  });

  @override
  State<SetLoanDetailsCardWidget> createState() =>
      _SetLoanDetailsCardWidgetState();
}

class _SetLoanDetailsCardWidgetState extends State<SetLoanDetailsCardWidget> {
  late double loanAmount;
  late double tenure;
  late double interestRate;

  @override
  void initState() {
    super.initState();
    loanAmount = widget.loanAmount;
    tenure = widget.tenure;
    interestRate = widget.interestRate;
  }

  double calculateEMI() {
    double p = loanAmount;
    double r = interestRate / 12 / 100;
    int n = tenure.toInt();

    return p * r * pow(1 + r, n) / (pow(1 + r, n) - 1);
  }

  @override
  Widget build(BuildContext context) {
    final emi = calculateEMI();

    return Card(
      elevation: 6,
      margin: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Set Loan Details",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            const Text("Loan Amount"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Rs. 5,00,000"),
                const Text("Rs. 20,00,000"),
              ],
            ),
            Slider(
              min: 500000,
              max: 2000000,
              value: loanAmount,
              onChanged: (value) {
                setState(() => loanAmount = value);
              },
            ),

            const SizedBox(height: 10),

            const Text("Tenure (Months)"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [Text("12 months"), Text("120 months")],
            ),
            Slider(
              min: 12,
              max: 120,
              value: tenure,
              onChanged: (value) {
                setState(() => tenure = value);
              },
            ),

            const SizedBox(height: 10),

            const Text("Interest Rate (p.a.)"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [Text("2.0 %"), Text("15.0 %")],
            ),
            Slider(
              min: 2,
              max: 15,
              value: interestRate,
              onChanged: (value) {
                setState(() => interestRate = value);
              },
            ),

            const SizedBox(height: 20),

            Center(
              child: Text(
                "Estimated EMI: ₹${emi.round()}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                widget.genContext.dispatchEvent(
                  UserActionEvent(
                    surfaceId: widget.genContext.surfaceId,
                    name:
                        "submit_application:${loanAmount},${tenure},${interestRate},${emi}",
                    sourceComponentId: widget.genContext.id,
                  ),
                );
              },
              child: const Text("Submit Application"),
            ),
          ],
        ),
      ),
    );
  }
}
