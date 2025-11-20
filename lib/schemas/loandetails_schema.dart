import 'package:json_schema_builder/json_schema_builder.dart';

final setLoanDetailsSchema = S.object(
  properties: {
    'loanAmount': S.number(description: 'Selected loan amount'),
    'tenure': S.number(description: 'Loan tenure in months'),
    'interestRate': S.number(description: 'Annual interest rate'),
  },
  required: ['loanAmount', 'tenure', 'interestRate'],
);
