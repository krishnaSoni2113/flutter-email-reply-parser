import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_email_parser/email_parser.dart';
import 'package:flutter_email_parser/email_processed.dart';
import 'package:flutter_email_parser/fragment.dart';

import 'email_format.dart';

main() {
  setUp(() {});

  tearDown(() {});

  group("Email Parser", () {

    test("Test Reads Simple Body", () async {
      EmailProcessed email = new EmailParser().parse(emailText: email_1);
      List<Fragment> fragments = email.getFragments();

      expect(3, fragments.length);
      expect(
          "Hi folks\n\nWhat is the best way to clear a Riak bucket of all key, values after\nrunning a test?\nI am currently using the Java HTTP API.\n",
          fragments.first.getContent());

      for (Fragment f in fragments) {
        expect(f.isQuoted(), false);
      }

      expect(fragments.first.isSignature(), false);
      expect(fragments[1].isSignature(), true);
      expect(fragments[2].isSignature(), true);

      expect(fragments.first.isHidden(), false);
      expect(fragments[1].isHidden(), true);
      expect(fragments[2].isHidden(), true);

      expect("-Abhishek Kona\n\n", fragments[1].getContent());
    });

    test("Test Reads Top Post", () async {
      EmailProcessed email = new EmailParser().parse(emailText: email_3);
      List<Fragment> fragments = email.getFragments();

      expect(5, fragments.length);
      expect(fragments.first.isQuoted(), false);
      expect(fragments[1].isQuoted(), false);
      expect(fragments[2].isQuoted(), true);
      expect(fragments[3].isQuoted(), false);
      expect(fragments[4].isQuoted(), false);

      expect(fragments.first.isSignature(), false);
      expect(fragments[1].isSignature(), true);
      expect(fragments[2].isSignature(), false);
      expect(fragments[3].isSignature(), false);
      expect(fragments[4].isSignature(), true);

      expect(fragments.first.isHidden(), false);
      expect(fragments[1].isHidden(), true);
      expect(fragments[2].isHidden(), true);
      expect(fragments[3].isHidden(), true);
      expect(fragments[4].isHidden(), true);

      RegExp regExp = RegExp("Oh thanks.\n\nHavin");
      expect(regExp.hasMatch(fragments.first.getContent()), true);

      regExp = RegExp("^-A");
      expect(regExp.hasMatch(fragments[1].getContent()), true);

      regExp = RegExp("On");
      expect(regExp.hasMatch(fragments[2].getContent()), true);

      regExp = RegExp("^_");
      expect(regExp.hasMatch(fragments[4].getContent()), true);
    });

    test("Test Reads Bottom Post", () async {
      EmailProcessed email = new EmailParser().parse(emailText: email_2);
      List<Fragment> fragments = email.getFragments();

      expect(6, fragments.length);
      expect("Hi,", fragments.first.getContent());

      RegExp regExp = RegExp("You can list");
      expect(regExp.hasMatch(fragments[2].getContent()), true);

      regExp = RegExp("On");
      expect(regExp.hasMatch(fragments[1].getContent()), true);

      regExp = RegExp(">");
      expect(regExp.hasMatch(fragments[3].getContent()), true);

      regExp = RegExp("^_");
      expect(regExp.hasMatch(fragments[5].getContent()), true);

    });

    test("Test Recognizes Date String Above Quote", () async {
      EmailProcessed email = new EmailParser().parse(emailText: email_4);
      List<Fragment> fragments = email.getFragments();

      RegExp regExp = RegExp("Awesome");
      expect(regExp.hasMatch(fragments.first.getContent()), true);

      regExp = RegExp("On");
      expect(regExp.hasMatch(fragments[1].getContent()), true);

      regExp = RegExp("Loader");
      expect(regExp.hasMatch(fragments[1].getContent()), true);
    });

    test("Test Does Not Modify Input String", () async {
      String input = "The Quick Brown Fox Jumps Over The Lazy Dog";
      EmailProcessed email = new EmailParser().parse(emailText: input);
      List<Fragment> fragments = email.getFragments();
      expect("The Quick Brown Fox Jumps Over The Lazy Dog", fragments.first.getContent());
    });

    test("Test Complex Body With Only One Fragment", () async {
      EmailProcessed email = new EmailParser().parse(emailText: email_5);
      List<Fragment> fragments = email.getFragments();

      expect(1, fragments.length);
    });

    test("Test Deals With Multiline Reply Headers", () async {
      EmailProcessed email = new EmailParser().parse(emailText: email_6);
      List<Fragment> fragments = email.getFragments();

      RegExp regExp = RegExp("I get");
      expect(regExp.hasMatch(fragments.first.getContent()), true);

      regExp = RegExp("On");
      expect(regExp.hasMatch(fragments[1].getContent()), true);

      regExp = RegExp("Was this");
      expect(regExp.hasMatch(fragments[2].getContent()), true);
    });

    test("Test Get Visible Text Returns Only Visible Fragments", () async {
      EmailProcessed email = new EmailParser().parse(emailText: email_2_1);
      List<Fragment> fragments = email.getFragments();

      List<String> visibleFragments = [];
      for (Fragment fragment in fragments) {
        if (!fragment.isHidden())
          visibleFragments.add(fragment.getContent());
      }

      expect(visibleFragments.join("\n").trimRight(), email.getVisibleText());
    });

    test("Test Reads Email With Correct Signature", () async {
      EmailProcessed email = new EmailParser().parse(emailText: correct_sig);
      List<Fragment> fragments = email.getFragments();

      expect(2, fragments.length);

      expect(fragments.first.isQuoted(), false);
      expect(fragments[1].isQuoted(), false);

      expect(fragments.first.isSignature(), false);
      expect(fragments[1].isSignature(), true);

      expect(fragments.first.isHidden(), false);
      expect(fragments[1].isHidden(), true);

      RegExp regExp = RegExp("^--\nrick");
      expect(regExp.hasMatch(fragments[1].getContent()), true);
    });

    test("Test One Is Not On", () async {
      EmailProcessed email = new EmailParser().parse(emailText: email_one_is_not_on);
      List<Fragment> fragments = email.getFragments();

      RegExp regExp = RegExp("One outstanding question");
      expect(regExp.hasMatch(fragments.first.getContent()), true);

      regExp = RegExp("On Oct 1, 2012");
      expect(regExp.hasMatch(fragments[1].getContent()), true);
    });

    test("Test Custom Quote Header", () async {

      EmailParser parser = new EmailParser();
      parser.getQuoteHeadersRegex().add("^(\\d{4}(.+)rta:)");

      EmailProcessed email = parser.parse(emailText: email_custom_quote_header);
      expect("Thank you!", email.getVisibleText());
    });

    test("Test Custom Quote Header2", () async {

      EmailParser parser = new EmailParser();
      parser.getQuoteHeadersRegex().add("^(From\\: .+ .+test\\@webdomain\\.com.+)");

      EmailProcessed email = parser.parse(emailText: email_customer_quote_header_2);
      expect("Thank you very much.", email.getVisibleText());

    });

    test("Test Abnormal Quote Header1", () async {
      EmailParser parser = new EmailParser();

      EmailProcessed email = parser.parse(emailText: email_abnormal_quote_header_1);
      expect("Thank you kindly!", email.getVisibleText());

    });

    test("Test Abnormal Quote Header2", () async {
      EmailParser parser = new EmailParser();

      EmailProcessed email = parser.parse(emailText: email_abnormal_quote_header_2);
      String expectedString = "Thank you very much for your email!\n" + "\n" + "em\u2014dash coming through..";
      expect(expectedString, email.getVisibleText());
    });

    test("Test Abnormal Quote Header3", () async {
      EmailParser parser = new EmailParser();

      EmailProcessed email = parser.parse(emailText: email_abnormal_quote_header_3);
      String expectedString = "Hi Daniel,\n" + "\n" + "\n" + "Thank you very much for your email.\n" + "\n" + "Sincerely,\n" + "Homer Simpson\n" + "Nuclear Safety Inspector\n" + "\n" + "nuclear power plant, sector 7-G";
      expect(expectedString, email.getVisibleText());
    });

    test("Test Abnormal Quote Header4", () async {
      EmailParser parser = new EmailParser();

      EmailProcessed email = parser.parse(emailText: email_abnormal_quote_header_4);
      String expectedString = "From: Homer Simpson\n" + "To: Support\n" + "\n" + "En\u2013dash coming through~\n" + "\n" + "Thank you very much for your email!";
      expect(expectedString, email.getVisibleText());
    });

    test("Test Abnormal Quote Header5", () async {
      EmailParser parser = new EmailParser();

      EmailProcessed email = parser.parse(emailText: email_abnormal_quote_header_5);
      String expectedString = "Hello from outlook.com!";
      expect(expectedString, email.getVisibleText());
    });

    test("Test Abnormal Quote Header Long", () async {
      EmailParser parser = new EmailParser();

      EmailProcessed email = parser.parse(emailText: email_abnormal_quote_header_long);
      String expectedString = "*Caution* This is a really long email.";
      expect(expectedString, email.getVisibleText());
    });

    test("Test EmDash Signature", () async {
      EmailParser parser = new EmailParser();

      EmailProcessed email = parser.parse(emailText: email_em_dash);
      String expectedString = "Thank you.";
      expect(expectedString, email.getVisibleText());
    });

    test("Test EnDash Signature", () async {
      EmailParser parser = new EmailParser();

      EmailProcessed email = parser.parse(emailText: email_em_dash);
      String expectedString = "Thank you.";
      expect(expectedString, email.getVisibleText());
    });

    test("Test Dashes Between Words", () async {
      EmailParser parser = new EmailParser();

      EmailProcessed email = parser.parse(emailText: email_dashes_between_words);
      String expectedString = "The text below is not a signature!\n" + "\n" + "Parsing works correctly with mulit--dash between the words.\n" + "\n" + "This__also!";
      expect(expectedString, email.getVisibleText());
    });


  });
}
