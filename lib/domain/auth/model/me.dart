/// The authenticated account, mapped from the `me` query (schema `Me`). Pure
/// domain model — no transport concerns. Fetched after login because the login
/// payload carries no user (spec §4.2/§6.2).
enum MemberStatus { active, suspended, unknown }

class Me {
  const Me({
    required this.id,
    required this.email,
    required this.nickname,
    this.profileImageUrl,
    this.status = MemberStatus.active,
    this.emailVerified = false,
    this.roles = const <String>[],
    this.permissions = const <String>[],
    this.createdAt = '',
  });

  final String id;
  final String email;
  final String nickname;
  final String? profileImageUrl;
  final MemberStatus status;
  final bool emailVerified;
  final List<String> roles;
  final List<String> permissions;
  final String createdAt;

  factory Me.fromJson(Map<String, dynamic> json) => Me(
    id: json['id'] as String,
    email: json['email'] as String,
    nickname: json['nickname'] as String,
    profileImageUrl: json['profileImageUrl'] as String?,
    status: _statusFromWire(json['status'] as String?),
    emailVerified: json['emailVerified'] as bool? ?? false,
    roles: (json['roles'] as List<dynamic>? ?? const <dynamic>[])
        .map((dynamic e) => e as String)
        .toList(),
    permissions: (json['permissions'] as List<dynamic>? ?? const <dynamic>[])
        .map((dynamic e) => e as String)
        .toList(),
    createdAt: json['createdAt'] as String? ?? '',
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'email': email,
    'nickname': nickname,
    'profileImageUrl': profileImageUrl,
    'status': _statusToWire(status),
    'emailVerified': emailVerified,
    'roles': roles,
    'permissions': permissions,
    'createdAt': createdAt,
  };

  static MemberStatus _statusFromWire(String? wire) => switch (wire) {
    'ACTIVE' => MemberStatus.active,
    'SUSPENDED' => MemberStatus.suspended,
    _ => MemberStatus.unknown,
  };

  static String _statusToWire(MemberStatus status) => switch (status) {
    MemberStatus.active => 'ACTIVE',
    MemberStatus.suspended => 'SUSPENDED',
    MemberStatus.unknown => 'UNKNOWN',
  };

  @override
  bool operator ==(Object other) =>
      other is Me &&
      other.id == id &&
      other.email == email &&
      other.nickname == nickname &&
      other.profileImageUrl == profileImageUrl &&
      other.status == status &&
      other.emailVerified == emailVerified &&
      _listEquals(other.roles, roles) &&
      _listEquals(other.permissions, permissions) &&
      other.createdAt == createdAt;

  @override
  int get hashCode => Object.hash(
    id,
    email,
    nickname,
    profileImageUrl,
    status,
    emailVerified,
    Object.hashAll(roles),
    Object.hashAll(permissions),
    createdAt,
  );
}

bool _listEquals(List<String> a, List<String> b) {
  if (a.length != b.length) return false;
  for (int i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
