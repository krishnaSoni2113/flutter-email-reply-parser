import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_email_parser/email_processed.dart';
import 'package:flutter_email_parser/email_reply_parser.dart';
import 'email_format.dart';

main(){

  EmailReplyParser _emailReplyParser;
  setUp((){
    _emailReplyParser = EmailReplyParser();
  });

  tearDown((){
    if (_emailReplyParser != null) {
      _emailReplyParser = null;
    }
  });

  group("Email Reply Parser", () {

    test("Test Read With Null Content", () async {
      EmailProcessed email = _emailReplyParser.read(emailText: null);
      expect("", email.getVisibleText());
    });

    test("Test Read With Empty Content", () async {
      EmailProcessed email = _emailReplyParser.read(emailText: "");
      expect("", email.getVisibleText());
    });

    test("Test Parse Reply", () async {
      expect("Hi,\n\nYou can list the keys for the bucket and call delete for each. "
          + "Or if you\nput the keys (and kept track of them in your test) you can delete them\none at a time "
          + "(without incurring the cost of calling list first.)\n\nSomething like:\n\n        "
          + "String bucket = \"my_bucket\";\n        BucketResponse bucketResponse = riakClient.listBucket(bucket);\n        "
          + "RiakBucketInfo bucketInfo = bucketResponse.getBucketInfo();\n\n        for(String key : bucketInfo.getKeys()) "
          + "{\n            riakClient.delete(bucket, key);\n        }\n\n\nwould do it.\n\nSee also\n\nhttp://wiki.basho.com/REST-API.html#Bucket-operations\n\nwhich says\n\n"
          + "\"At the moment there is no straightforward way to delete an entire\nBucket. There is, however, an open ticket for the feature. To delete all\nthe keys in a bucket, "
          + "you'll need to delete them all individually.\"",
          _emailReplyParser.parseReply(emailText: email_2));
    });

    test("Test Parse Out Sent From IPhone", () async {
      expect("Here is another email",
          _emailReplyParser.parseReply(emailText: email_iphone));
    });

    test("Test Parse Out Sent From BlackBerry", () async {
      expect("Here is another email",
          _emailReplyParser.parseReply(emailText: email_blackberry));
    });

    test("Test Do Not Parse Out Send From In Regular Sentence", () async {
      expect("Here is another email\n\nSent from my desk, is much easier then my mobile phone.",
          _emailReplyParser.parseReply(emailText: email_sent_from_my_not_signature));
    });

    test("Test Parse Out Just Top For Outlook Reply", () async {
      expect("Outlook with a reply",
          _emailReplyParser.parseReply(emailText: email_2_1));
    });

    test("Test Retains Bullets", () async {
      expect("test 2 this should list second\n\nand have spaces\n\nand retain this formatting\n\n\n   - how about bullets\n   - and another",
          _emailReplyParser.parseReply(emailText: email_bullets));
    });

    test("Test Unquoted Reply", () async {
      expect("This is my reply.",
          _emailReplyParser.parseReply(emailText: email_unquoted_reply));
    });

  });
}
