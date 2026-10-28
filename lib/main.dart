import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 02',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const Lab02Page(),
    );
  }
}

class Lab02Page extends StatefulWidget {
  const Lab02Page({super.key});

  @override
  State<Lab02Page> createState() => _Lab02PageState();
}

class _Lab02PageState extends State<Lab02Page> {
  // 状态变量
  DateTime _selectedDate = DateTime.now();
  String _selectedRole = 'Student';

  // 1. Material Date Picker
  Future<void> _selectMaterialDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // 2. Cupertino Date Picker (Modal Sheet)
  void _showCupertinoDatePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 240,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.date,
          initialDateTime: _selectedDate,
          onDateTimeChanged: (DateTime newDate) {
            setState(() => _selectedDate = newDate);
          },
        ),
      ),
    );
  }

  // 4. Cupertino Picker (Wheel)
  void _showCupertinoRolePicker(BuildContext context) {
    final List<String> roles = ['Student', 'Developer', 'Designer'];
    int initialIndex = roles.indexOf(_selectedRole);
    if (initialIndex == -1) initialIndex = 0;

    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 200,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: CupertinoPicker(
          itemExtent: 32,
          scrollController: FixedExtentScrollController(initialItem: initialIndex),
          onSelectedItemChanged: (int index) {
            setState(() => _selectedRole = roles[index]);
          },
          children: roles.map((role) => Center(child: Text(role))).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CSS3344 Mobile App Dev - Lab 02')),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return orientation == Orientation.portrait
              ? _buildPortraitView()
              : _buildLandscapeView();
        },
      ),
    );
  }

  // 竖屏布局
  Widget _buildPortraitView() {
    return ListView(
      children: [
        Container(
          height: 200,
          color: Colors.blueGrey[200],
          child: const Center(child: Icon(Icons.image, size: 50, color: Colors.white)),
        ),
        const TitleSection(
          name: 'Desmond Then Kai Zhong',
          location: 'BCS24090043',
          starCount: 41,
        ),
        _buildPickersSection(context), // 放入四个选择器
      ],
    );
  }

  // 横屏布局
  Widget _buildLandscapeView() {
    return Row(
      children: [
        Expanded(
          child: Container(
            color: Colors.blueGrey[200],
            child: const Center(child: Icon(Icons.image, size: 50, color: Colors.white)),
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              const TitleSection(
                name: 'Desmond Then Kai Zhong',
                location: 'BCS24090043',
                starCount: 41,
              ),
              _buildPickersSection(context), // 放入四个选择器
            ],
          ),
        ),
      ],
    );
  }

  // 四个选择器的 UI 组合
  Widget _buildPickersSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Interactive Pickers (Lab 2.2)',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const Divider(),
          Text('Selected Date: ${_selectedDate.toString().split(' ')[0]}'),
          Text('Selected Role: $_selectedRole'),
          const SizedBox(height: 10),

          // 1. Material Date Picker 按钮
          OutlinedButton.icon(
            icon: const Icon(Icons.calendar_today),
            label: const Text('Material Date Picker'),
            onPressed: () => _selectMaterialDate(context),
          ),
          const SizedBox(height: 10),

          // 2. Cupertino Date Picker 按钮
          OutlinedButton.icon(
            icon: const Icon(Icons.apple),
            label: const Text('Cupertino Date Picker (Modal Sheet)'),
            onPressed: () => _showCupertinoDatePicker(context),
          ),
          const SizedBox(height: 20),

          // 3. Material DropdownButton
          Row(
            children: [
              const Text('Material Dropdown: '),
              DropdownButton<String>(
                value: _selectedRole,
                items: ['Student', 'Developer', 'Designer'].map((String role) {
                  return DropdownMenuItem<String>(
                    value: role,
                    child: Text(role),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() => _selectedRole = newValue);
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 4. Cupertino Wheel Picker 按钮
          OutlinedButton.icon(
            icon: const Icon(Icons.list),
            label: const Text('Cupertino House Wheel Picker'),
            onPressed: () => _showCupertinoRolePicker(context),
          ),
        ],
      ),
    );
  }
}

// 拆解的组件 TitleSection
class TitleSection extends StatelessWidget {
  final String name;
  final String location;
  final int starCount;

  const TitleSection({
    super.key,
    required this.name,
    required this.location,
    required this.starCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 4),
                Text(
                  location,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          Icon(Icons.star, color: Colors.red[500]),
          const SizedBox(width: 4),
          Text('$starCount'),
        ],
      ),
    );
  }
}