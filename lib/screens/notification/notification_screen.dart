import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/article.dart';
import '../../services/news_api_service.dart';
import '../../utils/app_colors.dart';
import '../detail/detail_screen.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final NewsApiService _newsApiService = NewsApiService();
  late Future<List<Article>> _feedFuture;

  @override
  void initState() {
    super.initState();
    _feedFuture = _loadFeed();
  }

  Future<List<Article>> _loadFeed() async {
    final articles = await _newsApiService.fetchArticles(limit: 20);
    articles.sort((a, b) {
      final aTime = a.publishedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bTime = b.publishedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bTime.compareTo(aTime);
    });
    return articles;
  }

  String _relativeTime(DateTime? time) {
    if (time == null) return '';
    final diff = DateTime.now().toUtc().difference(time.toUtc());
    if (diff.inMinutes < 1) return 'Baru saja';
    if (diff.inMinutes < 60) return '${diff.inMinutes} menit lalu';
    if (diff.inHours < 24) return '${diff.inHours} jam lalu';
    if (diff.inDays < 7) return '${diff.inDays} hari lalu';
    return DateFormat('d MMM yyyy').format(time);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Notifikasi'),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: false,
      ),
      body: FutureBuilder<List<Article>>(
        future: _feedFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          }

          final feed = snapshot.data ?? [];
          if (feed.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada notifikasi.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            itemCount: feed.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final article = feed[index];
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 6),
                leading: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.notifications_active_outlined,
                      color: AppColors.primary, size: 20),
                ),
                title: Text(
                  'Artikel baru dari ${article.newsSite}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    article.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                trailing: Text(
                  _relativeTime(article.publishedAt),
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => DetailScreen(article: article),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
