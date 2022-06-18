import 'package:diarys/screens/add_task.dart';
import 'package:diarys/state/smart_screens.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:diarys/overscroll_behavior.dart';
import 'package:diarys/screens/schedule.dart';
import 'package:diarys/screens/tasks.dart';
import 'package:diarys/theme/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

@immutable
class App extends ConsumerWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeController.select((value) => value.current));

    return MaterialApp(
      title: "Diarys",
      home: const MainPage(),
      theme: theme,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [Locale("ru")],
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: NoOverscrollBehavior(),
          child: child!,
        );
      },
    );
  }
}

class MainPage extends ConsumerStatefulWidget {
  const MainPage({
    Key? key,
  }) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  int _activeScreen = 0;
  bool _isInSchool = false;
  final _screens = const <Widget>[ScheduleScreen(), TasksScreen()];

  Future<void> _setActiveScreen() async {
    final smartScreens = ref.read(smartScreensController);
    await smartScreens.init();
    if (smartScreens.enabled) {
      final now = TimeOfDay.now();
      final schoolStart = smartScreens.schoolStart;
      final schoolEnd = smartScreens.schoolEnd;

      var afterStart = false;
      if (now.hour > schoolStart.hour)
        afterStart = true;
      else if (now.hour == schoolStart.hour && now.minute >= schoolStart.minute) afterStart = true;

      var beforeEnd = false;
      if (now.hour < schoolEnd.hour)
        beforeEnd = true;
      else if (now.hour == schoolEnd.hour && now.minute < schoolEnd.minute) beforeEnd = true;

      _isInSchool = afterStart && beforeEnd;
      _activeScreen = _isInSchool ? smartScreens.schoolScreen : smartScreens.homeScreen;

      if (mounted) setState(() {});

      final openAddScreen = smartScreens.addInSchool && _isInSchool;

      if (openAddScreen) Navigator.push(context, MaterialPageRoute(builder: (c) => AddTask()));
    }
  }

  @override
  void initState() {
    super.initState();
    _setActiveScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(child: child, opacity: animation);
        },
        child: _screens[_activeScreen],
      ),
      //* Maybe change to variant without animaton later
      // body: AnimatedContainer(
      //   duration: Duration(milliseconds: 1000),
      //   child: _screens[_activeScreen],
      // ),
      backgroundColor: Theme.of(context).backgroundColor,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Theme.of(context).shadowColor,
              blurRadius: 3,
              offset: const Offset(0.0, 0.1),
            )
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _activeScreen,
          elevation: 10.0,
          onTap: (idx) {
            if (idx != _activeScreen) {
              setState(() {
                _activeScreen = idx;
              });
            }
          },
          backgroundColor: Theme.of(context).primaryColor,
          selectedItemColor: Theme.of(context).colorScheme.secondary,
          unselectedItemColor: Theme.of(context).colorScheme.tertiaryContainer,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.calendar_month_rounded), label: "Расписание"),
            BottomNavigationBarItem(icon: Icon(Icons.task_alt_sharp), label: "Задания"),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }
}
