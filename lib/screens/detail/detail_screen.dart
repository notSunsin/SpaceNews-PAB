import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/article.dart';
import '../../models/favorite_article.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_snackbar.dart';

class DetailScreen extends StatefulWidget {
  final Article article;

  const DetailScreen({super.key, required this.article});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final AuthService _authService = AuthService();

  bool _isFavorite = false;
  bool _isCheckingFavorite = true;
  bool _isTogglingFavorite = false;
  String? _favoriteDocId;

  @override
  void initState() {
    super.initState();
    _loadFavoriteState();
  }

  Future<void> _loadFavoriteState() async {
    final uid = _authService.currentUser?.uid;
    if (uid == null) {
      setState(() => _isCheckingFavorite = false);
      return;
    }
    final docId = await _firestoreService.findFavoriteDocId(
      userId: uid,
      articleId: widget.article.id,
    );
    if (!mounted) return;
    setState(() {
      _favoriteDocId = docId;
      _isFavorite = docId != null;
      _isCheckingFavorite = false;
    });
  }

  Future<void> _toggleFavorite() async {
    final uid = _authService.currentUser?.uid;
    if (uid == null) return;

    setState(() => _isTogglingFavorite = true);
    try {
      if (_isFavorite && _favoriteDocId != null) {
        await _firestoreService.removeFavorite(_favoriteDocId!);
        if (!mounted) return;
        setState(() {
          _isFavorite = false;
          _favoriteDocId = null;
        });
      } else {
        await _firestoreService.addFavorite(
          FavoriteArticle(
            docId: '',
            articleId: widget.article.id,
            title: widget.article.title,
            userId: uid,
            savedAt: DateTime.now(),
          ),
        );
        final docId = await _firestoreService.findFavoriteDocId(
          userId: uid,
          articleId: widget.article.id,
        );
        if (!mounted) return;
        setState(() {
          _isFavorite = true;
          _favoriteDocId = docId;
        });
      }
    } catch (e) {
      if (!mounted) return;
      AppSnackbar.showError(context, 'Gagal memperbarui favorit: $e');
    } finally {
      if (mounted) setState(() => _isTogglingFavorite = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final article = widget.article;
    final publishedLabel = article.publishedAt != null
        ? DateFormat('d MMMM yyyy, HH:mm').format(article.publishedAt!)
        : '';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 260,
            backgroundColor: AppColors.primary,
            iconTheme: const IconThemeData(color: Colors.white),
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: CircleAvatar(
                backgroundColor: Colors.black.withOpacity(0.35),
                child: const BackButton(color: Colors.white),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: CircleAvatar(
                  backgroundColor: Colors.black.withOpacity(0.35),
                  child: IconButton(
                    onPressed: (_isCheckingFavorite ||
                            _isTogglingFavorite ||
                            _authService.currentUser == null)
                        ? null
                        : _toggleFavorite,
                    icon: _isTogglingFavorite
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Icon(
                            _isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: _isFavorite
                                ? AppColors.favoriteRed
                                : Colors.white,
                          ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: CachedNetworkImage(
                imageUrl: article.imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    Container(color: AppColors.primary.withOpacity(0.2)),
                errorWidget: (context, url, error) => Container(
                  color: AppColors.primary,
                  child: const Icon(Icons.public,
                      color: Colors.white54, size: 56),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          article.newsSite,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      if (publishedLabel.isNotEmpty)
                        Expanded(
                          child: Text(
                            publishedLabel,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const Divider(height: 36),
                  Text(
                    article.summary.isEmpty
                        ? 'Ringkasan tidak tersedia untuk artikel ini.'
                        : article.summary,
                    style: const TextStyle(
                      fontSize: 15,
                      color: AppColors.textPrimary,
                      height: 1.65,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
