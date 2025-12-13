import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

import '../../../model/fake_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<AppInfo> _apps = [
    AppInfo(name: 'Điện thoại', icon: '📘'),
    AppInfo(name: 'Tin nhắn', icon: '📘'),
    AppInfo(name: 'Gmail', icon: '📘'),
    AppInfo(name: 'Facebook', icon: '📘'),
    AppInfo(name: 'Instagram', icon: '📷'),
    AppInfo(name: 'TikTok', icon: '🎵'),
    AppInfo(name: 'YouTube', icon: '▶️'),
    AppInfo(name: 'Zalo', icon: '💬'),
    AppInfo(name: 'Messenger', icon: '💭'),
    AppInfo(name: 'Chrome', icon: '🌐'),
    AppInfo(name: 'Game Center', icon: '🎮'),
  ];

  final excludeNames = ['Điện thoại', 'Tin nhắn', 'Gmail'];
  String? _selectedQuickTime;
  final List<Member> _members = [
    Member(name: 'Alex', device: 'Iphone 16 ProMax'),
    Member(name: 'Antony', device: 'Samsung Galaxy'),
    Member(name: 'Robin', device: 'Iphone 17 ProMax'),
    Member(name: 'Hulk', device: 'Oppo A38'),
  ];
  final selectQuickTime = ['15 phút', '30 phút', '45 phút'];
  late final List<Group> _groups = [
    Group(
      groupId: 'g001',
      groupName: 'Nhóm Học Tập',
      members: [_members[0], _members[1], _members[2]],
      subGroups: [
        SubGroup(
          subGroupId: 'sg001',
          subGroupName: 'Khóa cho Buổi Tự Học',
          members: [_members[0], _members[2]],
          lockedApps: [
            _apps[0],
            _apps[3],
          ],
          totalLockDuration: const Duration(hours: 2),
          lockStartTime: DateTime.now(),
        ),
        SubGroup(
          subGroupId: 'sg002',
          subGroupName: 'Khóa Giải Trí Đêm',
          members: [_members[1]],
          lockedApps: [
            _apps[1],
            _apps[2],
          ],
          totalLockDuration: const Duration(hours: 1),
          lockStartTime: DateTime.now().add(const Duration(hours: 5)),
        ),
      ],
    ),

    // --- NHÓM CHA 2: Nhóm Gia Đình (Group) ---
    Group(
      groupId: 'g002',
      groupName: 'Nhóm Gia Đình',
      members: [_members[0], _members[2]], // Chỉ có Hoàng và Minh
      subGroups: [
        // Nhóm Con 2.1: Giới hạn game cho Minh
        SubGroup(
          subGroupId: 'sg003',
          subGroupName: 'Giới Hạn Game',
          members: [_members[2]], // Minh
          lockedApps: [
            _apps[2], // TikTok (ví dụ là game/giải trí)
            // Thêm các ứng dụng game khác
          ],
          totalLockDuration: const Duration(minutes: 30), // Khóa 30 phút
          lockStartTime: DateTime.now().add(const Duration(minutes: 10)), // Khóa sau 10 phút
        ),
      ],
    ),
  ];

  List _selecetedApp = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selecetedApp = _apps
        .where((app) => !excludeNames.contains(app.name))
        .map((app) => app.name)
        .toList();
  }

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
    }
    setState(() {
      _selectedTime = DateTime.now();
    });
    _selecetedApp.clear();
  }

  DateTime _getLockTimeFromLabel(String label) {
    final minutes = int.parse(label.replaceAll(' phút', ''));
    return DateTime.now().add(Duration(minutes: minutes));
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
      final index = _groups.indexWhere((g) => g.groupId == updatedGroup.groupId);
      if (index != -1) {
        _groups[index] = updatedGroup;
      }
    });
  }

  void _updateSubGroupInGroup(Group parentGroup, SubGroup updatedSubGroup) {
    setState(() {
      final List<SubGroup> currentSubGroups = List.from(parentGroup.subGroups);
      final index = currentSubGroups.indexWhere((sg) => sg.subGroupId == updatedSubGroup.subGroupId);

      if (index != -1) {
        currentSubGroups[index] = updatedSubGroup; // Sửa
      } else {
        currentSubGroups.add(updatedSubGroup); // Thêm
      }

      final updatedParentGroup = parentGroup.copyWith(subGroups: currentSubGroups);
      _updateGroup(updatedParentGroup);
    });
  }

  void _deleteSubGroupFromGroup(Group parentGroup, SubGroup subGroupToDelete) {
    setState(() {
      final currentSubGroups = parentGroup.subGroups
          .where((sg) => sg.subGroupId != subGroupToDelete.subGroupId)
          .toList();

      final updatedParentGroup = parentGroup.copyWith(subGroups: currentSubGroups);
      _updateGroup(updatedParentGroup);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã xóa luật khóa "${subGroupToDelete.subGroupName}" khỏi "${parentGroup.groupName}".')),
      );
    });
  }

  void _showSubGroupEditSheet(Group parentGroup, SubGroup? subGroup) async {
    final result = await showModalBottomSheet<dynamic>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SubGroupForm(
          initialSubGroup: subGroup,
          parentGroup: parentGroup,
          availableMembers: parentGroup.members,
        );
      },
    );

    if (result == 'DELETE' && subGroup != null) {
      _deleteSubGroupFromGroup(parentGroup, subGroup);
    } else if (result is SubGroup) {
      _updateSubGroupInGroup(parentGroup, result);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã lưu luật khóa "${result.subGroupName}" thành công!')),
      );
    }
  }

  void _addGroup(Group newGroup) {
    setState(() {
      _groups.add(newGroup);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã tạo Group "${newGroup.groupName}" thành công!'),
        ),
      );
    });
  }

