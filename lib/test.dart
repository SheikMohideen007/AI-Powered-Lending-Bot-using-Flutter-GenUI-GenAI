import 'dart:async';
import 'package:genui/genui.dart';
import 'package:genui_firebase_ai/genui_firebase_ai.dart';

Future<String> testFirebaseAIResponse() async {
  final catalog = CoreCatalogItems.asCatalog();

  final generator = FirebaseAiContentGenerator(
    catalog: catalog,
    systemInstruction: 'You are a simple assistant. Reply with: TEST_OK',
  );

  final completer = Completer<String>();

  // Listen for text responses
  final subText = generator.textResponseStream.listen((text) {
    if (!completer.isCompleted) {
      completer.complete(text);
    }
  });

  // Listen for errors
  final subErr = generator.errorStream.listen((err) {
    if (!completer.isCompleted) {
      completer.completeError(err.error ?? 'Unknown error from generator');
    }
  });

  await generator.sendRequest(UserMessage.text('Hello'));

  // Await reply (or error). Add a timeout.
  try {
    final result = await completer.future.timeout(
      const Duration(seconds: 20),
      onTimeout: () => throw Exception('Timed out waiting for AI response'),
    );
    return result;
  } finally {
    // cleanup
    await subText.cancel();
    await subErr.cancel();
    generator.dispose();
  }
}
