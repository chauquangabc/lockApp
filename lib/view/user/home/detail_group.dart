import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../../../model/fake_data.dart';
// Đảm bảo import các models và sub-screens (MemberSelectionScreen, AppSelectionScreen, _showDurationPicker)

// *****************************************************************
// GIẢ ĐỊNH: CÁC BIẾN VÀ HÀM NÀY ĐÃ ĐƯỢC KHAI BÁO HOẶC IMPORT TỪ TRƯỚC
// *****************************************************************
// final List<AppInfo> _apps = [...];
// final List<Member> _members = [...];
// Future<Duration?> _showDurationPicker(BuildContext context, Duration current) => ...;
// *****************************************************************



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

class MemberSelectionScreen extends StatefulWidget {
  final List<Member> allMembers;
  final List<Member> initialSelectedMembers;

  const MemberSelectionScreen({
    super.key,
    required this.allMembers,
    required this.initialSelectedMembers,
  });

  @override
  State<MemberSelectionScreen> createState() => _MemberSelectionScreenState();
}

class _MemberSelectionScreenState extends State<MemberSelectionScreen> {
  late List<Member> _selectedMembers;

  @override
  void initState() {
    super.initState();
    // Tạo bản sao để chỉnh sửa
    _selectedMembers = List.from(widget.initialSelectedMembers);
  }

  void _toggleMember(Member member) {
    setState(() {
      // Cần định nghĩa operator == cho Member để kiểm tra chính xác
      if (_selectedMembers.any((m) => m.name == member.name)) {
        _selectedMembers.removeWhere((m) => m.name == member.name);
      } else {
        _selectedMembers.add(member);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chọn Thành viên'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () => Navigator.pop(context, _selectedMembers),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: widget.allMembers.length,
        itemBuilder: (context, index) {
          final member = widget.allMembers[index];
          final isSelected = _selectedMembers.any((m) => m.name == member.name);
          return CheckboxListTile(
            title: Text(member.name),
            subtitle: Text(member.device),
            value: isSelected,
            onChanged: (_) => _toggleMember(member),
          );
        },
      ),
    );
  }
}

// ===================================================
// SUB-SCREEN 2: CHỌN ỨNG DỤNG KHÓA
// ===================================================

class AppSelectionScreen extends StatefulWidget {
  final List<AppInfo> allApps;
  final List<AppInfo> initialLockedApps;

  const AppSelectionScreen({
    super.key,
    required this.allApps,
    required this.initialLockedApps,
  });

  @override
  State<AppSelectionScreen> createState() => _AppSelectionScreenState();
}

class _AppSelectionScreenState extends State<AppSelectionScreen> {
  late List<AppInfo> _appsWithLockStatus;

  @override
  void initState() {
    super.initState();

    // Tạo map để tra cứu nhanh các ứng dụng đã bị khóa trước đó
    final lockedAppMap = {for (var app in widget.initialLockedApps) app.name: app};

    // Khởi tạo danh sách ứng dụng với trạng thái khóa hiện tại
    _appsWithLockStatus = widget.allApps.map((app) {
      if (lockedAppMap.containsKey(app.name)) {
        // Nếu đã bị khóa, sử dụng thông tin khóa cũ
        return lockedAppMap[app.name]!;
      }
      // Nếu chưa bị khóa, mặc định là active
      return app.copyWith(status: 'active');
    }).toList();
  }

