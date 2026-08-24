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
    this.canChangeEmail = false,
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

  /// 이메일 변경이 가능한 계정인지(SPEC-0024 R6). 서버가 준 capability를 그대로
  /// 쓴다 — 앱이 provider로 판정하지 않으므로 규칙이 바뀌어도 앱을 고칠 필요가
  /// 없다. 기본이 거짓인 이유는 진입점을 **숨기는** 쪽이 안전하기 때문이다.
  final bool canChangeEmail;
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
    canChangeEmail: json['canChangeEmail'] as bool? ?? false,
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
    'canChangeEmail': canChangeEmail,
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
      other.canChangeEmail == canChangeEmail &&
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
    canChangeEmail,
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
