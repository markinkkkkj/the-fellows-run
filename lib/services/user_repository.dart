import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:the_fellows_run/models/user.dart';
import 'package:the_fellows_run/services/user_cache.dart';

/// Acesso aos dados do usuário: Firestore, Storage, Auth e cache local.
class UserRepository {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  User get _currentUser => _auth.currentUser!;

  /// Carrega o usuário a partir do cache local.
  Future<AppUser> loadFromCache() async {
    return AppUser.fromCache(await UserCache.load());
  }

  /// Sobe [newPhotoFile] pro Storage e devolve a nova URL. Se não houver foto
  /// nova nem atual, remove a foto do Storage e do cache. Retorna a URL final
  /// (ou null se a foto foi removida).
  Future<String?> resolveProfilePhoto({
    required File? newPhotoFile,
    required String? currentPhotoUrl,
  }) async {
    final ref = _storage.ref().child('users/${_currentUser.uid}/profile.jpg');
    if (newPhotoFile != null) {
      await ref.putFile(newPhotoFile);
      return ref.getDownloadURL();
    }
    if (currentPhotoUrl == null) {
      await ref.delete();
      await UserCache.clearPhoto();
    }
    return currentPhotoUrl;
  }

  /// Reautentica com a senha atual e dispara a verificação pra troca de e-mail.
  Future<void> updateEmail(String newEmail, String currentPassword) async {
    final user = _currentUser;
    final credential = EmailAuthProvider.credential(
      email: user.email!,
      password: currentPassword,
    );
    await user.reauthenticateWithCredential(credential);
    await user.verifyBeforeUpdateEmail(newEmail);
  }

  /// Reautentica com a senha atual e troca a senha.
  Future<void> changePassword(String currentPassword, String newPassword) async {
    final user = _currentUser;
    final credential = EmailAuthProvider.credential(
      email: user.email!,
      password: currentPassword,
    );
    await user.reauthenticateWithCredential(credential);
    await user.updatePassword(newPassword);
  }

  /// Persiste o usuário no Firestore e no cache local.
  Future<void> saveProfile(AppUser user) async {
    await _firestore.collection('users').doc(user.uid).update({
      ...user.toFirestore(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    await UserCache.save(user.toCacheMap());
  }
}
