import 'fragment.dart';

class EmailProcessed {
  final List<Fragment> fragments;

  EmailProcessed({
    this.fragments,
  });

  List<Fragment> getFragments() {
    return fragments;
  }

  String getVisibleText() {
    List<String> visibleFragments = [];
    for (Fragment fragment in fragments) {
      if (!fragment.isHidden())
        visibleFragments.add(fragment.getContent());
    }
    String visibleString = visibleFragments.join("\n").trimRight();
    return visibleString;
  }

  String getHiddenText() {
    List<String> hiddenFragments = [];
    for (Fragment fragment in fragments) {
      if (fragment.isHidden())
        hiddenFragments.add(fragment.getContent());
    }

    String hiddenString = hiddenFragments.join("\n").trimRight();
    return hiddenString;
  }
}
