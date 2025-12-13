class AppInfo {
  final String name;
  final String icon;
  DateTime? timLock;
  DateTime? lockLaterTime;
  String? status;

  AppInfo({
    required this.name,
    required this.icon,
    this.timLock,
    this.lockLaterTime,
    this.status = 'active',
  });

  AppInfo copyWith({
    DateTime? timLock,
    DateTime? lockLaterTime,
    String? status,
  }) {
    return AppInfo(
      name: name,
      icon: icon,
      timLock: timLock ?? this.timLock,
      lockLaterTime: lockLaterTime ?? this.lockLaterTime,
      status: status ?? this.status,
    );
  }
}

class Member {
  final String name;

  final String device;

  Member({required this.name, required this.device});
}

// class SubGroup {
//   final String subGroupId;
//   final String subGroupName;
//   final List<Member> members;
//   final List<AppInfo> lockedApps;
//   final Duration totalLockDuration;
//   final DateTime? lockStartTime;
//
//   SubGroup({
//     required this.subGroupId,
//     required this.subGroupName,
//     required this.members,
//     required this.lockedApps,
//     required this.totalLockDuration,
//     this.lockStartTime,
//   });
//
//   SubGroup copyWith({
//     String? subGroupId,
//     String? subGroupName,
//     List<Member>? members,
//     List<AppInfo>? lockedApps,
//     Duration? totalLockDuration,
//     DateTime? lockStartTime,
//   }) {
//     return SubGroup(
//       subGroupId: subGroupId ?? this.subGroupId,
//       subGroupName: subGroupName ?? this.subGroupName,
//       members: members ?? this.members,
//       lockedApps: lockedApps ?? this.lockedApps,
//       totalLockDuration: totalLockDuration ?? this.totalLockDuration,
//       lockStartTime: lockStartTime ?? this.lockStartTime,
//     );
//   }
// }

class SubGroup {
  final String subGroupId;
  final String subGroupName;
  final List<Member> members;
  final List<AppInfo> lockedApps;
  final Duration totalLockDuration;
  final DateTime? lockStartTime;

  SubGroup({
    required this.subGroupId,
    required this.subGroupName,
    required this.members,
    required this.lockedApps,
    required this.totalLockDuration,
    this.lockStartTime,
  });

  SubGroup copyWith({
    String? subGroupId,
    String? subGroupName,
    List<Member>? members,
    List<AppInfo>? lockedApps,
    Duration? totalLockDuration,
    DateTime? lockStartTime,
  }) {
    return SubGroup(
      subGroupId: subGroupId ?? this.subGroupId,
      subGroupName: subGroupName ?? this.subGroupName,
      members: members ?? this.members,
      lockedApps: lockedApps ?? this.lockedApps,
      totalLockDuration: totalLockDuration ?? this.totalLockDuration,
      lockStartTime: lockStartTime ?? this.lockStartTime,
    );
  }
}

class Group {
  final String groupId;
  final String groupName;
  final List<Member> members;
  final List<SubGroup> subGroups;

  Group({
    required this.groupId,
    required this.groupName,
    required this.members,
    required this.subGroups,
  });

  Group copyWith({
    String? groupId,
    String? groupName,
    List<Member>? members,
    List<SubGroup>? subGroups,
  }) {
    return Group(
      groupId: groupId ?? this.groupId,
      groupName: groupName ?? this.groupName,
      members: members ?? this.members,
      subGroups: subGroups ?? this.subGroups,
    );
  }
}