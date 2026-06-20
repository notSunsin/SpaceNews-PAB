class Article {
  final int id;
  final String title;
  final String url;
  final String imageUrl;
  final String newsSite;
  final String summary;
  final DateTime? publishedAt;

  Article({
    required this.id,
    required this.title,
    required this.url,
    required this.imageUrl,
    required this.newsSite,
    required this.summary,
    required this.publishedAt,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse('${json['id']}') ?? 0,
      title: json['title']?.toString() ?? 'Tanpa judul',
      url: json['url']?.toString() ?? '',
      imageUrl: json['image_url']?.toString() ?? '',
      newsSite: json['news_site']?.toString() ?? 'Unknown',
      summary: json['summary']?.toString() ?? '',
      publishedAt: json['published_at'] != null
          ? DateTime.tryParse(json['published_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'url': url,
      'image_url': imageUrl,
      'news_site': newsSite,
      'summary': summary,
      'published_at': publishedAt?.toIso8601String(),
    };
  }
}
