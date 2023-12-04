import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';

class AIHandler {
  final _openAI = OpenAI.instance.build(
    token: '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',
    baseOption: HttpSetup(
      receiveTimeout: const Duration(seconds: 60),
      connectTimeout: const Duration(seconds: 60),
    ),
  );

  Future<String> getResponse(String message) async {
    try {
      final request = ChatCompleteText(
        messages: [
          Messages(role: Role.user,
          content: message)
        
      ], maxToken: 200,
       model: ChatModelFromValue(model: kChatGptTurbo0301Model));

      final response = await _openAI.onChatCompletion(request: request);
      if (response != null) {
        return response.choices[0].message!.content.trim();
      }

      return 'Some thing went wrong';
    } catch (e) {
      print(e);
      return 'Bad response + $e';
    }
  }

  void dispose() {
    _openAI.onChatCompletionSSE;
  }
}
