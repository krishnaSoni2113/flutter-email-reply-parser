import 'email_processed.dart';
import 'fragment.dart';
import 'fragment_dto.dart';

class EmailParser {
  static final RegExp sigRegExp = RegExp(
      '((^Sent from my (\\s*\\w+){1,3}\$)|(^-\\w|^\\s?__|^\\s?--|^\u2013|^\u2014))',
      dotAll: true,);
  static final RegExp quoteRegExp = RegExp('(^>+)', dotAll: true,);
  static List<RegExp> _compiledQuoteHeaderPatterns = [];
  static const  wordList = <String>[
    "confidential",
    "transmitted",
    "disclosing",
    "disclosed",
    "distributing",
    "prohibited",
    "disclaimer",
    "disclaimers"
        "solely",
    "defamatory",
    "infringe",
    "infringement",
    "copyright"
        "legal"
        "contrary",
    "liability",
    "liable",
    "damages",
    "gdpr",
    "regulation",
    "entity",
    "privileged",
    "confidentiality",
    "notices",
    "consequences",
    "copying",
    "reliance",
    "compliant",
    "protection",
    "privacy",
    "policy",
    "viruses",
    "transmission",
    "guaranteed",
    "intercepted",
    "corrupted",
    "omissions",
    "forbidden"
  ];

  List<String> _quoteHeadersRegex = [];
  List<FragmentDTO> _fragments = [];
  int _maxParagraphLines;
  int _maxNumCharsEachLine;

  ///Initialize EmailParser.
  EmailParser() {
    _compiledQuoteHeaderPatterns = [];
    _quoteHeadersRegex.add("^(On\\s(.{1,500})wrote:)");
    _quoteHeadersRegex.add(
        "From:[^\\n]+\\n?([^\\n]+\\n?){0,2}To:[^\\n]+\\n?([^\\n]+\\n?){0,2}Subject:[^\\n]+");
    _quoteHeadersRegex.add(
        "To:[^\\n]+\\n?([^\\n]+\\n?){0,2}From:[^\\n]+\\n?([^\\n]+\\n?){0,2}Subject:[^\\n]+");
    _maxParagraphLines = 6;
    _maxNumCharsEachLine = 200;
  }

  ///  Splits the given email text into a list of {@link Fragment} and returns the {@link Email} object.
  ///@param emailText
  ///@return

  EmailProcessed parse({String emailText}) {
    _fragments = [];
    _fragments.clear();

    _compileQuoteHeaderRegexes();

    // Normalize line endings
    emailText = emailText.replaceAll("\r\n", "\n");

    FragmentDTO fragment;

    // Split body to multiple lines.
    List<String> lines = emailText.toString().split("\n");

    ///Reverse the array.
    ///Reversing the array makes us to parse from the bottom to the top.
    ///This way we can check for quote headers lines above quoted blocks
    lines = lines.reversed.toList();

    ///Paragraph for multi - line quote headers.
    ///Some clients break up the quote headers into multiple lines.

    List<String> paragraph = [];

    // Scans the given email line by line and figures out which fragment it belong to.
    for (String line in lines) {
      // Strip empty spaces at the end of the string
      line = line.trimRight();

      ///If the fragment is not null and we hit the empty line,
      ///we get the last line from the fragment and check if the last line is either
      ///signature and quote headers.
      ///If it is, add fragment to the list of fragments and delete the current fragment.
      ///Also, delete the paragraph.

      if (fragment != null && line.isEmpty) {
        String last = fragment.lines.last;

        if (_isSignature(last)) {
          fragment.isSignature = true;
          _addFragment(fragment);

          fragment = null;
        }
        else if (_isQuoteHeader(paragraph)) {
          fragment.isQuoted = true;
          _addFragment(fragment);

          fragment = null;
        }
        paragraph.clear();
      }

      // Check if the line is a quoted line.
      bool isQuoted = _isQuote(line);

      ///If fragment is empty or if the line does not matches the current fragment,
      ///create new fragment.

      if (fragment == null || !_isFragmentLine(fragment, line, isQuoted)) {
        if (fragment != null) {
          _addFragment(fragment);
        }

        fragment = new FragmentDTO();
        fragment.isQuoted = isQuoted;
        fragment.lines = [];
      }

      /// Add line to fragment and paragraph
      /// Do not add line if is Confidential or Disclaimer.
      if (!_getDisclaimerScore(line))
        fragment.lines.add(line);

      if (line.isNotEmpty) {
        paragraph.add(line);
      }
    }

    if (fragment != null){
      _addFragment(fragment);
    }

    return createEmail(_fragments);
  }

