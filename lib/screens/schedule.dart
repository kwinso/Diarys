import 'package:diarys/components/controllers_init.dart';
import 'package:diarys/components/schedule/controls.dart';
import 'package:diarys/components/main_app_bar.dart';
import 'package:diarys/components/schedule/modal_form.dart';
import 'package:diarys/components/schedule/modal_input.dart';
import 'package:diarys/components/schedule/swiper.dart';
import 'package:diarys/components/screen_header.dart';
import 'package:diarys/state/edit_schedule.dart';
import 'package:diarys/state/hive/controllers/schedule.dart';
import 'package:diarys/theme/colors.dart';
import 'package:diarys/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';

class ScheduleScreen extends ConsumerStatefulWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends ConsumerState<ScheduleScreen> {
  final ValueNotifier<int> _currentDay =
      ValueNotifier(DateTime.now().weekday - 1);
  final SwiperController _swiperController = SwiperController();
  String _newSubjectText = "";

  @override
  void initState() {
    _swiperController.addListener(() {
      print("Controller");
    });
    // TODO: implement initState
    super.initState();
  }

  void _onFormSubmit(BuildContext context) {
    if (_newSubjectText.isNotEmpty) {
      ref.read(scheduleController.notifier).addLessonsToDay(
          _currentDay.value, _newSubjectText.trim().split("\n"));
    }
    Navigator.pop(context);
  }

  List<ScreenHeaderButton> _currentButtons() {
    final edit = ref.watch(scheduleEditController);

    if (!edit.active) {
      return [
        ScreenHeaderButton(
          label: "Поделиться",
          icon: Icons.share_rounded,
          onPressed: () {
            // TODO:
          },
        ),
        ScreenHeaderButton(
          label: "Добавить",
          icon: Icons.add_rounded,
          onPressed: () {
            AppUtils.showBottomSheet(
              context: context,
              builder: (ctx) => ModalForm(
                input: ModalAutoCompleteInput(
                  value: "",
                  onTextUpdate: (s) {
                    setState(() {
                      _newSubjectText = s;
                    });
                  },
                  onSubmit: (_) {
                    _onFormSubmit(ctx);
                  },
                  multiline: true,
                ),
                onCancel: () {
                  Navigator.pop(ctx);
                },
                submitButtonText: "Добавить",
                onSubmit: () {
                  _onFormSubmit(ctx);
                },
              ),
            );
          },
        ),
      ];
    }

    if (edit.selectedItems.isEmpty) {
      return [
        // ScreenHeaderButton(
        //   label: "Отмена",
        //   foreground: Colors.white,
        //   background: AppColors.red,
        //   icon: Icons.clear,
        //   onPressed: () => edit.active = false,
        // ),
        ScreenHeaderButton(
          label: "Готово",
          foreground: Colors.white,
          background: AppColors.green,
          icon: Icons.done_rounded,
          onPressed: () {
            edit.active = false;
          },
        ),
      ];
    }

    return [
      ScreenHeaderButton(
        label: "Очистить",
        foreground: Colors.white,
        background: AppColors.red,
        icon: Icons.clear_rounded,
        onPressed: () => edit.clearSelected(),
      ),
      ScreenHeaderButton(
        label: "Удалить",
        foreground: Colors.white,
        background: AppColors.red,
        icon: Icons.delete_rounded,
        onPressed: () => edit.deleteSelected(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return HiveControllersInit(
      controllers: [scheduleController],
      build: () => CustomScrollView(
        slivers: [
          const MainAppBar(),
          SliverToBoxAdapter(
            child: ScreenHeader(
              title: "Расписание",
              buttons: _currentButtons(),
            ),
          ),
          SliverAppBar(
            pinned: true,
            expandedHeight: 15,
            backgroundColor: Theme.of(context).backgroundColor,
            toolbarHeight: 15,
            flexibleSpace: ScheduleSwiperControls(
              onNext: () => _swiperController.next(),
              onPrev: () => _swiperController.previous(),
              index: _currentDay,
            ),
          ),
          SliverToBoxAdapter(
            child: ScheduleSwiper(
              controller: _swiperController,
              currentDay: _currentDay,
            ),
          ),
        ],
      ),
    );
    // return Scaffold(
    //   body: ListView(
    //     children: [
    //       AnimatedContainer(
    //         duration: Duration(milliseconds: 300),
    //         child: ScreenHeader(
    //           title: "Расписание",
    //           buttons: _currentButtons(),
    //         ),
    //       ),
    //       Padding(
    //         padding: const EdgeInsets.only(bottom: 10),
    //         child: ScheduleSwiperControls(
    //           onNext: () => _swiperController.next(),
    //           onPrev: () => _swiperController.previous(),
    //           index: _currentDay.value,
    //         ),
    //       ),
    //       Expanded(
    //         child: HiveControllersInit(
    //           controllers: [scheduleController],
    //           build: () => ScheduleSwiper(
    //             controller: _swiperController,
    //             currentDay: _currentDay,
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }

  @override
  void dispose() {
    _swiperController.dispose();
    super.dispose();
  }
}