// --- HÀM MỚI: Mở BottomSheet/Form tạo Group ---
  void _showGroupCreationSheet() async {
    final Group? result = await showModalBottomSheet<Group>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        // GroupForm là widget chúng ta sẽ tạo ở bước 3
        return GroupForm(
          availableMembers: _members, // Truyền tất cả thành viên có sẵn
        );
      },
    );

    if (result != null) {
      _addGroup(result);
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

            Wrap(
              alignment: WrapAlignment.spaceAround,
              spacing: 10,
              children: selectQuickTime.map((label) {
                final isSelected = _selectedQuickTime == label;

                return ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedQuickTime = label;
                      _selectedTime = _getLockTimeFromLabel(label);
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    isSelected ? Colors.blue : Colors.grey.shade300,
                    foregroundColor:
                    isSelected ? Colors.white : Colors.black,
                    elevation: isSelected ? 4 : 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(label),
                );
              }).toList(),
            ),

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
                  onPressed:
                    _showGroupCreationSheet,
                  icon: const Icon(Icons.group_add, size: 20),
                  label: const Text('Thêm Group'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _groups.isEmpty
                ? const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: Text(
                  'Chưa có Group nào được tạo.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54),
                ),
              ),
            )
                : Column(
              children: _groups.map((group) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: GroupExpansionCard(
                    group: group,
                    onSubGroupEdit: (subGroup) => _showSubGroupEditSheet(group, subGroup),
                    onAddSubGroup: () => _showSubGroupEditSheet(group, null),
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

class GroupExpansionCard extends StatelessWidget {
  final Group group;
  final Function(SubGroup) onSubGroupEdit; // Sửa SubGroup đã tồn tại
  final VoidCallback onAddSubGroup;          // Thêm SubGroup mới

  const GroupExpansionCard({
    super.key,
    required this.group,
    required this.onSubGroupEdit,
    required this.onAddSubGroup,
  });

  String _formatDuration(Duration d) {
    int hours = d.inHours;
    int minutes = d.inMinutes.remainder(60);
    if (hours > 0) return "$hours giờ $minutes phút";
    if (minutes > 0) return "$minutes phút";
    return "0 phút";
  }

  String _formatLockStartTime(BuildContext context, DateTime? startTime) {
    if (startTime == null) {
      return 'Khóa ngay lập tức';
    }

    final now = DateTime.now();
    final difference = startTime.difference(now);

    if (difference.isNegative || difference.inSeconds < -5) { // Quá khứ
      return 'Đã bắt đầu khóa';
    }

    final formattedTime = TimeOfDay.fromDateTime(startTime).format(context);

    if (difference.inDays == 0) {
      final hours = difference.inHours;
      final minutes = difference.inMinutes.remainder(60);
      String countdown = '';
      if (hours > 0) countdown += '$hours giờ ';
      if (minutes > 0) countdown += '$minutes phút';

      if (countdown.isNotEmpty) {
        return 'Sau $countdown ($formattedTime)';
      }
    }

    final formattedDate = DateFormat('dd/MM/yyyy').format(startTime);
    return 'Lúc $formattedTime, $formattedDate';
  }

  @override
  Widget build(BuildContext context) {
    final memberNames = group.members.map((m) => m.name).join(', ');
    final totalLockedAppsCount = group.subGroups.fold<int>(
      0,
          (sum, subGroup) => sum + subGroup.lockedApps.length,
    );

    return Card(
      margin: EdgeInsets.zero,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ExpansionTile(
        leading: const Icon(Icons.group, color: Colors.blueAccent, size: 30),
        title: Text(
          group.groupName,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Thành viên: ${group.members.length} ($memberNames)', overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.bookmarks_outlined, size: 14, color: Colors.green),
                const SizedBox(width: 4),
                Text(
                  '${group.subGroups.length} Luật khóa | ',
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
                const Icon(Icons.lock, size: 14, color: Colors.red),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    '$totalLockedAppsCount Ứng dụng',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                ),
              ],
            ),
          ],
        ),

        childrenPadding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Danh sách Luật khóa (${group.subGroups.length})',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextButton.icon(
                  onPressed: onAddSubGroup, // Gọi hàm thêm mới
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Thêm luật'),
                ),
              ],
            ),
          ),

          if (group.subGroups.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text('Không có luật khóa nào được định nghĩa.'),
            ),

          ...group.subGroups.map((subGroup) {
            return Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.security, size: 18, color: Colors.indigo),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                '${subGroup.subGroupName}',
                                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit, size: 16, color: Colors.grey),
                              onPressed: () => onSubGroupEdit(subGroup), // Gọi hàm sửa
                            ),
                          ],
                        ),
                        Text(
                          'Áp dụng cho: ${subGroup.members.map((m) => m.name).join(', ')}',
                          style: const TextStyle(fontSize: 12, color: Colors.black87),
                        ),
                        Text(
                          'Thời điểm bắt đầu: ${_formatLockStartTime(context, subGroup.lockStartTime)}',
                          style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
                        ),
                        Text(
                          'Thời lượng khóa: ${_formatDuration(subGroup.totalLockDuration)}',
                          style: const TextStyle(fontSize: 12, color: Colors.black87),
                        ),
                        Text(
                          'Ứng dụng: ${subGroup.lockedApps.map((a) => a.name).join(', ')}',
                          style: const TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                        const SizedBox(height: 4),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}


