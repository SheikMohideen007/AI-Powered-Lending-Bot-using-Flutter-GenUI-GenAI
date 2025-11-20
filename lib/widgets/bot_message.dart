import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:sample_bot/schemas/message_schema.dart';

final robotMessage = CatalogItem(
  name: 'bot_message_bubble',
  dataSchema: messageSchema,
  widgetBuilder: (context) {
    final json = context.data as Map<String, Object?>;
    String text = json['chat'] as String;
    return botMessage(text);
  },
);

Widget botMessage(String text) {
  return Align(
    alignment: Alignment.centerLeft,
    child: Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Text(text, style: const TextStyle(fontSize: 15)),
    ),
  );
}
