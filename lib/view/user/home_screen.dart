import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppInfo {
  final String name;
  final String icon;
  DateTime? lockUntil;
  DateTime? timelock;
  String? status;

  AppInfo({
    required this.name,
    required this.icon,
    this.lockUntil,
    this.timelock,
    this.status = 'active',
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<AppInfo> _apps = [
    AppInfo(name: 'Facebook', icon: '📘'),
    AppInfo(name: 'Instagram', icon: '📷'),
    AppInfo(name: 'TikTok', icon: '🎵'),
    AppInfo(name: 'YouTube', icon: '▶️'),
    AppInfo(name: 'Zalo', icon: '💬'),
    AppInfo(name: 'Messenger', icon: '💭'),
    AppInfo(name: 'Chrome', icon: '🌐'),
    AppInfo(name: 'Game Center', icon: '🎮'),
  ];

  List _selecetedApp = [];

  DateTime _selectedTime = DateTime.now();

  void unlockApp() {
    for (var appName in _selecetedApp) {
      final app = _apps.firstWhere((a) => a.name == appName);
      app.status = 'active';
      app.lockUntil = null;
      debugPrint('Unlock ${app.name}');
      setState(() {});
    }
    _selecetedApp.clear();
  }

  void lockNow() {
    for (var appName in _selecetedApp) {
      final app = _apps.firstWhere((a) => a.name == appName);
      app.status = 'lockNow';
      app.timelock = _selectedTime;
      debugPrint("Lock Now ${app.name} ${app.timelock}");
      setState(() {
        _selectedTime = DateTime.now();
      });
    }
    _selecetedApp.clear();
  }

  String formatDuration(Duration d) {
    if (d.inMinutes <= 0) return "0 phút";

    if (d.inMinutes >= 60) {
      int hours = d.inHours;
      int minutes = d.inMinutes % 60;
      return "$hours giờ $minutes phút";
    }
    return "${d.inMinutes} phút";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: .symmetric(horizontal: 15),
          children: [
            Center(
              child: Text('Quản lý ứng dụng', style: TextStyle(fontSize: 28)),
            ),
            SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
                childAspectRatio: 1,
              ),
              itemCount: _apps.length + 1,
              itemBuilder: (context, index) {
                if (index == _apps.length) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (_selecetedApp.length == _apps.length) {
                          _selecetedApp.clear();
                        } else {
                          _selecetedApp = _apps.map((app) => app.name).toList();
                        }
                      });
                    },
                    child: Container(
                      alignment: .center,
                      decoration: BoxDecoration(
                        borderRadius: .circular(12),
                        border: .all(width: 1, color: Colors.grey),
                      ),
                      child: Text('Tất cả'),
                    ),
                  );
                }
                final app = _apps[index];
                final isSelected = _selecetedApp.contains(app.name);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selecetedApp.remove(app.name);
                      } else {
                        _selecetedApp.add(app.name);
                      }
                    });
                    debugPrint('Selected : ${app.name}');
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: .circular(12),
                      border: .all(
                        width: 1,
                        color: isSelected ? Colors.red : Colors.grey,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: .center,
                      children: [
                        Text(app.icon),
                        Text(app.name),
                        if (app.status == 'lockNow') AppLockWidget(app: app),
                      ],
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 10),
            Column(
              children: [
                Text('Chọn thời gian', style: TextStyle(fontSize: 18)),
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: .circular(10),
                  ),
                  height: 120,
                  child: CupertinoDatePicker(
                    key: ValueKey(_selectedTime),
                    mode: CupertinoDatePickerMode.time,
                    initialDateTime: _selectedTime,
                    onDateTimeChanged: (DateTime newTime) {
                      setState(() {
                        _selectedTime = newTime;
                      });
                    },
                    use24hFormat: true,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: .spaceAround,
              children: [
                _buttonLock(Icons.lock_open_outlined, 'Mở khóa', unlockApp),
                _buttonLock(Icons.lock, 'Khóa ngay', lockNow),
                _buttonLock(Icons.lock_clock, 'Khóa sau', () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buttonLock(IconData icon, String label, VoidCallback onPressed) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(35),
            border: Border.all(color: Colors.grey, width: 2),
          ),
          child: IconButton(
            icon: Icon(icon, size: 30, color: Colors.blue),
            onPressed: onPressed,
          ),
        ),
        SizedBox(height: 8),
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class AppLockWidget extends StatefulWidget {
  final AppInfo app;

  const AppLockWidget({super.key, required this.app});

  @override
  State<AppLockWidget> createState() => _AppLockWidgetState();
}

class _AppLockWidgetState extends State<AppLockWidget> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String formatDuration(Duration d) {
    if (d.inMinutes <= 0) return "0 phút";
    if (d.inMinutes >= 60) {
      int hours = d.inHours;
      int minutes = d.inMinutes % 60;
      return "$hours giờ $minutes phút";
    }
    return "${d.inMinutes} phút";
  }

  @override
  Widget build(BuildContext context) {
    final remaining = widget.app.timelock!.difference(DateTime.now());

    return Text(
      'Khóa trong ${formatDuration(remaining)}',
      textAlign: TextAlign.center,
    );
  }
}