class SubGroupForm extends StatefulWidget {
  final SubGroup? initialSubGroup;
  final Group parentGroup;
  final List<Member> availableMembers;

  const SubGroupForm({
    super.key,
    this.initialSubGroup,
    required this.parentGroup,
    required this.availableMembers,
  });

  @override
  State<SubGroupForm> createState() => _SubGroupFormState();
}

class _SubGroupFormState extends State<SubGroupForm> {
  late String _subGroupName;
  late List<Member> _selectedMembers;
  late List<AppInfo> _selectedApps;
  late Duration _totalLockDuration;
  late DateTime? _lockStartTime; // Thêm biến cho thời điểm bắt đầu khóa

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _subGroupName = widget.initialSubGroup?.subGroupName ?? 'Luật Khóa Mới';
    _selectedMembers = List.from(widget.initialSubGroup?.members ?? []);
    _selectedApps = List.from(widget.initialSubGroup?.lockedApps ?? []);
    _totalLockDuration = widget.initialSubGroup?.totalLockDuration ?? const Duration(hours: 1);
    _lockStartTime = widget.initialSubGroup?.lockStartTime; // Khởi tạo thời gian bắt đầu
  }

  // --- HÀM CHỌN THỜI LƯỢNG KHÓA (Duration) ---
  void _selectLockDuration() async {
    // Để đơn giản, sử dụng Dialog thủ công để nhập Giờ/Phút
    // Trong môi trường thực tế, bạn nên dùng Duration Picker
    int initialHours = _totalLockDuration.inHours;
    int initialMinutes = _totalLockDuration.inMinutes.remainder(60);

    final result = await showDialog<Duration>(
      context: context,
      builder: (ctx) => _DurationPickerDialog(
        initialHours: initialHours,
        initialMinutes: initialMinutes,
      ),
    );

    if (result != null) {
      setState(() {
        _totalLockDuration = result;
      });
    }
  }

  // --- HÀM CHỌN THỜI ĐIỂM BẮT ĐẦU KHÓA (DateTime) ---
  void _selectLockStartTime() async {
    final now = DateTime.now();
    // 1. Chọn ngày
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _lockStartTime ?? now,
      firstDate: now.subtract(const Duration(days: 1)),
      lastDate: now.add(const Duration(days: 365)),
    );

    if (pickedDate == null) return;

    // 2. Chọn giờ
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_lockStartTime ?? now),
    );

    if (pickedTime == null) return;

    // Kết hợp Ngày và Giờ
    setState(() {
      _lockStartTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
  }

  // Hàm định dạng Duration để hiển thị
  String _formatDurationForDisplay(Duration d) {
    int hours = d.inHours;
    int minutes = d.inMinutes.remainder(60);
    if (hours > 0) return "$hours giờ $minutes phút";
    return "$minutes phút";
  }

  // Hàm định dạng DateTime để hiển thị
  String _formatDateTimeForDisplay(DateTime? dt) {
    if (dt == null) return "Khóa ngay lập tức";
    final formattedTime = TimeOfDay.fromDateTime(dt).format(context);
    final formattedDate = DateFormat('dd/MM/yyyy').format(dt);
    return "$formattedTime - $formattedDate";
  }


  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final SubGroup resultSubGroup = SubGroup(
        subGroupId: widget.initialSubGroup?.subGroupId ?? DateTime.now().millisecondsSinceEpoch.toString(),
        subGroupName: _subGroupName,
        members: _selectedMembers,
        lockedApps: _selectedApps,
        totalLockDuration: _totalLockDuration,
        lockStartTime: _lockStartTime, // LƯU THỜI GIAN ĐÃ CHỌN
      );

      Navigator.pop(context, resultSubGroup);
    }
  }

  void _deleteSubGroup() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận Xóa'),
        content: const Text('Bạn có chắc chắn muốn xóa luật khóa này không?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Hủy')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context, 'DELETE');
            },
            child: const Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialSubGroup != null;

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 20,
        left: 20,
        right: 20,
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEditing ? 'Sửa Luật Khóa' : 'Tạo Luật Khóa Mới',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Divider(),

              TextFormField(
                initialValue: _subGroupName,
                decoration: const InputDecoration(labelText: 'Tên Luật Khóa'),
                validator: (value) => value!.isEmpty ? 'Vui lòng nhập tên' : null,
                onSaved: (value) => _subGroupName = value!,
              ),

              const SizedBox(height: 20),

              // 1. CHỈNH SỬA THỜI LƯỢNG KHÓA
              ListTile(
                title: const Text('Thời lượng khóa (Duration)'),
                subtitle: Text(_formatDurationForDisplay(_totalLockDuration)),
                trailing: const Icon(Icons.timer),
                onTap: _selectLockDuration,
              ),

              // 2. CHỈNH SỬA THỜI ĐIỂM BẮT ĐẦU
              ListTile(
                title: const Text('Thời điểm bắt đầu khóa'),
                subtitle: Text(_formatDateTimeForDisplay(_lockStartTime)),
                trailing: const Icon(Icons.calendar_month),
                onTap: _selectLockStartTime,
              ),

              const SizedBox(height: 20),

              // 3. Chọn Thành viên
              const Text('Thành viên áp dụng:', style: TextStyle(fontWeight: FontWeight.bold)),
              Wrap(
                spacing: 8.0,
                children: widget.availableMembers.map((member) {
                  final isSelected = _selectedMembers.any((m) => m.name == member.name);
                  return FilterChip(
                    label: Text(member.name),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedMembers.add(member);
                        } else {
                          _selectedMembers.removeWhere((m) => m.name == member.name);
                        }
                      });
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),

              // 4. Chọn Ứng dụng khóa
              const Text('Ứng dụng bị khóa:', style: TextStyle(fontWeight: FontWeight.bold)),
              Wrap(
                spacing: 8.0,
                children: _apps.map((app) {
                  final isSelected = _selectedApps.any((a) => a.name == app.name);
                  return FilterChip(
                    label: Text(app.name),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedApps.add(app);
                        } else {
                          _selectedApps.removeWhere((a) => a.name == app.name);
                        }
                      });
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 30),

              // Nút Hành động
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (isEditing)
                    TextButton.icon(
                      onPressed: _deleteSubGroup,
                      icon: const Icon(Icons.delete_forever, color: Colors.red),
                      label: const Text('Xóa luật này', style: TextStyle(color: Colors.red)),
                    ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Hủy'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _saveForm,
                        child: const Text('Lưu'),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // NOTE: Giả định danh sách toàn bộ ứng dụng có sẵn (cần được định nghĩa toàn cục)
  // Đây là ví dụ demo:
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
}