  ///Returns existing quote headers regular expressions.
  ///@return
  List<String> getQuoteHeadersRegex() {
    return _quoteHeadersRegex;
  }

  ///Sets quote headers regular expressions.
  ///@param newRegex
  void setQuoteHeadersRegex(List<String> newRegex) {
    _quoteHeadersRegex = newRegex;
  }

  ///Gets max number of lines allowed for each paragraph when checking quote headers.
  ///@return
  int getMaxParagraphLines() {
    return _maxParagraphLines;
  }

  ///Sets max number of lines allowed for each paragraph when checking quote headers.
  ///@param maxParagraphLines
  void setMaxParagraphLines(int maxParagraphLines) {
    _maxParagraphLines = maxParagraphLines;
  }

  ///Gets max number of characters allowed for each line when checking quote headers.
  ///@return
  int getMaxNumCharsEachLine() {
    return _maxNumCharsEachLine;
  }

  ///Sets max number of characters allowed for each line when checking quote headers.
  ///@param maxNumCharsEachLine
  void setMaxNumCharsEachLine(int maxNumCharsEachLine) {
    _maxNumCharsEachLine = maxNumCharsEachLine;
  }

  ///Creates {@link Email} object from List of fragments.
  ///@param fragmentDTOs
  ///@return
  EmailProcessed createEmail(List<FragmentDTO> fragmentDTOs) {
    List<Fragment> fs = [];
    fragmentDTOs = fragmentDTOs.reversed.toList();

    for (FragmentDTO f in fragmentDTOs) {
      f.lines = f.lines.reversed.toList();
      String content = f.lines.join('\n').toString();
      Fragment fr = new Fragment(
        content: content,
        hidden: f.isHidden,
        signature: f.isSignature,
        quoted: f.isQuoted,
      );
      fs.add(fr);
    }

    return EmailProcessed(fragments: fs);
  }

  ///Compile all the quote headers regular expressions before the parsing.
  void _compileQuoteHeaderRegexes() {
    for (String regex in _quoteHeadersRegex) {
      _compiledQuoteHeaderPatterns.add(RegExp(
        regex,
        multiLine: true,
        dotAll: true,
      ));
    }
  }

  ///Check if the line is a signature.
  ///@param line
  ///@return
  bool _isSignature(String line) {
    return sigRegExp.hasMatch(line);
  }

  ///Checks if the line is quoted line.
  ///@param line
  ///@return
  bool _isQuote(String line) {
    return quoteRegExp.hasMatch(line);
  }

  ///Checks if lines in the fragment are empty.
  ///@param fragment
  ///@return
  bool _isEmpty(FragmentDTO fragment) {
    return fragment.lines.join("").isEmpty;
  }

  ///If the line matches the current fragment, return true.
  ///Note that a common reply header also counts as part of the quoted Fragment,
  ///even though it doesn't start with `>`.
  ///
  ///@param fragment
  ///@param line
  ///@param isQuoted
  ///@return
  bool _isFragmentLine(FragmentDTO fragment, String line, bool isQuoted) {
    return fragment.isQuoted == isQuoted ||
        (fragment.isQuoted && (_isQuoteHeader([line]) || line.isEmpty));
  }

  ///Add fragment to fragments list.
  ///@param fragment
  void _addFragment(FragmentDTO fragment) {
    if (fragment.isQuoted || fragment.isSignature || _isEmpty(fragment))
      fragment.isHidden = true;

    _fragments.add(fragment);
  }

  ///Checks if the given multiple-lines paragraph has one of the quote headers.
  ///Returns false if it doesn't contain any of the quote headers,
  ///if paragraph lines are greater than maxParagraphLines, or line has more than maxNumberCharsEachLine characters.
  ///
  ///@param paragraph
  ///@return
  bool _isQuoteHeader(List<String> paragraph) {
    if (paragraph.length > _maxParagraphLines) return false;
    for (String line in paragraph) {
      if (line.length > _maxNumCharsEachLine) return false;
    }

    paragraph = paragraph.reversed.toList();
    String content = paragraph.join('\n').toString();

    for (RegExp regExp in _compiledQuoteHeaderPatterns) {
      if (regExp.hasMatch(content)) {
        return true;
      }
    }

    return false;
  }

  bool _getDisclaimerScore(String stringToTest) {
    final lowerCaseStringToTest = stringToTest.toLowerCase();
    int findLength = 0;
    findLength = wordList
        .where((word)
    => lowerCaseStringToTest.contains(word)).length;
    return findLength > 0;
  }
}
