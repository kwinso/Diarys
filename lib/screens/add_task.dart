import 'package:diarys/components/route_bar.dart';
import 'package:flutter/material.dart';

class AddTask extends StatelessWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: const RouteBar(
        name: "Новое ДЗ",
      ),
      body: const Center(
        child: Text("Ну и что ты ожидал здесь увидеть? 💩\nИди на расписание смотри."),
      ),
    );
  }
}
