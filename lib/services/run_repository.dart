import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:the_fellows_run/models/run.dart';

/// Acesso à coleção de corridas no Firestore.
class RunRepository {
  final _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _runs =>
      _firestore.collection('runs');

  /// Todas as corridas, mais recentes primeiro.
  Stream<List<Run>> watchAll() {
    return _runs.orderBy('date', descending: true).snapshots().map(
          (snap) => snap.docs
              .map((d) => Run.fromFirestore(d.id, d.data()))
              .toList(),
        );
  }

  /// Cria uma corrida. O Firestore gera o id, então [Run.id] é ignorado.
  Future<void> create(Run run) async {
    await _runs.add(run.toFirestore());
  }

  /// Atualiza os dados de uma corrida existente.
  Future<void> update(Run run) async {
    await _runs.doc(run.id).update(run.toFirestore());
  }

  /// Exclui a corrida. As inscrições (subcoleção) não são removidas aqui —
  /// ficam órfãs, mas somem da UI porque a corrida deixa de existir.
  Future<void> delete(String runId) async {
    await _runs.doc(runId).delete();
  }
}
