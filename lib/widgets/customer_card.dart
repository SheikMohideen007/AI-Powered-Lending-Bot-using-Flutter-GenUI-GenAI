import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:sample_bot/schemas/customer_schema.dart';

final customerCard = CatalogItem(
  name: 'customer_details_card',
  dataSchema: customerDetailsSchema,
  widgetBuilder: (context) {
    final json = context.data as Map<String, Object?>;

    final name = json['name'] as String;
    final dob = json['dob'] as String;
    final phone = json['phone'] as String;
    final email = json['email'] as String;
    final aadharVid = json['aadharVid'] as String;
    final panId = json['panId'] as String;
    final kycVerified = json['kycVerified'] as bool;

    return customerDetailsCard(
      name: name,
      dob: dob,
      phone: phone,
      email: email,
      aadharVid: aadharVid,
      panId: panId,
      kycVerified: kycVerified,
      onConfirm: () {
        context.dispatchEvent(
          UserActionEvent(
            surfaceId: context.surfaceId,
            name: "confirm_clicked",
            sourceComponentId: context.id,
          ),
        );
      },
      onReject: () {
        context.dispatchEvent(
          UserActionEvent(
            surfaceId: context.surfaceId,
            name: "reject_clicked",
            sourceComponentId: context.id,
          ),
        );
      },
    );
  },
);

Widget customerDetailsCard({
  required Function() onConfirm,
  required Function() onReject,
  required String dob,
  required String phone,
  required String email,
  required String aadharVid,
  required String panId,
  required bool kycVerified,
  required String name,
}) {
  return Align(
    alignment: Alignment.centerLeft,
    child: Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Customer Details",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          detailsRow("Name:", name),
          detailsRow("DOB:", dob),
          detailsRow("Phone:", phone),
          detailsRow("Email:", email),
          detailsRow("Aadhar VID:", aadharVid),
          detailsRow("PAN ID:", panId),

          const SizedBox(height: 10),

          Row(
            children: const [
              Text("KYC Verified?", style: TextStyle(fontSize: 15)),
              SizedBox(width: 8),
              Icon(Icons.check_circle, color: Colors.green, size: 22),
              SizedBox(width: 4),
              Text("Yes", style: TextStyle(fontSize: 15, color: Colors.green)),
            ],
          ),

          const SizedBox(height: 15),

          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onConfirm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("Confirm Yes"),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: onReject,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.black54),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("No"),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget detailsRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(
      children: [
        SizedBox(
          width: 110,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(child: Text(value)),
      ],
    ),
  );
}
