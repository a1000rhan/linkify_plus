import '../linkify.dart';

class HyperLinkifier extends Linkifier {
  const HyperLinkifier();

  // Define a regular expression to match patterns like "[click here](https://urltolinkto.com)"
  static final _clickHereRegex =
      RegExp(r'\[(.+?)\]\(([^ \n\r\)]+)\)', multiLine: true);
  @override
  List<LinkifyElement> parse(
      List<LinkifyElement> elements, LinkifyOptions options) {
    final list = <LinkifyElement>[];

    for (var element in elements) {
      if (element is TextElement) {
        final matches = _clickHereRegex.allMatches(element.text);

        if (matches.isEmpty) {
          list.add(element);
        } else {
          var currentIndex = 0;
          for (final match in matches) {
            // Get the prefix (text before the matched pattern)
            final prefix = element.text.substring(currentIndex, match.start);
            if (prefix.isNotEmpty) {
              list.add(TextElement(prefix));
            }

            // Get the link text and URL from the match
            final linkText = match.group(1)!;
            final url = match.group(2)!;

            // Add a new LinkableElement (link) to the list
            list.add(LinkableElement(linkText, url));

            // Update the current index
            currentIndex = match.end;
          }
          // Add any remaining suffix (text after the last match)
          final suffix = element.text.substring(currentIndex);
          if (suffix.isNotEmpty) {
            list.add(TextElement(suffix));
          }
        }
      } else {
        // If the element is not a TextElement, just add it to the list
        list.add(element);
      }
    }

    return list;
  }
}
