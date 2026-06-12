import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:the_fellows_run/models/run.dart';

/// Acesso à coleção de corridas no Firestore.
class RunRepository {
  final _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _runs =>
      _firestore.collection('runs');

  /// Cria uma corrida. O Firestore gera o id, então [Run.id] é ignorado.
  Future<void> create(Run run) async {
    await _runs.add(run.toFirestore());
  }
}
