class Link{
  final String url;
  Link(this.url);

  @override
  String toString() => 'Link($url)';
}

class Text{
  final String text;
  Text(this.text);

  @override
  String toString() => 'Text($text)';
}

extension LinkParsing on String{
  List<Object> parseLinks(){
    RegExp exp = RegExp(r'(https?://\S+|\S+\.\S+)');

    List<Object> result = [];
    int currIdx = 0;

    for(final match in exp.allMatches(this)){
      String rawUrl = match.group(0)!;

      if(match.start > currIdx) result.add(Text(this.substring(currIdx, match.start)));

      String cleanUrl = rawUrl.replaceAll(RegExp(r'[.,!?;:)\]]+$'), '');

      result.add(Link(cleanUrl));

      int remStart = match.start + cleanUrl.length;
      if(remStart < match.end) result.add(Text(this.substring(remStart, match.end)));

      currIdx = match.end;
    }

    if(currIdx < this.length) result.add(this.substring(currIdx));

    return result;
  }
}

void main() {
  String str = 'Hello, google.com, yay';
  print(str.parseLinks());
}
