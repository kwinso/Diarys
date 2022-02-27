import 'package:diarys/components/app_bar.dart';
import 'package:diarys/overscroll_behavior.dart';
import 'package:diarys/screens/schedule.dart';
import 'package:diarys/screens/tasks.dart';
import 'package:diarys/state/db_service.dart';
import 'package:diarys/state/types/day_schedule.dart';
import 'package:diarys/state/types/schedule.dart';
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

class MainPage extends ConsumerStatefulWidget {
  const MainPage({
    Key? key,
  }) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  int activeScreen = 0;
  final screens = <Widget>[
    const TasksScreen(),
    const ScheduleScreen(),
  ];

  @override
  void initState() {
    // TODO: implement initState
    ref.read(databaseService).initLessonsList(super.initState);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: screens[activeScreen],
      // body: FutureBuilder(
      //   future: () async {
      //     final db = ref.read(databaseService);
      //     await db.initLessonsList();
      //     if (activeScreen == 1) {
      //       await db.initSchedule();
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
              currentIndex: activeScreen,
              elevation: 0,
              onTap: (idx) {
                if (idx != activeScreen) {
                  setState(() {
                    activeScreen = idx;
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
}
