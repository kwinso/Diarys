import 'package:diarys/components/app_bar.dart';
import 'package:diarys/overscroll_behavior.dart';
import 'package:diarys/screens/schedule.dart';
import 'package:diarys/screens/tasks.dart';
import 'package:diarys/state/db_service.dart';
import 'package:diarys/state/types/day_schedule.dart';
import 'package:diarys/state/types/schedule.dart';
import 'package:diarys/state/types/subject.dart';
import 'package:diarys/theme/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import "package:hive_flutter/hive_flutter.dart";
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appDir = await getApplicationDocumentsDirectory();
  Hive.init(appDir.path);
  Hive.registerAdapter(ScheduleAdapter());
  Hive.registerAdapter(DayScheduleAdapter());
  Hive.registerAdapter(SubjectAdapter());

  final db = DatabaseService();
  await db.openLessonsBox();

  runApp(ProviderScope(overrides: [databaseService.overrideWithValue(db)], child: const App()));
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

class MainPage extends ConsumerStatefulWidget {
  const MainPage({
    Key? key,
  }) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  int _activeScreen = 0;
  final _pageController = PageController();

  final screens = <Widget>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: PageView(
        controller: _pageController,
        onPageChanged: (idx) => setState(() => _activeScreen = idx),
        children: const [
          TasksScreen(),
          ScheduleScreen(),
        ],
      ),
      // body: screens[_activeScreen],
      // body: FutureBuilder(
      //   future: () async {
      //     final db = ref.read(databaseService);
      //     if (activeScreen == 1) {
      //       await db._initSchedule();
      //     } else {
      //       // TODO: Init tasks
      //     }
      //   }(),
      //   builder: (BuildContext context, AsyncSnapshot snapshot) {
      //     if (snapshot.connectionState == ConnectionState.done) {
      //       return screens[activeScreen];
      //     }
      //     return Container();
      //   },
      // ),
      backgroundColor: Theme.of(context).backgroundColor,
      bottomNavigationBar: Container(
          decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Theme.of(context).colorScheme.primary))),
          child: BottomNavigationBar(
              currentIndex: _activeScreen,
              elevation: 0,
              onTap: (idx) {
                if (idx != _activeScreen) {
                  _pageController.animateToPage(idx,
                      duration: Duration(milliseconds: 500), curve: Curves.easeOut);
                  setState(() {
                    _activeScreen = idx;
                  });
                }
              },
              backgroundColor: Theme.of(context).backgroundColor,
              selectedItemColor: Theme.of(context).colorScheme.secondary,
              unselectedItemColor: Theme.of(context).colorScheme.tertiaryContainer,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.task_alt_sharp), label: "Задания"),
                BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: "Расписание")
              ])),
    );
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }
}
