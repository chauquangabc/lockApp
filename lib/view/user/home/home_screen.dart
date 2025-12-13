import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:lock_application/view/user/home/create_group.dart';

import '../../../model/fake_data.dart';
import 'detail_group.dart';


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

  final List<Member> _members = [
    Member(name: 'Alex', device: 'Iphone 16 ProMax'),
    Member(name: 'Antony', device: 'Samsung Galaxy'),
    Member(name: 'Robin', device: 'Iphone 17 ProMax'),
    Member(name: 'Hulk', device: 'Oppo A38'),
  ];

  late final List<Group> _groups = [
    Group(
      name: 'Nhóm Học Tập',
      members: [_members[0], _members[2]],
      // Alex, Robin
      lockedApps: [
        _apps[0].copyWith(
          status: 'locked',
          timLock: DateTime.now().add(const Duration(hours: 2)),
        ), // Facebook
        _apps[3].copyWith(
          status: 'locked',
          timLock: DateTime.now().add(const Duration(hours: 2)),
        ), // YouTube
      ],
      totalLockDuration: const Duration(hours: 2),
    ),
    Group(
      name: 'Nhóm Giải Trí',
      members: [_members[1]],
      // Antony
      lockedApps: [
        _apps[1].copyWith(
          status: 'locked',
          timLock: DateTime.now().add(const Duration(hours: 1)),
        ), // Instagram
        _apps[2].copyWith(
          status: 'locked',
          timLock: DateTime.now().add(const Duration(hours: 1)),
        ), // TikTok
      ],
      totalLockDuration: const Duration(hours: 1),
    ),
  ];

  List _selecetedApp = [];

  DateTime _selectedTime = DateTime.now();

  void unlockApp() {
    for (var appName in _selecetedApp) {
      final app = _apps.firstWhere((a) => a.name == appName);
      app.status = 'active';
      app.timLock = null;
      app.lockLaterTime = null;
      debugPrint('Unlock ${app.name}');
      setState(() {});
    }
    _selecetedApp.clear();
  }

  void lockNow() {
    for (var appName in _selecetedApp) {
      final app = _apps.firstWhere((a) => a.name == appName);
      app.status = 'lockNow';
      app.timLock = _selectedTime;
      debugPrint("Lock Now ${app.name} ${app.timLock}");
      setState(() {
        _selectedTime = DateTime.now();
      });
    }
    _selecetedApp.clear();
  }

  void lockLater() {
    for (var appName in _selecetedApp) {
      final app = _apps.firstWhere((a) => a.name == appName);
      app.status = 'lockLater';
      app.lockLaterTime = _selectedTime;
      debugPrint("Lock Later ${app.name} ${app.timLock}");
      setState(() {
        _selectedTime = DateTime.now();
      });
    }
    _selecetedApp.clear();
  }


  void _updateGroup(Group updatedGroup) {
    setState(() {
      // Tìm index của group cũ và thay thế
      final index = _groups.indexWhere((g) => g.name == updatedGroup.name);
      if (index != -1) {
        _groups[index] = updatedGroup;
      }
    });
  }

  // Xóa Group theo ID
  void _deleteGroupById(String groupName) {
    setState(() {
      _groups.removeWhere((g) => g.name == groupName);
    });
  }

  // --- HÀM GỌI MÀN HÌNH CHI TIẾT VÀ XỬ LÝ KẾT QUẢ ---

  void _openGroupDetail(Group group) async {
    // Mở màn hình chi tiết Group và đợi kết quả trả về (Group? hoặc null)
    final Group? result = await Navigator.push<Group>(
      context,
      MaterialPageRoute(
        builder: (context) => GroupDetailScreen(
          group: group, // Truyền Group hiện tại
        ),
      ),
    );

    // Xử lý kết quả
    if (result != null) {
      // 1. Group đã được chỉnh sửa và lưu (result là Group đã update)
      _updateGroup(result);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã cập nhật Group "${result.name}" thành công!')),
      );
    }
    // else {
    //   // 2. Group đã bị xóa (result là null)
    //   // Sử dụng group.id gốc (vì group.name và id vẫn còn)
    //   _deleteGroupById(group.name);
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('Đã xóa Group "${group.name}".')),
    //   );
    // }
  }

  void _addNewGroup(Group newGroup) {
    setState(() {
      _groups.add(newGroup);
    });
  }

  void _navigateCreateGroup(BuildContext context) async {
    final Group? result = await Navigator.push<Group>(
      context,
      MaterialPageRoute(builder: (context) => const CreateGroup()),
    );

    // Xử lý kết quả chỉ khi nó không phải là null
    if (result != null) {
      _addNewGroup(result);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã tạo Group "${result.name}" thành công!')),
      );
    }
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
                        if (app.status == 'lockLater')
                          Text(
                            'Khóa sau : ${DateFormat('HH:mm').format(app.lockLaterTime!)}',
                          ),
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
                _buttonLock(Icons.lock_clock, 'Khóa sau', lockLater),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Danh sách Group Khóa',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                TextButton.icon(
                  onPressed: () {
                    _navigateCreateGroup(context);
                  },
                  icon: const Icon(Icons.group_add, size: 20),
                  label: const Text('Thêm Group'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Hiển thị danh sách Group
            _groups.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Text(
                        'Chưa có Group nào được tạo. Tạo Group mới để quản lý nhóm người dùng và ứng dụng.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                  )
                : Column(
                    children: _groups.map((group) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: GroupCard(
                          group: group,
                          onTap: () => _openGroupDetail(group),
                        ),
                      );
                    }).toList(),
                  ),

            const SizedBox(height: 30),
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

class GroupCard extends StatelessWidget {
  final Group group;
  final VoidCallback onTap;

  const GroupCard({super.key, required this.group, required this.onTap});

  String _formatDuration(Duration d) {
    int hours = d.inHours;
    int minutes = d.inMinutes.remainder(60);
    if (hours > 0) return "$hours giờ $minutes phút";
    return "$minutes phút";
  }

  @override
  Widget build(BuildContext context) {
    final memberNames = group.members.map((m) => m.name).join(', ');
    final appIcons = group.lockedApps.map((a) => a.icon).join(' ');

    return Card(
      margin: EdgeInsets.zero, // Đặt margin = zero vì đã có padding
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        onTap: onTap,
        leading: const Icon(Icons.group, color: Colors.blueAccent, size: 30),
        title: Text(
          group.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Thành viên: ${group.members.length} ($memberNames)'),
            Row(
              children: [
                const Icon(Icons.lock, size: 14, color: Colors.red),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'Khóa ${_formatDuration(group.totalLockDuration)} | ${group.lockedApps.length} ứng dụng $appIcons',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
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
    final remaining = widget.app.timLock!.difference(DateTime.now());

    return remaining.inSeconds > 0
        ? Text(
            'Khóa trong ${formatDuration(remaining)}',
            textAlign: TextAlign.center,
          )
        : SizedBox.shrink();
  }
}



