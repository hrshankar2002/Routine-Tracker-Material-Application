import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sample_project_1/components/habit_tile.dart';
import 'package:sample_project_1/components/monthly_summary.dart';
import 'package:sample_project_1/components/my_fab.dart';
import 'package:sample_project_1/components/my_alert_box.dart';
import 'package:sample_project_1/data/habit_database.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HabitDatabase db = HabitDatabase();
  final _myBox = Hive.box("Habit_Database");

  @override
  void initState() {
    if (_myBox.get("CURRENT_HABIT_LIST") == null) {
      db.createDefaultData();
    } else {
      db.loadData();
    }
    db.updateDatabase();
    super.initState();
  }

  void checkBoxTapped(bool? value, int index) {
    setState(() {
      db.todaysHabitList[index][1] = value;
    });
    db.updateDatabase();
  }

  final _newHabitController = TextEditingController();
  void createNewHabit() {
    showDialog(
      context: context,
      builder: (context) {
        return MyAlertBox(
          controller: _newHabitController,
          onSave: saveNewHabit,
          onCancel: cancelDialogBox,
          hintText: 'Enter Habit Name..',
        );
      },
    );
  }

  void saveNewHabit() {
    setState(() {
      db.todaysHabitList.add([_newHabitController.text, false]);
    });
    db.updateDatabase();
    _newHabitController.clear();
    Navigator.of(context).pop();
  }

  void cancelDialogBox() {
    _newHabitController.clear();
    Navigator.of(context).pop();
  }

  void openHabitSettings(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return MyAlertBox(
          controller: _newHabitController,
          onCancel: cancelDialogBox,
          onSave: () => saveExistingHabit(index),
          hintText: 'Enter name to edit..',
        );
      },
    );
  }

  void saveExistingHabit(int index) {
    setState(() {
      db.todaysHabitList[index][0] = _newHabitController.text;
    });
    _newHabitController.clear();
    Navigator.of(context).pop();
    db.updateDatabase();
  }

  void deleteHabit(int index) {
    setState(() {
      db.todaysHabitList.removeAt(index);
    });
    db.updateDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(
              child: Text(
            '🆁🅾🆄🆃🅸🅽🅴-🆃🆁🅰🅲🅺🅴🆁',
          )),
          shadowColor: Colors.black,
        ),
        backgroundColor: Colors.grey[400],
        floatingActionButton: MyFloatingActionButton(
          onPressed: createNewHabit,
        ),
        body: ListView(
          children: [
            MonthlySummary(
                datasets: db.heatMapDataSet,
                startDate: _myBox.get('START_DATE')),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return HabitTile(
                  habitName: db.todaysHabitList[index][0],
                  habitCompleted: db.todaysHabitList[index][1],
                  onChanged: (value) {
                    checkBoxTapped(value, index);
                  },
                  settingsTapped: (context) {
                    openHabitSettings(index);
                  },
                  deleteTapped: ((context) => deleteHabit(index)),
                );
              },
              itemCount: db.todaysHabitList.length,
            )
          ],
        ));
  }
}
