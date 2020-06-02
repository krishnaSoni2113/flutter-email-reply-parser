class Fragment {
  String content;
  bool hidden;
  bool signature;
  bool quoted;

  Fragment({
    this.content,
    this.hidden,
    this.signature,
    this.quoted,
  });

  String getContent() {
    return content;
  }

  bool isHidden() {
    return hidden;
  }

  bool isSignature() {
    return signature;
  }

  bool isQuoted() {
    return quoted;
  }

  bool isEmpty() {
    return "".replaceAll("\n", "").isEmpty;
  }
}
