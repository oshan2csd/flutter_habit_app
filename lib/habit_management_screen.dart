import 'package:fluent_ui/fluent_ui.dart';
import 'database_helper.dart'; // Import the DatabaseHelper class

class HabitManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: PageHeader(
        title: Text('Manage Habits'),
      ),
      content: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: HabitList(),
            ),
            SizedBox(height: 20),
            FilledButton(
              child: Text('Add New Habit'),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AddHabitDialog(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class HabitList extends StatefulWidget {
  @override
  _HabitListState createState() => _HabitListState();
}

class _HabitListState extends State<HabitList> {
  List<Map<String, dynamic>> _habits = [];

  @override
  void initState() {
    super.initState();
    _loadHabits();
  }

  Future<void> _loadHabits() async {
    final habits = await DatabaseHelper().getHabits();
    setState(() {
      _habits = habits;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _habits.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(_habits[index]['name']),
          subtitle: Text(_habits[index]['description']),
          trailing: IconButton(
            icon: Icon(FluentIcons.delete),
            onPressed: () async {
              await DatabaseHelper().deleteHabit(_habits[index]['id']);
              _loadHabits(); // Refresh the list after deletion
            },
          ),
        );
      },
    );
  }
}


class AddHabitDialog extends StatefulWidget {
  @override
  _AddHabitDialogState createState() => _AddHabitDialogState();
}

class _AddHabitDialogState extends State<AddHabitDialog> {
  final TextEditingController _habitNameController = TextEditingController();
  final TextEditingController _habitDescriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: Text('Add New Habit'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextBox(
            controller: _habitNameController,
            placeholder: 'Enter habit name',
          ),
          SizedBox(height: 10),
          TextBox(
            controller: _habitDescriptionController,
            placeholder: 'Enter habit description',
            maxLines: 3,
          ),
        ],
      ),
      actions: [
        Button(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
    FilledButton(
      child: Text('Save'),
      onPressed: () async {
        final habitName = _habitNameController.text;
        final habitDescription = _habitDescriptionController.text;

        if (habitName.isNotEmpty) {
        await DatabaseHelper().insertHabit({
        'name': habitName,
        'description': habitDescription,
        });
        Navigator.pop(context);
        }},
      ),
      ],
    );
  }
}

