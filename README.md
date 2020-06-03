# flutter_email_reply_parser

Email reply parser is a package to parse plain text email content.

## Usage
[Example](https://github.com/krishnaSoni2113/flutter-email-reply-parser/blob/master/example/example.dart)

* add the dependency to your [pubspec.yaml](https://github.com/krishnaSoni2113/flutter-email-reply-parser/blob/master/pubspec.yaml)

```yaml
   dependencies:
     flutter:
       sdk: flutter
     flutter_email_parser:
```

## How to use
```dart
import 'package:flutter/material.dart';
import 'package:flutteremailreplyparser/email_reply_parser.dart';

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

// This will return the parsed string.
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

   // Here we are parsing the email data.
    EmailReplyParser _emailReplyParser = EmailReplyParser();
    return _emailReplyParser.parseReply(emailText: email_1);
  }
}
```

