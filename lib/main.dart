import 'package:fluent_ui/fluent_ui.dart';
import 'habit_management_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FluentApp(
      title: 'Habit Formation App',
      home: HabitManagementScreen(),
    );
  }
}