class _DurationPickerDialog extends StatefulWidget {
  final int initialHours;
  final int initialMinutes;

  const _DurationPickerDialog({
    required this.initialHours,
    required this.initialMinutes,
  });

  @override
  State<_DurationPickerDialog> createState() => __DurationPickerDialogState();
}

class __DurationPickerDialogState extends State<_DurationPickerDialog> {
  late int _hours;
  late int _minutes;

  @override
  void initState() {
    super.initState();
    _hours = widget.initialHours;
    _minutes = widget.initialMinutes;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Chọn Thời Lượng Khóa'),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Giờ
          DropdownButton<int>(
            value: _hours,
            items: List.generate(24, (i) => i).map((h) {
              return DropdownMenuItem(value: h, child: Text('$h Giờ'));
            }).toList(),
            onChanged: (h) {
              if (h != null) setState(() => _hours = h);
            },
          ),
          // Phút
          DropdownButton<int>(
            value: _minutes,
            items: List.generate(12, (i) => i * 5).map((m) {
              return DropdownMenuItem(value: m, child: Text('$m Phút'));
            }).toList(),
            onChanged: (m) {
              if (m != null) setState(() => _minutes = m);
            },
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
        ElevatedButton(
          onPressed: () {
            if (_hours == 0 && _minutes == 0) {
              // Yêu cầu thời lượng > 0
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Thời lượng phải lớn hơn 0 phút.')),
              );
              return;
            }
            Navigator.pop(context, Duration(hours: _hours, minutes: _minutes));
          },
          child: const Text('Chọn'),
        ),
      ],
    );
  }
}

