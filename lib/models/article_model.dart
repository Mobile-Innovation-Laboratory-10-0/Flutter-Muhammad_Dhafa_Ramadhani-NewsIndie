class Article {
  final String id;
  final String title;
  final String? description;
  final String? imageUrl;
  final String source;
  final String category;
  final DateTime publishedAt;
  final String? url;

  Article({
    required this.id,
    required this.title,
    this.description,
    this.imageUrl,
    required this.source,
    required this.category,
    required this.publishedAt,
    this.url,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['article_id'] ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? json['content'],
      imageUrl: json['image_url'],
      source: json['source_id'] ?? 'Unknown Source',
      category:
          (json['category'] != null && (json['category'] as List).isNotEmpty)
              ? (json['category'] as List).first.toString()
              : 'general',
      publishedAt: json['pubDate'] != null
          ? DateTime.parse(json['pubDate'])
          : DateTime.now(),
      url: json['link'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'article_id': id,
      'title': title,
      'description': description,
      'image_url': imageUrl,
      'source_id': source,
      'category': [category],
      'pubDate': publishedAt.toIso8601String(),
      'link': url,
    };
  }
}
