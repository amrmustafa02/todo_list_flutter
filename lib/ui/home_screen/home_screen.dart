import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do/controllers/TasksProvider.dart';
import 'package:to_do/models/my_user.dart';
import 'package:to_do/ui/home_screen/settings_screen/main_settings_screen/settings_screen.dart';
import 'package:to_do/ui/home_screen/tasks_screen/tasks_screen.dart';
import 'package:to_do/ui/theming/m_them.dart';

import '../../controllers/Utils.dart';
import '../add_task/bottom_sheet_add_task.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "home_screen";

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [const TasksScreen(), const SettingsScreen()];
    return Scaffold(
      extendBody: true,
      body: screens[selectedIndex],
      floatingActionButton: Ink(
        child: FloatingActionButton(
          backgroundColor: MyTheme.btrolColor,
          elevation: 0,
          child: const Icon(Icons.add),
          onPressed: () {
            showBottomSheet();
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        child: BottomNavigationBar(
          onTap: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
          currentIndex: selectedIndex,
          elevation: 0,
          backgroundColor: Colors.transparent,
          items: [
            BottomNavigationBarItem(
                label: AppLocalizations.of(context)!.list,
                icon: const Icon(Icons.list)),
            BottomNavigationBarItem(
                label: AppLocalizations.of(context)!.settings,
                icon: const Icon(Icons.settings)),
          ],
        ),
      ),
    );
  }

  showBottomSheet() {
    var provider = Provider.of<TasksProvider>(context, listen: false);
    String local = provider.local == const Locale("en") ? 'en' : 'ar';
    Utils.showBottomSheet(context,
        BottomSheetScreen(dateText: Utils.getDateFormat(DateTime.now(),local)),);
  }
}
