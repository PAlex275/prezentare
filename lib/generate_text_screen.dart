import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';
import 'package:prezentare_comunitate/constants.dart';

class GenerateTextScreen extends StatefulWidget {
  const GenerateTextScreen({super.key});

  @override
  State<GenerateTextScreen> createState() => _GenerateTextScreenState();
}

class _GenerateTextScreenState extends State<GenerateTextScreen> {
  final _txtController = TextEditingController();

  late OpenAI openAI;

  Future<CTResponse?>? _responseFuture;
  void _submitPrompt() async {
    setState(() {
      final request = CompleteText(
        prompt: _txtController.text,
        maxTokens: 200,
        model: Model.textDavinci3,
      );
      _responseFuture = openAI.onCompletion(request: request);
    });
  }

  @override
  void initState() {
    openAI = OpenAI.instance.build(
        token: token,
        baseOption: HttpSetup(
            receiveTimeout: const Duration(seconds: 20),
            connectTimeout: const Duration(seconds: 20)),
        isLog: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 23, 167, 150),
        elevation: 0,
        title: const Text(
          'Generate Text',
          style: TextStyle(
            fontSize: 25,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 40,
          vertical: 30,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              maxLines: 3,
              controller: _txtController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                hintText: 'Enter your prompt here',
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            FutureBuilder<CTResponse?>(
                future: _responseFuture,
                builder: (context, snapshot) {
                  final text = snapshot.data?.choices.last.text;
                  return Container(
                    height: 250,
                    margin: const EdgeInsets.symmetric(vertical: 32.0),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    alignment: Alignment.center,
                    decoration: heroCard,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SingleChildScrollView(
                            child: Text(
                              text ?? 'Loading...',
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 15.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
            const SizedBox(
              height: 80,
            ),
            OutlinedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.resolveWith<Color>((states) {
                    return const Color.fromARGB(255, 23, 167, 150);
                  }),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40.0))),
                ),
                onPressed: () {
                  _submitPrompt();
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Generate',
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