  void _toggleAppLock(int index, bool? isLocked) {
    setState(() {
      _appsWithLockStatus[index] = _appsWithLockStatus[index].copyWith(
        status: isLocked == true ? 'lockNow' : 'active',
        timLock: isLocked == true ? DateTime.now().add(const Duration(hours: 1)) : null, // Gán thời gian khóa tạm
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chọn Ứng dụng Khóa'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              // Trả về chỉ các ứng dụng đã được đánh dấu là "lockNow"
              final List<AppInfo> finalLockedApps =
              _appsWithLockStatus.where((app) => app.status == 'lockNow').toList();
              Navigator.pop(context, finalLockedApps);
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _appsWithLockStatus.length,
        itemBuilder: (context, index) {
          final app = _appsWithLockStatus[index];
          final isLocked = app.status == 'lockNow';
          return CheckboxListTile(
            secondary: Text(app.icon, style: const TextStyle(fontSize: 24)),
            title: Text(app.name),
            subtitle: Text(isLocked ? 'Đã chọn khóa' : 'Không khóa'),
            value: isLocked,
            onChanged: (value) => _toggleAppLock(index, value),
          );
        },
      ),
    );
  }
}

// ===================================================
// SUB-SCREEN 3: CHỌN THỜI GIAN (Dùng Dialog)
// ===================================================

Future<Duration?> _showDurationPicker(BuildContext context, Duration current) async {
  int currentMinutes = current.inMinutes;
  int? selectedMinutes = await showDialog<int>(
    context: context,
    builder: (BuildContext context) {
      int tempMinutes = currentMinutes;
      return AlertDialog(
        title: const Text('Chọn thời gian khóa'),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            String formatDuration(Duration d) {
              int hours = d.inHours;
              int minutes = d.inMinutes.remainder(60);
              if (hours > 0) return "$hours giờ $minutes phút";
              return "$minutes phút";
            }
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(formatDuration(Duration(minutes: tempMinutes)), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Slider(
                  value: tempMinutes.toDouble(),
                  min: 15,
                  max: 300, // Tối đa 5 giờ
                  divisions: (300 - 15) ~/ 15, // Bước nhảy 15 phút
                  label: formatDuration(Duration(minutes: tempMinutes)),
                  onChanged: (double value) {
                    setState(() {
                      tempMinutes = (value / 15).round() * 15; // Ép về bước nhảy 15
                    });
                  },
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, tempMinutes),
            child: const Text('Chọn'),
          ),
        ],
      );
    },
  );
  if (selectedMinutes != null) {
    return Duration(minutes: selectedMinutes);
  }
  return null;
}


class GroupDetailScreen extends StatefulWidget {
  // Bắt buộc phải có Group để chỉnh sửa
  final Group group;

  const GroupDetailScreen({
    super.key,
    required this.group,
  });

