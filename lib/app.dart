import 'package:diarys/theme/colors.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:diarys/overscroll_behavior.dart';
import 'package:diarys/components/app_bar.dart';
import 'package:diarys/screens/schedule.dart';
import 'package:diarys/screens/tasks.dart';
import 'package:diarys/theme/themes.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

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
      debugShowCheckedModeBanner: false,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [Locale("ru")],
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

class MainPage extends ConsumerStatefulWidget {
  const MainPage({
    Key? key,
  }) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  int _activeScreen = 0;
  final _screens = const <Widget>[TasksScreen(), ScheduleScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      // appBar: Container(),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 100),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(child: child, opacity: animation);
        },
        child: _screens[_activeScreen],
      ),
      //* Maybe change to variant without animaton later
      // body: screens[_activeScreen],
      backgroundColor: Theme.of(context).backgroundColor,
      bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(color: AppColors.shadow, blurRadius: 3, offset: Offset(0.0, 0.1))
            ],
          ),
          // decoration: BoxDecoration(
          //     // TODO: Add shadow
          //     // border: Border(
          //     //   top: BorderSide(
          //     //     color: Theme.of(context).colorScheme.primaryContainer,
          //     // ),
          //     // ),
          //     ),
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
                BottomNavigationBarItem(icon: Icon(Icons.task_alt_sharp), label: "Задания"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.calendar_month_rounded), label: "Расписание")
              ])),
    );
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }
}
