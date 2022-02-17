import 'package:diarys/appBar.dart';
import 'package:diarys/screens/schedule.dart';
import 'package:diarys/screens/tasks.dart';
import 'package:diarys/theme/themes.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const App());
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
      home: const MainPage(title: "Diarys"),
      title: "Diarys",
      theme: AppThemeData.light,
      darkTheme: AppThemeData.dark,
      themeMode: currentTheme.mode,
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int activeScreen = 0;
  final screens = <Widget>[TasksScreen(), ScheduleScreen()];

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: const CustomAppBar(),
      body: screens[activeScreen],
      backgroundColor: Theme.of(context).backgroundColor,
      bottomNavigationBar: Container(
          decoration: BoxDecoration(
              border: Border(
                  top: BorderSide(
                      color: Theme.of(context).colorScheme.primary))),
          child: BottomNavigationBar(
              currentIndex: activeScreen,
              elevation: 0,
              onTap: (idx) => setState(() => activeScreen = idx),
              backgroundColor: Theme.of(context).backgroundColor,
              selectedItemColor: Theme.of(context).colorScheme.secondary,
              unselectedItemColor:
                  Theme.of(context).colorScheme.tertiaryContainer,
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.task_alt_sharp), label: "Задания"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.list_alt), label: "Расписание")
              ])),
    );
  }
}
