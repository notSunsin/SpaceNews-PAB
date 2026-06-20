import 'package:flutter/material.dart';

import '../../models/favorite_article.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';
import '../../services/news_api_service.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_snackbar.dart';
import '../detail/detail_screen.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final AuthService _authService = AuthService();
  final NewsApiService _newsApiService = NewsApiService();

  int? _openingArticleId;

  Future<void> _openFavorite(FavoriteArticle favorite) async {
    setState(() => _openingArticleId = favorite.articleId);
    try {
      final article = await _newsApiService.fetchArticleById(favorite.articleId);
      if (!mounted) return;
      await Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => DetailScreen(article: article)),
      );
    } catch (e) {
      if (!mounted) return;
      AppSnackbar.showError(context, 'Gagal membuka artikel: $e');
    } finally {
      if (mounted) setState(() => _openingArticleId = null);
    }
  }

  Future<void> _removeFavorite(FavoriteArticle favorite) async {
    try {
      await _firestoreService.removeFavorite(favorite.docId);
    } catch (e) {
      if (!mounted) return;
      AppSnackbar.showError(context, 'Gagal menghapus favorit: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final uid = _authService.currentUser?.uid;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Favorite'),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: false,
      ),
      body: uid == null
          ? const Center(child: Text('Silakan login terlebih dahulu.'))
          : StreamBuilder<List<FavoriteArticle>>(
              stream: _firestoreService.favoritesStream(uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Terjadi kesalahan: ${snapshot.error}'),
                  );
                }

                final favorites = snapshot.data ?? [];
                if (favorites.isEmpty) {
                  return ListView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 120),
                    children: const [
                      Icon(Icons.favorite_border,
                          size: 56, color: AppColors.textSecondary),
                      SizedBox(height: 16),
                      Text(
                        'Belum ada artikel favorit.\nKetuk ikon hati pada '
                        'sebuah berita untuk menyimpannya di sini.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ],
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  itemCount: favorites.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final favorite = favorites[index];
                    final isOpening = _openingArticleId == favorite.articleId;

                    return Container(
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 6),
                        leading: const CircleAvatar(
                          backgroundColor: AppColors.accentSoft,
                          child: Icon(Icons.favorite,
                              color: AppColors.favoriteRed, size: 18),
                        ),
                        title: Text(
                          favorite.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        trailing: isOpening
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.primary,
                                ),
                              )
                            : IconButton(
                                icon: const Icon(Icons.delete_outline,
                                    color: AppColors.textSecondary),
                                onPressed: () => _removeFavorite(favorite),
                              ),
                        onTap: isOpening ? null : () => _openFavorite(favorite),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
