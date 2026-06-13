import 'package:cloud_firestore/cloud_firestore.dart';

class Run {
  final String id;
  final String title;
  final String location;
  final DateTime date;
  final DateTime? deadline;

  const Run({
    required this.id,
    required this.title,
    required this.location,
    required this.date,
    this.deadline,
  });

  factory Run.fromFirestore(String id, Map<String, dynamic> data) {
    return Run(
      id: id,
      title: data['title'] ?? '',
      location: data['location'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      deadline: (data['deadline'] as Timestamp?)?.toDate(),
    );
  }

  /// Map pros campos do documento no Firestore. O `id` é gerado pelo Firestore
  /// no `add`, então não vai aqui. A distância não é gravada: ela é a soma das
  /// metas dos inscritos, calculada a partir das inscrições.
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'location': location,
      'date': Timestamp.fromDate(date),
      if (deadline != null) 'deadline': Timestamp.fromDate(deadline!),
    };
  }

  // Helpers de exibição pro RunCard:
  String get day => date.day.toString().padLeft(2, '0');
  String get month => _months[date.month - 1];
  String get time =>
      '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';

  /// Formata uma quantidade de km, ex: 5 → "5 km", 7.5 → "7.5 km".
  static String formatKm(num value) =>
      '${value % 1 == 0 ? value.toInt() : value} km';

  /// Data por extenso, ex: "14 de junho, 2026".
  String get fullDate => '${date.day} de ${_fullMonths[date.month - 1]}, ${date.year}';

  /// Data curta, ex: "14 mai 2026".
  String get shortDate =>
      '${date.day} ${_months[date.month - 1].toLowerCase()} ${date.year}';

  /// Texto do prazo de inscrição, ex: "14 de junho · 06:00" (null se sem prazo).
  String? get deadlineLabel {
    final d = deadline;
    if (d == null) return null;
    final time =
        '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
    return '${d.day} de ${_fullMonths[d.month - 1]} · $time';
  }

  /// Inscrições abertas (sem prazo, ou prazo ainda no futuro).
  bool get registrationOpen =>
      deadline == null || deadline!.isAfter(DateTime.now());

  static const _months = [
    'JAN', 'FEV', 'MAR', 'ABR', 'MAI', 'JUN', 'JUL',
    'AGO', 'SET', 'OUT', 'NOV', 'DEZ',
  ];

  static const _fullMonths = [
    'janeiro', 'fevereiro', 'março', 'abril', 'maio', 'junho',
    'julho', 'agosto', 'setembro', 'outubro', 'novembro', 'dezembro',
  ];
}