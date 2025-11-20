import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:genui_firebase_ai/genui_firebase_ai.dart';
import 'package:sample_bot/widgets/bot_message.dart';
import 'package:sample_bot/widgets/bureau_card.dart';
import 'package:sample_bot/widgets/customer_card.dart';
import 'package:sample_bot/widgets/loan_details_card.dart';
import 'package:sample_bot/widgets/loan_product_details.dart';
import 'package:sample_bot/widgets/user_message.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final query = TextEditingController();

  late final GenUiConversation conversation;
  late final Catalog catalog;

  final _surfaceIds = <String>[];

  String get lendingBotPrompt => """
You are a GenUI bot. You must ONLY generate UI using A2UI tool calls.

You MUST use only catalog widgets:
• bot_message_bubble
• user_message_bubble
• bureau_card
• customer_details_card
• choose_loan_product_card
• set_loan_details_card

============================================================
MESSAGE RULES
============================================================

1. A user_message_bubble MUST be generated ONLY when the USER types a text message.
2. UI events (button clicks, sliders, etc.) MUST NOT create user_message_bubbles.
3. Every bot reply MUST be one bot_message_bubble in a NEW surface.
4. Never generate more than ONE bot reply per user message or UI event.
5. Never respond unless:
   • The user typed a new message, OR
   • A UI event (UserActionEvent) occurred.

============================================================
SURFACE RULES
============================================================

• Start a new surface for every widget or bubble you generate.
• Never reuse surfaceIds.
• Never update or re-render previous surfaces.
• Never create EMPTY surfaces.
• Never respond to your own bot messages.

Allowed actions:
• BeginRendering
• SurfaceUpdate
• DeleteSurface

============================================================
LENDING BOT LOGIC
============================================================
NOTE : ENFORCE THE USER TO COMPLETE THE BELOW STEPS.

STEP 1 — CIF Validation
• When user types a CIF ID:
   - If not exactly 10 digits → reply: “Please enter a valid 10-digit CIF ID”
   - If valid → render customer_details_card

STEP 2 — Customer Verification Events
• confirm_clicked → user bubble : "Verification Confirmed" ->show only one time -> choose_loan_product_card
• reject_clicked → bot bubble: “Customer verification failed.” and Go Back to the Step 1

STEP 3 — Loan Product Selection
• loan_selected <type>:
   - user bubble : "loan_selected <type>"
   - bot bubble: “Checking bureau report…”
   - then show bureau_card only one time.

STEP 4 — Bureau Proceed Button
• proceed_clicked → show only one time -> set_loan_details_card

When generating this card, include:
{
  "loanAmount": 800000,
  "tenure": 36,
  "interestRate": 10.5
}

STEP 5 — Loan Detail Sliders
• For slider events: loan_amount, tenure, interest_rate:
   - Re-render ONLY the set_loan_details_card
   - DO NOT create bot bubbles
   - DO NOT create user bubbles
   - DO NOT create additional surfaces besides the new card

STEP 6 — Submit
• submit_application_clicked → bot bubble: “Thank you! Your loan is submitted.”

============================================================
ABSOLUTE RULE
============================================================
Only actual typed user text creates a user_message_bubble.  
UI events NEVER create user bubbles.

""";

  void _onSurfaceAdded(SurfaceAdded update) {
    // if (!mounted) return;
    setState(() {
      _surfaceIds.add(update.surfaceId);
      print(_surfaceIds);
      print(
        '[ChatBot] surface added: ${update.surfaceId}, total=${_surfaceIds.length}',
      );
    });
  }

  void _onSurfaceDeleted(SurfaceRemoved update) {
    // if (!mounted) return;
    setState(() {
      _surfaceIds.remove(update.surfaceId);
      print(
        '[ChatBot] surface removed: ${update.surfaceId}, total=${_surfaceIds.length}',
      );
    });
  }

  @override
  void initState() {
    super.initState();
    catalog = CoreCatalogItems.asCatalog().copyWith([
      robotMessage,
      userMessage,
      bureauCard,
      customerCard,
      chooseLoanProductCard,
      setLoanDetailsCard,
    ]);

    print('[ChatBot] catalog built, manager created');

    final generator = FirebaseAiContentGenerator(
      catalog: catalog,
      modelCreator:
          ({required configuration, systemInstruction, toolConfig, tools}) {
            return GeminiGenerativeModel(
              FirebaseAI.googleAI().generativeModel(
                model: 'gemini-2.5-pro',
                systemInstruction: systemInstruction,
                tools: tools,
                toolConfig: toolConfig,
              ),
            );
          },
      configuration: GenUiConfiguration(
        actions: ActionsConfig(
          allowCreate: true,
          allowUpdate: true,
          allowDelete: true,
        ),
      ),

      // additionalTools: ,
      systemInstruction: lendingBotPrompt,
    );

    generator.textResponseStream.listen((text) {
      print("AI TEXT RESPONSE: $text");
    });

    generator.errorStream.listen((err) {
      print("ERROR FROM GENERATOR: ${err.error}");
      print("STACK: ${err.stackTrace}");
    });

    print('checked');
    conversation = GenUiConversation(
      genUiManager: GenUiManager(catalog: catalog),
      contentGenerator: generator,
      onSurfaceAdded: _onSurfaceAdded,
      // onSurfaceDeleted: _onSurfaceDeleted,
      onSurfaceUpdated: (value) {
        print(_surfaceIds);
        print('next surface updated successfully,${value.surfaceId}');
      },
      // onError: (err) => print('getting error...$err'),
    );

    // Listen for A2UI messages (THIS IS WHAT TRIGGERS OUR UI RENDERING)
    generator.a2uiMessageStream.listen((msg) {
      print("A2UI MESSAGE RECEIVED: $msg");
      // _surfaceIds.remove("loading");
      conversation.genUiManager.handleMessage(msg);
    });

    conversation.genUiManager.onSubmit.listen((chatMessage) {
      print("UI EVENT RECEIVED: $chatMessage");
      if (chatMessage.text == "proceed_clicked") {
        print("Proceed button clicked!");
        conversation.sendRequest(UserMessage.text("proceed"));
      }

      if (chatMessage.text == "confirm_clicked") {
        conversation.sendRequest(UserMessage.text("confirm"));
      }

      if (chatMessage.text == "reject_clicked") {
        conversation.sendRequest(UserMessage.text("reject"));
      }

      if (chatMessage.text == "submit_application_clicked") {
        conversation.sendRequest(UserMessage.text("submit_application"));
      }

      //when user selects a loan products
      if (chatMessage.text.startsWith("loan_selected:")) {
        final loanType = chatMessage.text.split(":")[1];

        conversation.sendRequest(UserMessage.text("loan_selected $loanType"));
      }
    });

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   conversation.sendRequest(UserMessage.text("hi"));
    // });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text('Lending Bot'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _surfaceIds.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 13),
                    child: GenUiSurface(
                      host: conversation.host,
                      surfaceId: _surfaceIds[index],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: query,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10),
                  hintText: 'Update here ...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                  suffixIcon: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue,
                    ),
                    child: IconButton(
                      color: Colors.white,
                      onPressed: () async {
                        print('msg is ${query.text}');
                        if (query.text.trim().isEmpty) return;
                        // appendUserMessage(query.text);
                        conversation.sendRequest(UserMessage.text(query.text));
                        query.clear();
                      },
                      icon: Icon(Icons.send),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
