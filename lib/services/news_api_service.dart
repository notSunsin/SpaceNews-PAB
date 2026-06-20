import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/article.dart';

/// Talks to the public Spaceflight News API v4.
/// Base endpoint required by spec:
/// https://api.spaceflightnewsapi.net/v4/articles/?limit=20
class NewsApiService {
  static const String _baseUrl = 'https://api.spaceflightnewsapi.net/v4';

  /// Fetches the latest 20 articles for the Home page feed
  /// (headline banner + news list).
  Future<List<Article>> fetchArticles({int limit = 20}) async {
    final uri = Uri.parse('$_baseUrl/articles/?limit=$limit');
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception(
        'Gagal memuat berita (kode ${response.statusCode}). '
        'Periksa koneksi internet Anda.',
      );
    }

    final Map<String, dynamic> body = json.decode(response.body);
    final List<dynamic> results = body['results'] as List<dynamic>? ?? [];
    return results
        .map((e) => Article.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Fetches a single article by id — used when opening a saved
  /// Favorite (which only stores id + title) so the Detail page can
  /// display the full article body.
  Future<Article> fetchArticleById(int id) async {
    final uri = Uri.parse('$_baseUrl/articles/$id/');
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Artikel tidak ditemukan (kode ${response.statusCode}).');
    }

    final Map<String, dynamic> body = json.decode(response.body);
    return Article.fromJson(body);
  }
}
