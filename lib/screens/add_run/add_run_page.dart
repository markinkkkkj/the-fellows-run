import 'package:flutter/material.dart';

import 'package:the_fellows_run/models/run.dart';
import 'package:the_fellows_run/services/run_repository.dart';
import 'package:the_fellows_run/theme/app_colors.dart';
import 'package:the_fellows_run/widgets/app_text_field.dart';

/// Formulário de corrida (criar ou editar). Acesso restrito a admins via UI; a
/// trava real fica nas Firestore Rules. Passe [run] para editar.
class AddRunPage extends StatefulWidget {
  final Run? run;

  const AddRunPage({super.key, this.run});

  @override
  State<AddRunPage> createState() => _AddRunPageState();
}

class _AddRunPageState extends State<AddRunPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _repository = RunRepository();

  DateTime? _date;
  DateTime? _deadline;
  bool _isSaving = false;

  bool get _isEditing => widget.run != null;

  @override
  void initState() {
    super.initState();
    final run = widget.run;
    if (run != null) {
      _titleController.text = run.title;
      _locationController.text = run.location;
      _date = run.date;
      _deadline = run.deadline;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<DateTime?> _pickDateTime(DateTime? initial) async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: initial ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 2),
    );
    if (date == null || !mounted) return null;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial ?? now),
    );
    if (time == null) return null;

    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  String _formatDateTime(DateTime dt) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(dt.day)}/${two(dt.month)}/${dt.year}  ${two(dt.hour)}:${two(dt.minute)}';
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_date == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Escolha a data e a hora da corrida.')),
      );
      return;
    }

    setState(() => _isSaving = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final run = Run(
        id: widget.run?.id ?? '',
        title: _titleController.text.trim(),
        location: _locationController.text.trim(),
        date: _date!,
        deadline: _deadline,
      );
      if (_isEditing) {
        await _repository.update(run);
      } else {
        await _repository.create(run);
      }
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              _isEditing ? 'Corrida atualizada!' : 'Corrida criada com sucesso!',
            ),
          ),
        );
        Navigator.pop(context);
      }
    } catch (error) {
      messenger.showSnackBar(
        SnackBar(content: Text('Erro ao salvar corrida: $error')),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, left: 4),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.mutedFg,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _dateTile({
    required String label,
    required DateTime? value,
    required String hint,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context).colorScheme;
    return Material(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Icon(Icons.calendar_today_outlined, size: 18, color: theme.primary),
              const SizedBox(width: 12),
              Text(
                value == null ? hint : _formatDateTime(value),
                style: TextStyle(
                  color: value == null ? AppColors.mutedFg : theme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditing ? 'Editar corrida' : 'Nova corrida',
          style: TextStyle(color: theme.onPrimary, fontWeight: FontWeight.w700),
        ),
        backgroundColor: theme.primary,
        iconTheme: IconThemeData(color: theme.onPrimary),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _label('Título'),
                AppTextField(
                  controller: _titleController,
                  hintText: 'Ex: Corrida da Lagoa',
                  textInputAction: TextInputAction.next,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Informe o título' : null,
                ),
                const SizedBox(height: 16),

                _label('Local'),
                AppTextField(
                  controller: _locationController,
                  hintText: 'Ex: Lagoa Rodrigo de Freitas',
                  textInputAction: TextInputAction.next,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Informe o local' : null,
                ),
                const SizedBox(height: 16),

                _label('Data e hora'),
                _dateTile(
                  label: 'Data e hora',
                  value: _date,
                  hint: 'Selecionar data e hora',
                  onTap: () async {
                    final picked = await _pickDateTime(_date);
                    if (picked != null) setState(() => _date = picked);
                  },
                ),
                const SizedBox(height: 16),

                _label('Prazo de inscrição (opcional)'),
                _dateTile(
                  label: 'Prazo de inscrição',
                  value: _deadline,
                  hint: 'Selecionar prazo',
                  onTap: () async {
                    final picked = await _pickDateTime(_deadline);
                    if (picked != null) setState(() => _deadline = picked);
                  },
                ),
                const SizedBox(height: 32),

                ElevatedButton(
                  onPressed: _isSaving ? null : _save,
                  child: _isSaving
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.black,
                          ),
                        )
                      : Text(_isEditing ? 'Salvar alterações' : 'Criar corrida'),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
