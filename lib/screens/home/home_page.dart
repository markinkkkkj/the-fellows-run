import 'package:flutter/material.dart';

import 'package:the_fellows_run/screens/settings/settings_page.dart';
import 'package:the_fellows_run/services/user_repository.dart';
import 'package:the_fellows_run/theme/app_colors.dart';

import 'widgets/completed_tab.dart';
import 'widgets/manage_runs_tab.dart';
import 'widgets/upcoming_tab.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _loadRole();
  }

  Future<void> _loadRole() async {
    final user = await UserRepository().fetchCurrent();
    if (mounted && user != null) setState(() => _isAdmin = user.isAdmin);
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      const Tab(text: 'Próximas'),
      const Tab(text: 'Percorridas'),
      if (_isAdmin) const Tab(text: 'Gerência'),
    ];
    final views = [
      const UpcomingTab(),
      const CompletedTab(),
      if (_isAdmin) const ManageRunsTab(),
    ];

    return DefaultTabController(
      key: ValueKey(_isAdmin),
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          titleSpacing: 20,
          title: Row(
            children: [
              // Logo: círculo preto com raio
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.bolt,
                  color: AppColors.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'The Fellows Run',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings_outlined, color: Colors.black),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Settings()),
                );
              },
            ),
            const SizedBox(width: 8),
          ],
          // TabBar numa faixa escura abaixo do header verde, para que a label
          // ativa e o indicador verde-limão tenham contraste (verde sobre verde
          // ficava invisível).
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: Container(
              color: AppColors.darkBg,
              child: TabBar(
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.mutedFg,
                indicatorColor: AppColors.primary,
                indicatorWeight: 3,
                indicatorSize: TabBarIndicatorSize.label,
                dividerColor: AppColors.divider,
                labelStyle:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                unselectedLabelStyle:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                tabs: tabs,
              ),
            ),
          ),
        ),
        body: SafeArea(
          top: false,
          child: TabBarView(children: views),
        ),
      ),
    );
  }
}
