import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';
import 'package:prezentare_comunitate/constants.dart';

class GenerateRecipeScreen extends StatefulWidget {
  const GenerateRecipeScreen({super.key});

  @override
  State<GenerateRecipeScreen> createState() => _GenerateRecipeScreenState();
}

class _GenerateRecipeScreenState extends State<GenerateRecipeScreen> {
  final _txtController = TextEditingController();

  late OpenAI openAI;

  Future<CTResponse?>? _responseFuture;
  void _submitPrompt() async {
    setState(() {
      final request = CompleteText(
        prompt:
            "Create a recipe using the ingredients I have in my fridge. My fridge currently contains ${_txtController.text}. Please provide a step-by-step guide on how to prepare the dish, including cooking times and temperatures where applicable. Bonus points for creative uses of the ingredients and for using as many of the ingredients as possible.",
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
        backgroundColor: Colors.purple[900],
        elevation: 0,
        title: const Text(
          'Generate Recipe',
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
                hintText: 'Enter here what ingredients you have in the fridge',
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
                    return const Color.fromARGB(255, 87, 23, 167);
                  }),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40.0))),
                ),
                onPressed: () {
                  _submitPrompt();
                  _txtController.text = '';
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Generate Recipe',
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
