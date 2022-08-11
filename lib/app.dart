import 'dart:async';
import 'package:diarys/screens/add_task.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:diarys/overscroll_behavior.dart';
import 'package:diarys/screens/schedule.dart';
import 'package:diarys/screens/tasks.dart';
import 'package:diarys/theme/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

@immutable
class App extends ConsumerStatefulWidget {
  final bool openAddScreen;
  final int startScreen;
  const App({
    Key? key,
    required this.openAddScreen,
    required this.startScreen,
  }) : super(key: key);

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  bool showSplash = true;
  Widget? mainPage;
  bool addScreenShown = false;

  @override
  void initState() {
    mainPage = MainPage(
      startScreen: widget.startScreen,
      openAddScreen: widget.openAddScreen,
      isUnderSplash: !showSplash,
    );
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      Timer(const Duration(milliseconds: 1250), () {
        showSplash = false;
        if (mounted) setState(() {});
      });
    });
  }

  Widget _getSplash(ThemeData theme) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: theme.appBarTheme.systemOverlayStyle!,
      child: Center(
        child: Text(
          "Diarys",
          style: TextStyle(
            fontSize: 40,
            color: theme.colorScheme.tertiaryContainer,
            fontFamily: "RubikMonoOne",
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeController.select((value) => value.current));

    return MaterialApp(
      title: "Diarys",
      home: Scaffold(
        backgroundColor: theme.backgroundColor,
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(child: child, opacity: animation);
          },
          child: showSplash ? _getSplash(theme) : mainPage,
        ),
      ),
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
  final int startScreen;
  final bool openAddScreen;
  final bool isUnderSplash;
  const MainPage({
    Key? key,
    required this.startScreen,
    required this.openAddScreen,
    required this.isUnderSplash,
  }) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  int _activeScreen = 0;
  // Variable to ensure AddScreen was shown exacly 1 time
  bool addScreenShown = false;
  final _screens = [
    const ScheduleScreen(),
    const TasksScreen(),
  ];

  @override
  void didChangeDependencies() {
    if (!addScreenShown && widget.openAddScreen && !widget.isUnderSplash) {
      Timer(Duration.zero, () {
        Navigator.push(context, MaterialPageRoute(builder: (ctx) => AddTask()));
        addScreenShown = true;
      });
    }
    super.didChangeDependencies();
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
      bottomNavigationBar: _activeScreen == 2
          ? null
          : Container(
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
                  BottomNavigationBarItem(
                      icon: Icon(Icons.calendar_month_rounded), label: "Расписание"),
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