class GroupForm extends StatefulWidget {
  final List<Member> availableMembers;

  const GroupForm({
    super.key,
    required this.availableMembers,
  });

  @override
  State<GroupForm> createState() => _GroupFormState();
}

class _GroupFormState extends State<GroupForm> {
  final _formKey = GlobalKey<FormState>();
  String _groupName = '';
  List<Member> _selectedMembers = [];

  @override
  void initState() {
    super.initState();
    // Bắt đầu với danh sách thành viên rỗng
    _selectedMembers = [];
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Tạo Group mới với ID duy nhất và SubGroup rỗng
      final Group newGroup = Group(
        groupId: DateTime.now().millisecondsSinceEpoch.toString(),
        groupName: _groupName,
        members: _selectedMembers,
        subGroups: const [], // Nhóm mới chưa có luật khóa (subGroups)
      );

      // Trả về Group mới
      Navigator.pop(context, newGroup);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 20,
        left: 20,
        right: 20,
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tạo Group (Nhóm Cha) Mới',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Divider(),

              // 1. Tên Group
              TextFormField(
                decoration: const InputDecoration(labelText: 'Tên Group'),
                validator: (value) => value!.isEmpty ? 'Vui lòng nhập tên Group' : null,
                onSaved: (value) => _groupName = value!,
              ),

              const SizedBox(height: 20),

              // 2. Chọn Thành viên cho Group Cha
              const Text('Chọn Thành viên:', style: TextStyle(fontWeight: FontWeight.bold)),
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: widget.availableMembers.map((member) {
                  final isSelected = _selectedMembers.any((m) => m.name == member.name);
                  return FilterChip(
                    label: Text(member.name),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedMembers.add(member);
                        } else {
                          _selectedMembers.removeWhere((m) => m.name == member.name);
                        }
                      });
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 30),

              // Nút Lưu/Hủy
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Hủy'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _saveForm,
                    child: const Text('Tạo Group'),
                  ),
                ],
              ),
            ],
          ),
        ),
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
