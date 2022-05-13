import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:diarys/overscroll_behavior.dart';
import 'package:diarys/screens/schedule.dart';
import 'package:diarys/screens/tasks.dart';
import 'package:diarys/theme/themes.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

@immutable
class App extends ConsumerWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeController);

    return MaterialApp(
      title: "Diarys",
      home: const MainPage(),
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: theme.mode,
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

class MainPage extends StatefulWidget {
  const MainPage({
    Key? key,
  }) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _activeScreen = 0;
  final _screens = const <Widget>[TasksScreen(), ScheduleScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
          decoration: BoxDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Theme.of(context).shadowColor,
                blurRadius: 3,
                offset: Offset(0.0, 0.1),
              )
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
