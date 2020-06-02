import 'package:flutter_test/flutter_test.dart';
import 'package:flutteremailreplyparser/email_processed.dart';
import 'package:flutteremailreplyparser/email_reply_parser.dart';
import 'email_example_constant.dart';

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

    test("Test Outlook Email1", () async {
      EmailProcessed email = _emailReplyParser.read(emailText: email_new);
      String expectedString = "\n\nHello Mr Shiju,\n\nThanks for your confirmation with Mr Deep!\n\nAs per your discussion with Mr Deep, You will be allocated two  resources for the trial task from tomorrow morning so you can assign the task to them accordingly.\n\nLooking forward to long time engagement with you :)\n\n\nRegards";
      expect(expectedString, email.getVisibleText());
    });

    test("Test Outlook Email2", () async {
      EmailProcessed email = _emailReplyParser.read(emailText: email_new_2);
      String expectedString = "\n\n\nCommenting inline\n\nShiju\nGet Outlook for Android";
      expect(expectedString, email.getVisibleText());
    });

    test("Test Outlook Email3", () async {
      EmailProcessed email = _emailReplyParser.read(emailText: email_new_3);
      String expectedString = "Hi Shay,\n\nThe team is happy with Rish and Rit and would like to proceed further.\nLet’s proceed with an offer and see how It goes 😊\n\nRegards,\nShiju";
      expect(expectedString, email.getVisibleText());
    });

    test("Test Confidential Email", () async {
      EmailProcessed email = _emailReplyParser.read(emailText: email_new_4);
      expect("FYI – Apple will be starting with us 22/06/2020, not sure if you guys are in contact or if this was shared with you yet =)\n\nThanks\n\nShay\n\nshay markarian\nI.AM+ | People | US", email.getVisibleText());
    });

  });
}
