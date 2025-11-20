import 'package:json_schema_builder/json_schema_builder.dart';

final bureauCardSchema = S.object(
  properties: {
    'score': S.string(description: 'Bureau score'),
    'currentEMI': S.string(description: 'Current EMI amount'),
    'outstandingLoan': S.string(description: 'Total outstanding loan'),
  },
  required: ['score', 'currentEMI', 'outstandingLoan'],
);
