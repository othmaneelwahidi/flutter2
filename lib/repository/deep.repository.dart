import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/deep.model.dart';

class DeepBotRepository {
  Future<Message> askLargeLangueModelDeep(String query) async {
    var url = "https://api.deepseek.com/chat/completions";

    Map<String, String> headers = {
      "Content-Type": " application/json",

      //"Authorization": "Bearer <DeepSeek API Key>"
    };
    /*variable messages ajoutés avec comme contenu :question pourque le LLM comprend les messages*/
    //messages.add({"role": "user", "content": question});
    var prompt = {
      "model": "deepseek-chat",
      "messages": [
        {"role": "user", "content": query}
      ],
      "temperature": 0
    };
    try {
      http.Response response = await http.post(Uri.parse(url),
          headers: headers, body: json.encode(prompt));
      if (response.statusCode == 200) {
        Map<String, dynamic> result = jsonDecode(response.body);
        Message message = Message(
            message: result['choices'][0]['message']['content'],
            type: "assistant");
        return message;
      } else {
        return throw ("Error ${response.statusCode}");
      }
    } catch (err) {
      return throw ("Error ${err.toString()}");
    }
  }
}
