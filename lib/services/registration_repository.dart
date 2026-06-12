import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:the_fellows_run/models/registration.dart';
import 'package:the_fellows_run/services/user_cache.dart';

/// Resumo das inscrições pra montar os cards da lista: distância total por
/// corrida (soma das metas) e em quais corridas o usuário atual está inscrito.
class RunsSummary {
  final Map<String, num> totalKm;
  final Set<String> myRunIds;

  const RunsSummary({required this.totalKm, required this.myRunIds});

  static const empty = RunsSummary(totalKm: {}, myRunIds: {});
}

/// Inscrições nas corridas (subcoleção runs/{runId}/registrations/{uid}).
class RegistrationRepository {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String get _uid => _auth.currentUser!.uid;

  CollectionReference<Map<String, dynamic>> _col(String runId) =>
      _firestore.collection('runs').doc(runId).collection('registrations');

  /// Todos os inscritos da corrida, na ordem em que se inscreveram.
  Stream<List<Registration>> watchParticipants(String runId) {
    return _col(runId).orderBy('createdAt').snapshots().map(
          (snap) => snap.docs
              .map((d) => Registration.fromFirestore(d.id, d.data()))
              .toList(),
        );
  }

  /// Resumo de todas as inscrições (pra lista): soma das metas por corrida e o
  /// conjunto de corridas em que estou inscrito. Uma só query no grupo
  /// `registrations`.
  Stream<RunsSummary> watchRunsSummary() {
    return _firestore.collectionGroup('registrations').snapshots().map((snap) {
      final totals = <String, num>{};
      final mine = <String>{};
      for (final doc in snap.docs) {
        final runId = doc.reference.parent.parent!.id;
        final goal = (doc.data()['goal'] ?? 0) as num;
        totals[runId] = (totals[runId] ?? 0) + goal;
        if (doc.id == _uid) mine.add(runId);
      }
      return RunsSummary(totalKm: totals, myRunIds: mine);
    });
  }

  /// Inscreve o usuário atual com a [goal] (denormaliza nome/foto do cache).
  Future<void> register(String runId, num goal) async {
    final data = await UserCache.load();
    await _col(runId).doc(_uid).set({
      'uid': _uid,
      'name': data['name'] ?? '',
      'photoUrl': data['photoUrl'],
      'goal': goal,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateGoal(String runId, num goal) async {
    await _col(runId).doc(_uid).update({'goal': goal});
  }

  Future<void> cancel(String runId) async {
    await _col(runId).doc(_uid).delete();
  }
}
