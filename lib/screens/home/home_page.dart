import 'package:flutter/material.dart';

import 'package:the_fellows_run/screens/settings/settings_page.dart';
import 'package:the_fellows_run/theme/app_colors.dart';

import 'widgets/completed_tab.dart';
import 'widgets/upcoming_tab.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
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
              child: const TabBar(
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.mutedFg,
                indicatorColor: AppColors.primary,
                indicatorWeight: 3,
                indicatorSize: TabBarIndicatorSize.label,
                dividerColor: AppColors.divider,
                labelStyle:
                    TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                unselectedLabelStyle:
                    TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                tabs: [
                  Tab(text: 'Próximas'),
                  Tab(text: 'Percorridas'),
                ],
              ),
            ),
          ),
        ),
        body: const SafeArea(
          top: false,
          child: TabBarView(
            children: [
              UpcomingTab(),
              CompletedTab(),
            ],
          ),
        ),
      ),
    );
  }
}
