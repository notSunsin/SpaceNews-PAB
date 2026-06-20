import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/app_user.dart';
import '../models/favorite_article.dart';

/// Wraps all Cloud Firestore reads/writes used across the app:
/// - "users" collection: profile data shown on the Profile page.
/// - "favorites" collection: saved article id + title, scoped per
///   user via a `userId` field, as required by the spec.
class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _usersRef =>
      _db.collection('users');

  CollectionReference<Map<String, dynamic>> get _favoritesRef =>
      _db.collection('favorites');

  // ---------------- USERS ----------------

  /// Creates the user profile document right after registration.
  Future<void> createUserProfile(AppUser user) async {
    await _usersRef.doc(user.uid).set(user.toMap());
  }

  /// Streams the current user's profile in real time, used on the
  /// Profile page so changes reflect immediately.
  Stream<AppUser?> userProfileStream(String uid) {
    return _usersRef.doc(uid).snapshots().map((snap) {
      if (!snap.exists || snap.data() == null) return null;
      return AppUser.fromMap(snap.id, snap.data()!);
    });
  }

  Future<AppUser?> getUserProfile(String uid) async {
    final snap = await _usersRef.doc(uid).get();
    if (!snap.exists || snap.data() == null) return null;
    return AppUser.fromMap(snap.id, snap.data()!);
  }

  /// Updates the editable parts of a user's profile (full name and
  /// Instagram handle). Email is intentionally excluded — it's tied
  /// to the Firebase Auth account and edited there, not here.
  Future<void> updateUserProfile({
    required String uid,
    required String fullName,
    required String instagram,
  }) async {
    await _usersRef.doc(uid).update({
      'fullName': fullName,
      'instagram': instagram,
    });
  }

  // ---------------- FAVORITES ----------------

  /// Real-time stream of the logged-in user's favorite articles,
  /// newest first.
  Stream<List<FavoriteArticle>> favoritesStream(String userId) {
    return _favoritesRef
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snap) {
      final items = snap.docs
          .map((d) => FavoriteArticle.fromMap(d.id, d.data()))
          .toList();
      items.sort((a, b) {
        final aTime = a.savedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bTime = b.savedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return bTime.compareTo(aTime);
      });
      return items;
    });
  }

  /// Checks (one-shot) whether a given article is already favorited
  /// by the user — used to set the initial heart icon state on the
  /// Detail page.
  Future<String?> findFavoriteDocId({
    required String userId,
    required int articleId,
  }) async {
    final query = await _favoritesRef
        .where('userId', isEqualTo: userId)
        .where('articleId', isEqualTo: articleId)
        .limit(1)
        .get();
    if (query.docs.isEmpty) return null;
    return query.docs.first.id;
  }

  /// Saves an article's id + title into the "favorites" collection.
  Future<void> addFavorite(FavoriteArticle favorite) async {
    await _favoritesRef.add(favorite.toMap());
  }

  /// Removes a favorite by its Firestore document id.
  Future<void> removeFavorite(String docId) async {
    await _favoritesRef.doc(docId).delete();
  }
}
