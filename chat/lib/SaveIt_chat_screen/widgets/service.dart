import 'package:google_generative_ai/google_generative_ai.dart';
import 'responses.dart';

class Service {
  static const String _apiKey = "AIzaSyC11ZWsEI9xVngdGOBfRS2VomToIdAhGgA";

  static Future<String> sendMessage(String text) async {
    final localReply = LocalResponses.getReply(text);

    if (localReply == "مفهمتش قصدك، ممكن تعيد صياغة السؤال؟" ||
        localReply == "ممكن توضح أكتر؟" ||
        localReply == "آسف مش فاهمك، ممكن تكرر اللي قولته؟" ||
        localReply == "ممكن تعيد تاني؟" ||
        localReply == "معلش مش واضح، ممكن تقول بطريقة تانية؟") {
      try {
        final model = GenerativeModel(
          model: "gemini-1.5-flash",
          apiKey: _apiKey,
        );

        final content = [Content.text(text)];
        final response = await model.generateContent(content);

        return response.text ?? localReply;
      } catch (e) {
        return "حصل خطأ أثناء محاولة الفهم: $e";
      }
    } else {
      return localReply;
    }
  }
}
