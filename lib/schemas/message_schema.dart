import 'package:json_schema_builder/json_schema_builder.dart';

final messageSchema = S.object(
  properties: {'chat': S.string(description: 'The chat text from the bot')},
  required: ['chat'],
);
