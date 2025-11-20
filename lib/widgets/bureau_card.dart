import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:sample_bot/schemas/bureau_schema.dart';

final bureauCard = CatalogItem(
  name: 'bureau_card',
  dataSchema: bureauCardSchema,
  widgetBuilder: (context) {
    final json = context.data as Map<String, Object?>;
    final score = json['score'] as String;
    final currentEMI = json['currentEMI'] as String;
    final outAmt = json['score'] as String;
    return BureauReportCard(
      score: score,
      currentEmi: currentEMI,
      outstandingLoan: outAmt,
      onProceed: () {
        context.dispatchEvent(
          UserActionEvent(
            surfaceId: context.surfaceId,
            name: "proceed_clicked",
            sourceComponentId: context.id,
            context: {},
          ),
        );
      },
    );
  },
);

class BureauReportCard extends StatelessWidget {
  final String score;
  final String currentEmi;
  final String outstandingLoan;
  final VoidCallback onProceed;
  const BureauReportCard({
    super.key,
    required this.score,
    required this.currentEmi,
    required this.outstandingLoan,
    required this.onProceed,
  });

  @override
  Widget build(BuildContext context) {
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
              "Bureau Report",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            // Score Box
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 28,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.shade600,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      score.toString(),
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Bureau Score",
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // EMI & Outstanding Amount
            Center(
              child: Column(
                children: [
                  Text(
                    "Current EMI - Rs. ${currentEmi.toString()}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Outstanding Loan Amount - Rs. ${outstandingLoan.toString()}",
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: onProceed,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Proceed",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
