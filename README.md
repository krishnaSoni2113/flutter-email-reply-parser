# flutteremailreplyparser

Email reply parser is a package to parse plain text email content.

## Usage
[Example](https://github.com/krishnaSoni2113/flutter-email-reply-parser/blob/master/example/example.dart)

* add the dependency to your [pubspec.yaml](https://github.com/krishnaSoni2113/flutter-email-reply-parser/blob/master/pubspec.yaml)

```yaml
   dependencies:
     flutter:
       sdk: flutter
     flutteremailreplyparser:
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

// This wll return the parsed string
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

## License
MIT License

Copyright (c) 2020 Krishna Soni

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

