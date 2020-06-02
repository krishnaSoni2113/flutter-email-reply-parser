import 'email_processed.dart';
import 'email_parser.dart';

class EmailReplyParser {

  static final EmailReplyParser _instance = EmailReplyParser._internal();
  EmailReplyParser._internal();
  EmailParser _parser;
  bool _initialized = false;

  factory EmailReplyParser() {
    if (!_instance._initialized) {
      _instance._parser = EmailParser();
      _instance._initialized = true;
    }
    return _instance;
  }

  EmailProcessed read({String emailText}) {
    if (emailText == null)
      emailText = "";
    return _parser.parse(emailText: emailText);
  }

  String parseReply({String emailText}) {
    return read(emailText: emailText).getVisibleText();
  }
}
