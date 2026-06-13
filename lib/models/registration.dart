/// Inscrição de um usuário numa corrida (doc em runs/{runId}/registrations/{uid}).
class Registration {
  final String uid;
  final String name;
  final String? photoUrl;
  final num goal; // meta pessoal em km (definida pelo usuário)
  final num? distanceRun; // distância real percorrida (definida pelo admin)

  const Registration({
    required this.uid,
    required this.name,
    this.photoUrl,
    required this.goal,
    this.distanceRun,
  });

  factory Registration.fromFirestore(String uid, Map<String, dynamic> data) {
    return Registration(
      uid: uid,
      name: data['name'] ?? '',
      photoUrl: data['photoUrl'],
      goal: data['goal'] ?? 0,
      distanceRun: data['distanceRun'],
    );
  }

  String get goalKm => '${goal % 1 == 0 ? goal.toInt() : goal} km';
  String get goalLabel => 'Meta $goalKm';

  /// Distância real formatada, ou null se ainda não registrada.
  String? get distanceRunKm {
    final d = distanceRun;
    if (d == null) return null;
    return '${d % 1 == 0 ? d.toInt() : d} km';
  }

  String get initials {
    final parts = name.trim().split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    return parts.take(2).map((p) => p[0]).join().toUpperCase();
  }
}
