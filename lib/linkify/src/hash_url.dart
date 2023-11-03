import '../linkify.dart';

class HashUrlLinkifier extends Linkifier {
  const HashUrlLinkifier();
  static final _resourceRegex = RegExp(r'#(https?://[^\s#]+)#([^\s#]+)#');

  @override
  List<LinkifyElement> parse(
      List<LinkifyElement> elements, LinkifyOptions options) {
    final list = <LinkifyElement>[];

    for (var element in elements) {
      if (element is TextElement) {
        final matches = _resourceRegex.allMatches(element.text);

        if (matches.isEmpty) {
          list.add(element);
        } else {
          var currentIndex = 0;
          for (final match in matches) {
            final prefix = element.text.substring(currentIndex, match.start);

            if (prefix.isNotEmpty) {
              list.add(TextElement(prefix));
            }
            final url = match.group(1)!;
            final text = match.group(2)!;

            list.add(HashUrlElement(url, text));
            currentIndex = match.end;
          }
          final suffix = element.text.substring(currentIndex);
          if (suffix.isNotEmpty) {
            list.add(TextElement(suffix));
          }
        }
      } else {
        list.add(element);
      }
    }

    return list;
  }
}

/// Represents an element containing a hash link
class HashUrlElement extends LinkableElement {
  HashUrlElement(String url, String text) : super(text, url);

  @override
  String toString() {
    return "HashUrlElement: '$url' ($text)";
  }

  @override
  bool operator ==(other) => equals(other);

  @override
  int get hashCode => Object.hash(text, originText, url);

  @override
  bool equals(other) => other is HashUrlElement && super.equals(other);
}
