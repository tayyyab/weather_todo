import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_todo/ui/auth/provider/auth_state_provider.dart';
import 'package:weather_todo/ui/core/ui/theme_mode/theme_mode.dart';
import 'package:weather_todo/ui/todo/widget/todo_page.dart';
import 'package:weather_todo/ui/weather/widget/weather_page.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              icon: Icon(
                _selectedIndex == 0 ? Icons.task : Icons.task_outlined,
              ),
            ),
            Tab(
              icon: Icon(
                _selectedIndex == 1 ? Icons.cloud : Icons.cloud_outlined,
              ),
            ),
          ],
        ),
        actions: [
          ThemeModeSwitcher(),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authStateProvider.notifier).logout();
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [TodoPage(), WeatherPage()],
      ),
    );
  }
}
