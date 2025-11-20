import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:sample_bot/schemas/loanprod_schema.dart';

final chooseLoanProductCard = CatalogItem(
  name: 'choose_loan_product_card',
  dataSchema: chooseLoanProductSchema,
  widgetBuilder: (context) {
    return ChooseLoanProductCard(context: context);
  },
);

class ChooseLoanProductCard extends StatelessWidget {
  final CatalogItemContext context;

  const ChooseLoanProductCard({super.key, required this.context});

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
              "Choose Loan Product",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            _loanTile(icon: Icons.home, label: "Home Loan"),

            const SizedBox(height: 10),

            _loanTile(icon: Icons.directions_car, label: "Car Loan"),

            const SizedBox(height: 10),

            _loanTile(icon: Icons.work, label: "Personal Loan"),
          ],
        ),
      ),
    );
  }

  Widget _loanTile({required IconData icon, required String label}) {
    return InkWell(
      onTap: () {
        context.dispatchEvent(
          UserActionEvent(
            surfaceId: context.surfaceId,
            name: "loan_selected:$label",
            sourceComponentId: context.id,
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue.shade50,
              child: Icon(icon, color: Colors.blue),
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
