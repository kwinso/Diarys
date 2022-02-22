import 'package:diarys/components/app_bar.dart';
import 'package:diarys/overscroll_behavior.dart';
import 'package:diarys/screens/schedule.dart';
import 'package:diarys/screens/tasks.dart';
import 'package:diarys/theme/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: App()));
}

@immutable
class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    currentTheme.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: NoOverscrollBehavior(),
          child: child!,
        );
      },
      home: const MainPage(),
      title: "Diarys",
      theme: AppThemeData.light,
      darkTheme: AppThemeData.dark,
      themeMode: currentTheme.mode,
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({
    Key? key,
  }) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int activeScreen = 0;
  final screens = <Widget>[
    TasksScreen(),
    ScheduleScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: screens[activeScreen],
      backgroundColor: Theme.of(context).backgroundColor,
      bottomNavigationBar: Container(
          decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Theme.of(context).colorScheme.primary))),
          child: BottomNavigationBar(
              currentIndex: activeScreen,
              elevation: 0,
              onTap: (idx) => setState(() => activeScreen = idx),
              backgroundColor: Theme.of(context).backgroundColor,
              selectedItemColor: Theme.of(context).colorScheme.secondary,
              unselectedItemColor: Theme.of(context).colorScheme.tertiaryContainer,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.task_alt_sharp), label: "Задания"),
                BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: "Расписание")
              ])),
    );
  }
}
