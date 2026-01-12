class Quote {
  final String text;
  final String author;

  Quote({required this.text, required this.author});

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      // ZenQuotes uses 'q', Quotable uses 'content', DummyJSON uses 'quote', LocalStorage uses 'text'
      text: json['text'] ?? json['q'] ?? json['content'] ?? json['quote'] ?? 'Unknown Quote',
      author: json['author'] ?? json['a'] ?? 'Unknown Author',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'author': author,
    };
  }
}
