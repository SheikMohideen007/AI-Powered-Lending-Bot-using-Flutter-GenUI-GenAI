import 'package:json_schema_builder/json_schema_builder.dart';

final customerDetailsSchema = S.object(
  properties: {
    'name': S.string(description: 'Customer name'),
    'dob': S.string(description: 'Date of Birth'),
    'phone': S.string(description: 'Phone number'),
    'email': S.string(description: 'Email'),
    'aadharVid': S.string(description: 'Aadhar ID'),
    'panId': S.string(description: 'PAN number'),
    'kycVerified': S.boolean(description: 'Whether KYC is verified'),
  },
  required: [
    'name',
    'dob',
    'phone',
    'email',
    'aadharVid',
    'panId',
    'kycVerified',
  ],
);
