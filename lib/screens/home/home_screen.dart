import 'package:flutter/material.dart';

import '../../models/article.dart';
import '../../services/news_api_service.dart';
import '../../utils/app_colors.dart';
import '../detail/detail_screen.dart';
import 'widgets/headline_banner.dart';
import 'widgets/news_card.dart';

/// 6. Home Page (Dashboard & Feed Berita)
/// Top: Headline News banner (most recent article).
/// Bottom: dynamic list of news fetched from the Spaceflight News API.
/// Tapping a card navigates to the Detail Page carrying the Article.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NewsApiService _newsApiService = NewsApiService();

  late Future<List<Article>> _articlesFuture;

  @override
  void initState() {
    super.initState();
    _articlesFuture = _newsApiService.fetchArticles(limit: 20);
  }

  Future<void> _refresh() async {
    setState(() {
      _articlesFuture = _newsApiService.fetchArticles(limit: 20);
    });
    await _articlesFuture;
  }

  void _openDetail(Article article) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => DetailScreen(article: article)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: _refresh,
          child: FutureBuilder<List<Article>>(
            future: _articlesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }

              if (snapshot.hasError) {
                return _ErrorState(
                  message: '${snapshot.error}',
                  onRetry: _refresh,
                );
              }

              final articles = snapshot.data ?? [];
              if (articles.isEmpty) {
                return _ErrorState(
                  message: 'Belum ada berita untuk ditampilkan.',
                  onRetry: _refresh,
                );
              }

              final headline = articles.first;
              final rest = articles.skip(1).toList();

              return ListView(
                padding: const EdgeInsets.only(top: 8, bottom: 24),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'SpaceNews Core',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.08),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.rocket_launch_outlined,
                              color: AppColors.primary, size: 20),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  HeadlineBanner(
                    article: headline,
                    onTap: () => _openDetail(headline),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Berita Terbaru',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary.withOpacity(0.9),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...rest.map(
                    (article) => NewsCard(
                      article: article,
                      onTap: () => _openDetail(article),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 120),
      children: [
        const Icon(Icons.satellite_alt_outlined,
            size: 56, color: AppColors.textSecondary),
        const SizedBox(height: 16),
        Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 16),
        Center(
          child: OutlinedButton(
            onPressed: onRetry,
            child: const Text('Coba Lagi'),
          ),
        ),
      ],
    );
  }
}