  @override
  State<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen> {
  // Biến tạm thời để lưu trữ các thay đổi
  late Group _tempGroup;
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Khởi tạo _tempGroup bằng cách COPY dữ liệu của widget.group
    _tempGroup = widget.group.copyWith();
    _nameController.text = _tempGroup.name;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  // --- HÀM TIỆN ÍCH ---

  String _formatDuration(Duration d) {
    int hours = d.inHours;
    int minutes = d.inMinutes.remainder(60);
    if (hours > 0) return "$hours giờ $minutes phút";
    return "$minutes phút";
  }

  Widget _buildDetailTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Colors.indigo),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Text(subtitle),
          trailing: const Icon(Icons.chevron_right),
          onTap: onTap,
        ),
        const Divider(height: 1),
      ],
    );
  }

  // --- HÀM XỬ LÝ CHỌN DỮ LIỆU ---

  void _selectMembers() async {
    // Logic điều hướng đến MemberSelectionScreen (sử dụng _members global)
    final List<Member>? selectedMembers = await Navigator.push<List<Member>>(
      context,
      MaterialPageRoute(
        builder: (context) => MemberSelectionScreen(
          allMembers: _members, // Dữ liệu thành viên có sẵn
          initialSelectedMembers: _tempGroup.members,
        ),
      ),
    );

    if (selectedMembers != null) {
      setState(() {
        _tempGroup = _tempGroup.copyWith(members: selectedMembers);
      });
    }
  }

  void _selectLockedApps() async {
    // Logic điều hướng đến AppSelectionScreen (sử dụng _apps global)
    final List<AppInfo>? selectedApps = await Navigator.push<List<AppInfo>>(
      context,
      MaterialPageRoute(
        builder: (context) => AppSelectionScreen(
          allApps: _apps, // Dữ liệu ứng dụng có sẵn
          initialLockedApps: _tempGroup.lockedApps,
        ),
      ),
    );

    if (selectedApps != null) {
      setState(() {
        _tempGroup = _tempGroup.copyWith(lockedApps: selectedApps);
      });
    }
  }

  void _selectLockDuration() async {
    // Logic mở Duration Picker (sử dụng _showDurationPicker)
    final Duration? duration = await _showDurationPicker(context, _tempGroup.totalLockDuration);
    if (duration != null) {
      setState(() {
        _tempGroup = _tempGroup.copyWith(totalLockDuration: duration);
      });
    }
  }

  // --- HÀM LƯU DỮ LIỆU ---

  void _saveGroup() {
    if (_formKey.currentState!.validate()) {
      // 1. Cập nhật tên Group cuối cùng vào bản sao
      _tempGroup = _tempGroup.copyWith(name: _nameController.text.trim());

      // 2. Kiểm tra các điều kiện bắt buộc
      if (_tempGroup.members.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vui lòng chọn ít nhất một Thành viên.')),
        );
        return;
      }
      if (_tempGroup.lockedApps.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vui lòng chọn ít nhất một Ứng dụng để Khóa.')),
        );
        return;
      }

      // 3. Trả về đối tượng Group đã chỉnh sửa (Kiểu Group)
      Navigator.pop(context, _tempGroup);
    }
  }

  // --- HÀM XÓA GROUP ---
  void _deleteGroup() async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận Xóa'),
          content: Text('Bạn có chắc chắn muốn xóa Group "${_tempGroup.name}" không?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Hủy'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Xóa'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      // Trả về null để báo hiệu cho màn hình cha biết Group đã bị xóa
      // Màn hình cha sẽ xử lý việc xóa khỏi danh sách _groups.
      Navigator.pop(context, null);
    }
  }


  @override
  Widget build(BuildContext context) {
    final memberNames = _tempGroup.members.map((m) => m.name).join(', ');
    final appIcons = _tempGroup.lockedApps.map((a) => a.icon).join(' ');

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Chỉnh sửa Group: ${_tempGroup.name}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: _deleteGroup,
            tooltip: 'Xóa Group',
          ),
          IconButton(
            icon: const Icon(Icons.check, color: Colors.blue),
            onPressed: _saveGroup,
            tooltip: 'Lưu chỉnh sửa',
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            // 1. Tên Group
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Tên Group',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.group_outlined),
              ),
              validator: (value) {
                if (value == null || value.isEmpty || value.trim().isEmpty) {
                  return 'Tên Group không được để trống';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // 2. Thành viên được chọn
            _buildDetailTile(
              title: 'Thành viên (${_tempGroup.members.length})',
              subtitle: _tempGroup.members.isEmpty
                  ? 'Chưa chọn thành viên nào'
                  : memberNames,
              icon: Icons.people,
              onTap: _selectMembers,
            ),

            // 3. Ứng dụng bị khóa
            _buildDetailTile(
              title: 'Ứng dụng bị khóa (${_tempGroup.lockedApps.length})',
              subtitle: _tempGroup.lockedApps.isEmpty
                  ? 'Chưa khóa ứng dụng nào'
                  : appIcons,
              icon: Icons.lock,
              onTap: _selectLockedApps,
            ),

            // 4. Khóa trong bao lâu (Total Duration)
            _buildDetailTile(
              title: 'Khóa trong bao lâu',
              subtitle: _formatDuration(_tempGroup.totalLockDuration),
              icon: Icons.timer,
              onTap: _selectLockDuration,
            ),

            const SizedBox(height: 40),

            ElevatedButton.icon(
              onPressed: _saveGroup,
              icon: const Icon(Icons.save),
              label: const Text('Lưu chỉnh sửa'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
            const SizedBox(height: 10),
            TextButton.icon(
              onPressed: _deleteGroup,
              icon: const Icon(Icons.delete_forever, color: Colors.red),
              label: const Text('Xóa Group này', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }
}