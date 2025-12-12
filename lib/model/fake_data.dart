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

class Group {
  final String name;
  final List<Member> members;
  final List<AppInfo> lockedApps;
  final Duration totalLockDuration;

  Group({
    required this.name,
    required this.members,
    required this.lockedApps,
    required this.totalLockDuration,
  });

  Group copyWith({
    String? name,
    List<Member>? members,
    List<AppInfo>? lockedApps,
    Duration? totalLockDuration,
  }) {
    return Group(
      name: name ?? this.name,
      members: members ?? this.members,
      lockedApps: lockedApps ?? this.lockedApps,
      totalLockDuration: totalLockDuration ?? this.totalLockDuration,
    );
  }
}