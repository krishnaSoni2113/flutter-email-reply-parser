import 'package:flutter/material.dart';
import 'package:flutter_email_reply_parser/email_reply_parser.dart';

class Example extends StatefulWidget {
  @override
  _ExampleState createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(_getTheEmailContent()),
    );
  }

  String _getTheEmailContent() {
    const email_1 = """
Hi folks

What is the best way to clear a Riak bucket of all key, values after
running a test?
I am currently using the Java HTTP API.

-Krishna Soni


_______________________________________________
test-users mailing list
test-users@gmail.com
https://github.com/krishnaSoni2113/flutter-email-reply-parser
""";

    EmailReplyParser _emailReplyParser = EmailReplyParser();
    return _emailReplyParser.parseReply(emailText: email_1);
  }
}
