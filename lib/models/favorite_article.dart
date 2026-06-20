class FavoriteArticle {
  final String docId; 
  final int articleId;
  final String title;
  final String userId;
  final DateTime? savedAt;

  FavoriteArticle({
    required this.docId,
    required this.articleId,
    required this.title,
    required this.userId,
    required this.savedAt,
  });

  factory FavoriteArticle.fromMap(String docId, Map<String, dynamic> map) {
    return FavoriteArticle(
      docId: docId,
      articleId: map['articleId'] is int
          ? map['articleId'] as int
          : int.tryParse('${map['articleId']}') ?? 0,
      title: map['title']?.toString() ?? '',
      userId: map['userId']?.toString() ?? '',
      savedAt: map['savedAt'] != null
          ? DateTime.tryParse(map['savedAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'articleId': articleId,
      'title': title,
      'userId': userId,
      'savedAt': DateTime.now().toIso8601String(),
    };
  }
}
