// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, unused_element
import '../../../common/network/shared_schema.graphql.dart';

class Input$CreatePostInput {
  factory Input$CreatePostInput({
    required Enum$TargetCategory category,
    String? spotId,
    required List<String> tags,
    required String title,
    required String body,
    required List<String> photoKeys,
  }) => Input$CreatePostInput._({
    r'category': category,
    if (spotId != null) r'spotId': spotId,
    r'tags': tags,
    r'title': title,
    r'body': body,
    r'photoKeys': photoKeys,
  });

  Input$CreatePostInput._(this._$data);

  factory Input$CreatePostInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$category = data['category'];
    result$data['category'] = fromJson$Enum$TargetCategory(
      (l$category as String),
    );
    if (data.containsKey('spotId')) {
      final l$spotId = data['spotId'];
      result$data['spotId'] = (l$spotId as String?);
    }
    final l$tags = data['tags'];
    result$data['tags'] = (l$tags as List<dynamic>)
        .map((e) => (e as String))
        .toList();
    final l$title = data['title'];
    result$data['title'] = (l$title as String);
    final l$body = data['body'];
    result$data['body'] = (l$body as String);
    final l$photoKeys = data['photoKeys'];
    result$data['photoKeys'] = (l$photoKeys as List<dynamic>)
        .map((e) => (e as String))
        .toList();
    return Input$CreatePostInput._(result$data);
  }

  Map<String, dynamic> _$data;

  Enum$TargetCategory get category =>
      (_$data['category'] as Enum$TargetCategory);

  String? get spotId => (_$data['spotId'] as String?);

  List<String> get tags => (_$data['tags'] as List<String>);

  String get title => (_$data['title'] as String);

  String get body => (_$data['body'] as String);

  List<String> get photoKeys => (_$data['photoKeys'] as List<String>);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$category = category;
    result$data['category'] = toJson$Enum$TargetCategory(l$category);
    if (_$data.containsKey('spotId')) {
      final l$spotId = spotId;
      result$data['spotId'] = l$spotId;
    }
    final l$tags = tags;
    result$data['tags'] = l$tags.map((e) => e).toList();
    final l$title = title;
    result$data['title'] = l$title;
    final l$body = body;
    result$data['body'] = l$body;
    final l$photoKeys = photoKeys;
    result$data['photoKeys'] = l$photoKeys.map((e) => e).toList();
    return result$data;
  }

  CopyWith$Input$CreatePostInput<Input$CreatePostInput> get copyWith =>
      CopyWith$Input$CreatePostInput(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$CreatePostInput || runtimeType != other.runtimeType) {
      return false;
    }
    final l$category = category;
    final lOther$category = other.category;
    if (l$category != lOther$category) {
      return false;
    }
    final l$spotId = spotId;
    final lOther$spotId = other.spotId;
    if (_$data.containsKey('spotId') != other._$data.containsKey('spotId')) {
      return false;
    }
    if (l$spotId != lOther$spotId) {
      return false;
    }
    final l$tags = tags;
    final lOther$tags = other.tags;
    if (l$tags.length != lOther$tags.length) {
      return false;
    }
    for (int i = 0; i < l$tags.length; i++) {
      final l$tags$entry = l$tags[i];
      final lOther$tags$entry = lOther$tags[i];
      if (l$tags$entry != lOther$tags$entry) {
        return false;
      }
    }
    final l$title = title;
    final lOther$title = other.title;
    if (l$title != lOther$title) {
      return false;
    }
    final l$body = body;
    final lOther$body = other.body;
    if (l$body != lOther$body) {
      return false;
    }
    final l$photoKeys = photoKeys;
    final lOther$photoKeys = other.photoKeys;
    if (l$photoKeys.length != lOther$photoKeys.length) {
      return false;
    }
    for (int i = 0; i < l$photoKeys.length; i++) {
      final l$photoKeys$entry = l$photoKeys[i];
      final lOther$photoKeys$entry = lOther$photoKeys[i];
      if (l$photoKeys$entry != lOther$photoKeys$entry) {
        return false;
      }
    }
    return true;
  }

  @override
  int get hashCode {
    final l$category = category;
    final l$spotId = spotId;
    final l$tags = tags;
    final l$title = title;
    final l$body = body;
    final l$photoKeys = photoKeys;
    return Object.hashAll([
      l$category,
      _$data.containsKey('spotId') ? l$spotId : const {},
      Object.hashAll(l$tags.map((v) => v)),
      l$title,
      l$body,
      Object.hashAll(l$photoKeys.map((v) => v)),
    ]);
  }
}

abstract class CopyWith$Input$CreatePostInput<TRes> {
  factory CopyWith$Input$CreatePostInput(
    Input$CreatePostInput instance,
    TRes Function(Input$CreatePostInput) then,
  ) = _CopyWithImpl$Input$CreatePostInput;

  factory CopyWith$Input$CreatePostInput.stub(TRes res) =
      _CopyWithStubImpl$Input$CreatePostInput;

  TRes call({
    Enum$TargetCategory? category,
    String? spotId,
    List<String>? tags,
    String? title,
    String? body,
    List<String>? photoKeys,
  });
}

class _CopyWithImpl$Input$CreatePostInput<TRes>
    implements CopyWith$Input$CreatePostInput<TRes> {
  _CopyWithImpl$Input$CreatePostInput(this._instance, this._then);

  final Input$CreatePostInput _instance;

  final TRes Function(Input$CreatePostInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? category = _undefined,
    Object? spotId = _undefined,
    Object? tags = _undefined,
    Object? title = _undefined,
    Object? body = _undefined,
    Object? photoKeys = _undefined,
  }) => _then(
    Input$CreatePostInput._({
      ..._instance._$data,
      if (category != _undefined && category != null)
        'category': (category as Enum$TargetCategory),
      if (spotId != _undefined) 'spotId': (spotId as String?),
      if (tags != _undefined && tags != null) 'tags': (tags as List<String>),
      if (title != _undefined && title != null) 'title': (title as String),
      if (body != _undefined && body != null) 'body': (body as String),
      if (photoKeys != _undefined && photoKeys != null)
        'photoKeys': (photoKeys as List<String>),
    }),
  );
}

class _CopyWithStubImpl$Input$CreatePostInput<TRes>
    implements CopyWith$Input$CreatePostInput<TRes> {
  _CopyWithStubImpl$Input$CreatePostInput(this._res);

  TRes _res;

  call({
    Enum$TargetCategory? category,
    String? spotId,
    List<String>? tags,
    String? title,
    String? body,
    List<String>? photoKeys,
  }) => _res;
}

class Input$EditPostInput {
  factory Input$EditPostInput({
    required String postId,
    required String title,
    required String body,
    List<String>? photoKeys,
    Enum$TargetCategory? category,
    bool? changeSpot,
    String? spotId,
    List<String>? tags,
  }) => Input$EditPostInput._({
    r'postId': postId,
    r'title': title,
    r'body': body,
    if (photoKeys != null) r'photoKeys': photoKeys,
    if (category != null) r'category': category,
    if (changeSpot != null) r'changeSpot': changeSpot,
    if (spotId != null) r'spotId': spotId,
    if (tags != null) r'tags': tags,
  });

  Input$EditPostInput._(this._$data);

  factory Input$EditPostInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$postId = data['postId'];
    result$data['postId'] = (l$postId as String);
    final l$title = data['title'];
    result$data['title'] = (l$title as String);
    final l$body = data['body'];
    result$data['body'] = (l$body as String);
    if (data.containsKey('photoKeys')) {
      final l$photoKeys = data['photoKeys'];
      result$data['photoKeys'] = (l$photoKeys as List<dynamic>?)
          ?.map((e) => (e as String))
          .toList();
    }
    if (data.containsKey('category')) {
      final l$category = data['category'];
      result$data['category'] = l$category == null
          ? null
          : fromJson$Enum$TargetCategory((l$category as String));
    }
    if (data.containsKey('changeSpot')) {
      final l$changeSpot = data['changeSpot'];
      result$data['changeSpot'] = (l$changeSpot as bool?);
    }
    if (data.containsKey('spotId')) {
      final l$spotId = data['spotId'];
      result$data['spotId'] = (l$spotId as String?);
    }
    if (data.containsKey('tags')) {
      final l$tags = data['tags'];
      result$data['tags'] = (l$tags as List<dynamic>?)
          ?.map((e) => (e as String))
          .toList();
    }
    return Input$EditPostInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get postId => (_$data['postId'] as String);

  String get title => (_$data['title'] as String);

  String get body => (_$data['body'] as String);

  List<String>? get photoKeys => (_$data['photoKeys'] as List<String>?);

  Enum$TargetCategory? get category =>
      (_$data['category'] as Enum$TargetCategory?);

  bool? get changeSpot => (_$data['changeSpot'] as bool?);

  String? get spotId => (_$data['spotId'] as String?);

  List<String>? get tags => (_$data['tags'] as List<String>?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$postId = postId;
    result$data['postId'] = l$postId;
    final l$title = title;
    result$data['title'] = l$title;
    final l$body = body;
    result$data['body'] = l$body;
    if (_$data.containsKey('photoKeys')) {
      final l$photoKeys = photoKeys;
      result$data['photoKeys'] = l$photoKeys?.map((e) => e).toList();
    }
    if (_$data.containsKey('category')) {
      final l$category = category;
      result$data['category'] = l$category == null
          ? null
          : toJson$Enum$TargetCategory(l$category);
    }
    if (_$data.containsKey('changeSpot')) {
      final l$changeSpot = changeSpot;
      result$data['changeSpot'] = l$changeSpot;
    }
    if (_$data.containsKey('spotId')) {
      final l$spotId = spotId;
      result$data['spotId'] = l$spotId;
    }
    if (_$data.containsKey('tags')) {
      final l$tags = tags;
      result$data['tags'] = l$tags?.map((e) => e).toList();
    }
    return result$data;
  }

  CopyWith$Input$EditPostInput<Input$EditPostInput> get copyWith =>
      CopyWith$Input$EditPostInput(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$EditPostInput || runtimeType != other.runtimeType) {
      return false;
    }
    final l$postId = postId;
    final lOther$postId = other.postId;
    if (l$postId != lOther$postId) {
      return false;
    }
    final l$title = title;
    final lOther$title = other.title;
    if (l$title != lOther$title) {
      return false;
    }
    final l$body = body;
    final lOther$body = other.body;
    if (l$body != lOther$body) {
      return false;
    }
    final l$photoKeys = photoKeys;
    final lOther$photoKeys = other.photoKeys;
    if (_$data.containsKey('photoKeys') !=
        other._$data.containsKey('photoKeys')) {
      return false;
    }
    if (l$photoKeys != null && lOther$photoKeys != null) {
      if (l$photoKeys.length != lOther$photoKeys.length) {
        return false;
      }
      for (int i = 0; i < l$photoKeys.length; i++) {
        final l$photoKeys$entry = l$photoKeys[i];
        final lOther$photoKeys$entry = lOther$photoKeys[i];
        if (l$photoKeys$entry != lOther$photoKeys$entry) {
          return false;
        }
      }
    } else if (l$photoKeys != lOther$photoKeys) {
      return false;
    }
    final l$category = category;
    final lOther$category = other.category;
    if (_$data.containsKey('category') !=
        other._$data.containsKey('category')) {
      return false;
    }
    if (l$category != lOther$category) {
      return false;
    }
    final l$changeSpot = changeSpot;
    final lOther$changeSpot = other.changeSpot;
    if (_$data.containsKey('changeSpot') !=
        other._$data.containsKey('changeSpot')) {
      return false;
    }
    if (l$changeSpot != lOther$changeSpot) {
      return false;
    }
    final l$spotId = spotId;
    final lOther$spotId = other.spotId;
    if (_$data.containsKey('spotId') != other._$data.containsKey('spotId')) {
      return false;
    }
    if (l$spotId != lOther$spotId) {
      return false;
    }
    final l$tags = tags;
    final lOther$tags = other.tags;
    if (_$data.containsKey('tags') != other._$data.containsKey('tags')) {
      return false;
    }
    if (l$tags != null && lOther$tags != null) {
      if (l$tags.length != lOther$tags.length) {
        return false;
      }
      for (int i = 0; i < l$tags.length; i++) {
        final l$tags$entry = l$tags[i];
        final lOther$tags$entry = lOther$tags[i];
        if (l$tags$entry != lOther$tags$entry) {
          return false;
        }
      }
    } else if (l$tags != lOther$tags) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$postId = postId;
    final l$title = title;
    final l$body = body;
    final l$photoKeys = photoKeys;
    final l$category = category;
    final l$changeSpot = changeSpot;
    final l$spotId = spotId;
    final l$tags = tags;
    return Object.hashAll([
      l$postId,
      l$title,
      l$body,
      _$data.containsKey('photoKeys')
          ? l$photoKeys == null
                ? null
                : Object.hashAll(l$photoKeys.map((v) => v))
          : const {},
      _$data.containsKey('category') ? l$category : const {},
      _$data.containsKey('changeSpot') ? l$changeSpot : const {},
      _$data.containsKey('spotId') ? l$spotId : const {},
      _$data.containsKey('tags')
          ? l$tags == null
                ? null
                : Object.hashAll(l$tags.map((v) => v))
          : const {},
    ]);
  }
}

abstract class CopyWith$Input$EditPostInput<TRes> {
  factory CopyWith$Input$EditPostInput(
    Input$EditPostInput instance,
    TRes Function(Input$EditPostInput) then,
  ) = _CopyWithImpl$Input$EditPostInput;

  factory CopyWith$Input$EditPostInput.stub(TRes res) =
      _CopyWithStubImpl$Input$EditPostInput;

  TRes call({
    String? postId,
    String? title,
    String? body,
    List<String>? photoKeys,
    Enum$TargetCategory? category,
    bool? changeSpot,
    String? spotId,
    List<String>? tags,
  });
}

class _CopyWithImpl$Input$EditPostInput<TRes>
    implements CopyWith$Input$EditPostInput<TRes> {
  _CopyWithImpl$Input$EditPostInput(this._instance, this._then);

  final Input$EditPostInput _instance;

  final TRes Function(Input$EditPostInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? postId = _undefined,
    Object? title = _undefined,
    Object? body = _undefined,
    Object? photoKeys = _undefined,
    Object? category = _undefined,
    Object? changeSpot = _undefined,
    Object? spotId = _undefined,
    Object? tags = _undefined,
  }) => _then(
    Input$EditPostInput._({
      ..._instance._$data,
      if (postId != _undefined && postId != null) 'postId': (postId as String),
      if (title != _undefined && title != null) 'title': (title as String),
      if (body != _undefined && body != null) 'body': (body as String),
      if (photoKeys != _undefined) 'photoKeys': (photoKeys as List<String>?),
      if (category != _undefined)
        'category': (category as Enum$TargetCategory?),
      if (changeSpot != _undefined) 'changeSpot': (changeSpot as bool?),
      if (spotId != _undefined) 'spotId': (spotId as String?),
      if (tags != _undefined) 'tags': (tags as List<String>?),
    }),
  );
}

class _CopyWithStubImpl$Input$EditPostInput<TRes>
    implements CopyWith$Input$EditPostInput<TRes> {
  _CopyWithStubImpl$Input$EditPostInput(this._res);

  TRes _res;

  call({
    String? postId,
    String? title,
    String? body,
    List<String>? photoKeys,
    Enum$TargetCategory? category,
    bool? changeSpot,
    String? spotId,
    List<String>? tags,
  }) => _res;
}

class Input$CreateCommentInput {
  factory Input$CreateCommentInput({
    required String postId,
    required String body,
    String? parentCommentId,
  }) => Input$CreateCommentInput._({
    r'postId': postId,
    r'body': body,
    if (parentCommentId != null) r'parentCommentId': parentCommentId,
  });

  Input$CreateCommentInput._(this._$data);

  factory Input$CreateCommentInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$postId = data['postId'];
    result$data['postId'] = (l$postId as String);
    final l$body = data['body'];
    result$data['body'] = (l$body as String);
    if (data.containsKey('parentCommentId')) {
      final l$parentCommentId = data['parentCommentId'];
      result$data['parentCommentId'] = (l$parentCommentId as String?);
    }
    return Input$CreateCommentInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get postId => (_$data['postId'] as String);

  String get body => (_$data['body'] as String);

  String? get parentCommentId => (_$data['parentCommentId'] as String?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$postId = postId;
    result$data['postId'] = l$postId;
    final l$body = body;
    result$data['body'] = l$body;
    if (_$data.containsKey('parentCommentId')) {
      final l$parentCommentId = parentCommentId;
      result$data['parentCommentId'] = l$parentCommentId;
    }
    return result$data;
  }

  CopyWith$Input$CreateCommentInput<Input$CreateCommentInput> get copyWith =>
      CopyWith$Input$CreateCommentInput(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$CreateCommentInput ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$postId = postId;
    final lOther$postId = other.postId;
    if (l$postId != lOther$postId) {
      return false;
    }
    final l$body = body;
    final lOther$body = other.body;
    if (l$body != lOther$body) {
      return false;
    }
    final l$parentCommentId = parentCommentId;
    final lOther$parentCommentId = other.parentCommentId;
    if (_$data.containsKey('parentCommentId') !=
        other._$data.containsKey('parentCommentId')) {
      return false;
    }
    if (l$parentCommentId != lOther$parentCommentId) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$postId = postId;
    final l$body = body;
    final l$parentCommentId = parentCommentId;
    return Object.hashAll([
      l$postId,
      l$body,
      _$data.containsKey('parentCommentId') ? l$parentCommentId : const {},
    ]);
  }
}

abstract class CopyWith$Input$CreateCommentInput<TRes> {
  factory CopyWith$Input$CreateCommentInput(
    Input$CreateCommentInput instance,
    TRes Function(Input$CreateCommentInput) then,
  ) = _CopyWithImpl$Input$CreateCommentInput;

  factory CopyWith$Input$CreateCommentInput.stub(TRes res) =
      _CopyWithStubImpl$Input$CreateCommentInput;

  TRes call({String? postId, String? body, String? parentCommentId});
}

class _CopyWithImpl$Input$CreateCommentInput<TRes>
    implements CopyWith$Input$CreateCommentInput<TRes> {
  _CopyWithImpl$Input$CreateCommentInput(this._instance, this._then);

  final Input$CreateCommentInput _instance;

  final TRes Function(Input$CreateCommentInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? postId = _undefined,
    Object? body = _undefined,
    Object? parentCommentId = _undefined,
  }) => _then(
    Input$CreateCommentInput._({
      ..._instance._$data,
      if (postId != _undefined && postId != null) 'postId': (postId as String),
      if (body != _undefined && body != null) 'body': (body as String),
      if (parentCommentId != _undefined)
        'parentCommentId': (parentCommentId as String?),
    }),
  );
}

class _CopyWithStubImpl$Input$CreateCommentInput<TRes>
    implements CopyWith$Input$CreateCommentInput<TRes> {
  _CopyWithStubImpl$Input$CreateCommentInput(this._res);

  TRes _res;

  call({String? postId, String? body, String? parentCommentId}) => _res;
}

class Input$DeleteCommentInput {
  factory Input$DeleteCommentInput({required String commentId}) =>
      Input$DeleteCommentInput._({r'commentId': commentId});

  Input$DeleteCommentInput._(this._$data);

  factory Input$DeleteCommentInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$commentId = data['commentId'];
    result$data['commentId'] = (l$commentId as String);
    return Input$DeleteCommentInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get commentId => (_$data['commentId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$commentId = commentId;
    result$data['commentId'] = l$commentId;
    return result$data;
  }

  CopyWith$Input$DeleteCommentInput<Input$DeleteCommentInput> get copyWith =>
      CopyWith$Input$DeleteCommentInput(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$DeleteCommentInput ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$commentId = commentId;
    final lOther$commentId = other.commentId;
    if (l$commentId != lOther$commentId) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$commentId = commentId;
    return Object.hashAll([l$commentId]);
  }
}

abstract class CopyWith$Input$DeleteCommentInput<TRes> {
  factory CopyWith$Input$DeleteCommentInput(
    Input$DeleteCommentInput instance,
    TRes Function(Input$DeleteCommentInput) then,
  ) = _CopyWithImpl$Input$DeleteCommentInput;

  factory CopyWith$Input$DeleteCommentInput.stub(TRes res) =
      _CopyWithStubImpl$Input$DeleteCommentInput;

  TRes call({String? commentId});
}

class _CopyWithImpl$Input$DeleteCommentInput<TRes>
    implements CopyWith$Input$DeleteCommentInput<TRes> {
  _CopyWithImpl$Input$DeleteCommentInput(this._instance, this._then);

  final Input$DeleteCommentInput _instance;

  final TRes Function(Input$DeleteCommentInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? commentId = _undefined}) => _then(
    Input$DeleteCommentInput._({
      ..._instance._$data,
      if (commentId != _undefined && commentId != null)
        'commentId': (commentId as String),
    }),
  );
}

class _CopyWithStubImpl$Input$DeleteCommentInput<TRes>
    implements CopyWith$Input$DeleteCommentInput<TRes> {
  _CopyWithStubImpl$Input$DeleteCommentInput(this._res);

  TRes _res;

  call({String? commentId}) => _res;
}

class Input$DeletePostInput {
  factory Input$DeletePostInput({required String postId}) =>
      Input$DeletePostInput._({r'postId': postId});

  Input$DeletePostInput._(this._$data);

  factory Input$DeletePostInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$postId = data['postId'];
    result$data['postId'] = (l$postId as String);
    return Input$DeletePostInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get postId => (_$data['postId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$postId = postId;
    result$data['postId'] = l$postId;
    return result$data;
  }

  CopyWith$Input$DeletePostInput<Input$DeletePostInput> get copyWith =>
      CopyWith$Input$DeletePostInput(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$DeletePostInput || runtimeType != other.runtimeType) {
      return false;
    }
    final l$postId = postId;
    final lOther$postId = other.postId;
    if (l$postId != lOther$postId) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$postId = postId;
    return Object.hashAll([l$postId]);
  }
}

abstract class CopyWith$Input$DeletePostInput<TRes> {
  factory CopyWith$Input$DeletePostInput(
    Input$DeletePostInput instance,
    TRes Function(Input$DeletePostInput) then,
  ) = _CopyWithImpl$Input$DeletePostInput;

  factory CopyWith$Input$DeletePostInput.stub(TRes res) =
      _CopyWithStubImpl$Input$DeletePostInput;

  TRes call({String? postId});
}

class _CopyWithImpl$Input$DeletePostInput<TRes>
    implements CopyWith$Input$DeletePostInput<TRes> {
  _CopyWithImpl$Input$DeletePostInput(this._instance, this._then);

  final Input$DeletePostInput _instance;

  final TRes Function(Input$DeletePostInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? postId = _undefined}) => _then(
    Input$DeletePostInput._({
      ..._instance._$data,
      if (postId != _undefined && postId != null) 'postId': (postId as String),
    }),
  );
}

class _CopyWithStubImpl$Input$DeletePostInput<TRes>
    implements CopyWith$Input$DeletePostInput<TRes> {
  _CopyWithStubImpl$Input$DeletePostInput(this._res);

  TRes _res;

  call({String? postId}) => _res;
}

class Input$PostImageUploadRequest {
  factory Input$PostImageUploadRequest({
    required String contentType,
    required int contentLength,
  }) => Input$PostImageUploadRequest._({
    r'contentType': contentType,
    r'contentLength': contentLength,
  });

  Input$PostImageUploadRequest._(this._$data);

  factory Input$PostImageUploadRequest.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$contentType = data['contentType'];
    result$data['contentType'] = (l$contentType as String);
    final l$contentLength = data['contentLength'];
    result$data['contentLength'] = (l$contentLength as int);
    return Input$PostImageUploadRequest._(result$data);
  }

  Map<String, dynamic> _$data;

  String get contentType => (_$data['contentType'] as String);

  int get contentLength => (_$data['contentLength'] as int);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$contentType = contentType;
    result$data['contentType'] = l$contentType;
    final l$contentLength = contentLength;
    result$data['contentLength'] = l$contentLength;
    return result$data;
  }

  CopyWith$Input$PostImageUploadRequest<Input$PostImageUploadRequest>
  get copyWith => CopyWith$Input$PostImageUploadRequest(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$PostImageUploadRequest ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$contentType = contentType;
    final lOther$contentType = other.contentType;
    if (l$contentType != lOther$contentType) {
      return false;
    }
    final l$contentLength = contentLength;
    final lOther$contentLength = other.contentLength;
    if (l$contentLength != lOther$contentLength) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$contentType = contentType;
    final l$contentLength = contentLength;
    return Object.hashAll([l$contentType, l$contentLength]);
  }
}

abstract class CopyWith$Input$PostImageUploadRequest<TRes> {
  factory CopyWith$Input$PostImageUploadRequest(
    Input$PostImageUploadRequest instance,
    TRes Function(Input$PostImageUploadRequest) then,
  ) = _CopyWithImpl$Input$PostImageUploadRequest;

  factory CopyWith$Input$PostImageUploadRequest.stub(TRes res) =
      _CopyWithStubImpl$Input$PostImageUploadRequest;

  TRes call({String? contentType, int? contentLength});
}

class _CopyWithImpl$Input$PostImageUploadRequest<TRes>
    implements CopyWith$Input$PostImageUploadRequest<TRes> {
  _CopyWithImpl$Input$PostImageUploadRequest(this._instance, this._then);

  final Input$PostImageUploadRequest _instance;

  final TRes Function(Input$PostImageUploadRequest) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? contentType = _undefined,
    Object? contentLength = _undefined,
  }) => _then(
    Input$PostImageUploadRequest._({
      ..._instance._$data,
      if (contentType != _undefined && contentType != null)
        'contentType': (contentType as String),
      if (contentLength != _undefined && contentLength != null)
        'contentLength': (contentLength as int),
    }),
  );
}

class _CopyWithStubImpl$Input$PostImageUploadRequest<TRes>
    implements CopyWith$Input$PostImageUploadRequest<TRes> {
  _CopyWithStubImpl$Input$PostImageUploadRequest(this._res);

  TRes _res;

  call({String? contentType, int? contentLength}) => _res;
}

class Input$CreatePostImageUploadUrlsInput {
  factory Input$CreatePostImageUploadUrlsInput({
    required List<Input$PostImageUploadRequest> images,
  }) => Input$CreatePostImageUploadUrlsInput._({r'images': images});

  Input$CreatePostImageUploadUrlsInput._(this._$data);

  factory Input$CreatePostImageUploadUrlsInput.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$images = data['images'];
    result$data['images'] = (l$images as List<dynamic>)
        .map(
          (e) => Input$PostImageUploadRequest.fromJson(
            (e as Map<String, dynamic>),
          ),
        )
        .toList();
    return Input$CreatePostImageUploadUrlsInput._(result$data);
  }

  Map<String, dynamic> _$data;

  List<Input$PostImageUploadRequest> get images =>
      (_$data['images'] as List<Input$PostImageUploadRequest>);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$images = images;
    result$data['images'] = l$images.map((e) => e.toJson()).toList();
    return result$data;
  }

  CopyWith$Input$CreatePostImageUploadUrlsInput<
    Input$CreatePostImageUploadUrlsInput
  >
  get copyWith => CopyWith$Input$CreatePostImageUploadUrlsInput(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$CreatePostImageUploadUrlsInput ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$images = images;
    final lOther$images = other.images;
    if (l$images.length != lOther$images.length) {
      return false;
    }
    for (int i = 0; i < l$images.length; i++) {
      final l$images$entry = l$images[i];
      final lOther$images$entry = lOther$images[i];
      if (l$images$entry != lOther$images$entry) {
        return false;
      }
    }
    return true;
  }

  @override
  int get hashCode {
    final l$images = images;
    return Object.hashAll([Object.hashAll(l$images.map((v) => v))]);
  }
}

abstract class CopyWith$Input$CreatePostImageUploadUrlsInput<TRes> {
  factory CopyWith$Input$CreatePostImageUploadUrlsInput(
    Input$CreatePostImageUploadUrlsInput instance,
    TRes Function(Input$CreatePostImageUploadUrlsInput) then,
  ) = _CopyWithImpl$Input$CreatePostImageUploadUrlsInput;

  factory CopyWith$Input$CreatePostImageUploadUrlsInput.stub(TRes res) =
      _CopyWithStubImpl$Input$CreatePostImageUploadUrlsInput;

  TRes call({List<Input$PostImageUploadRequest>? images});
  TRes images(
    Iterable<Input$PostImageUploadRequest> Function(
      Iterable<
        CopyWith$Input$PostImageUploadRequest<Input$PostImageUploadRequest>
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Input$CreatePostImageUploadUrlsInput<TRes>
    implements CopyWith$Input$CreatePostImageUploadUrlsInput<TRes> {
  _CopyWithImpl$Input$CreatePostImageUploadUrlsInput(
    this._instance,
    this._then,
  );

  final Input$CreatePostImageUploadUrlsInput _instance;

  final TRes Function(Input$CreatePostImageUploadUrlsInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? images = _undefined}) => _then(
    Input$CreatePostImageUploadUrlsInput._({
      ..._instance._$data,
      if (images != _undefined && images != null)
        'images': (images as List<Input$PostImageUploadRequest>),
    }),
  );

  TRes images(
    Iterable<Input$PostImageUploadRequest> Function(
      Iterable<
        CopyWith$Input$PostImageUploadRequest<Input$PostImageUploadRequest>
      >,
    )
    _fn,
  ) => call(
    images: _fn(
      _instance.images.map(
        (e) => CopyWith$Input$PostImageUploadRequest(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Input$CreatePostImageUploadUrlsInput<TRes>
    implements CopyWith$Input$CreatePostImageUploadUrlsInput<TRes> {
  _CopyWithStubImpl$Input$CreatePostImageUploadUrlsInput(this._res);

  TRes _res;

  call({List<Input$PostImageUploadRequest>? images}) => _res;

  images(_fn) => _res;
}

class Input$ConfirmPostImageUploadsInput {
  factory Input$ConfirmPostImageUploadsInput({
    required List<String> objectKeys,
  }) => Input$ConfirmPostImageUploadsInput._({r'objectKeys': objectKeys});

  Input$ConfirmPostImageUploadsInput._(this._$data);

  factory Input$ConfirmPostImageUploadsInput.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$objectKeys = data['objectKeys'];
    result$data['objectKeys'] = (l$objectKeys as List<dynamic>)
        .map((e) => (e as String))
        .toList();
    return Input$ConfirmPostImageUploadsInput._(result$data);
  }

  Map<String, dynamic> _$data;

  List<String> get objectKeys => (_$data['objectKeys'] as List<String>);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$objectKeys = objectKeys;
    result$data['objectKeys'] = l$objectKeys.map((e) => e).toList();
    return result$data;
  }

  CopyWith$Input$ConfirmPostImageUploadsInput<
    Input$ConfirmPostImageUploadsInput
  >
  get copyWith => CopyWith$Input$ConfirmPostImageUploadsInput(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$ConfirmPostImageUploadsInput ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$objectKeys = objectKeys;
    final lOther$objectKeys = other.objectKeys;
    if (l$objectKeys.length != lOther$objectKeys.length) {
      return false;
    }
    for (int i = 0; i < l$objectKeys.length; i++) {
      final l$objectKeys$entry = l$objectKeys[i];
      final lOther$objectKeys$entry = lOther$objectKeys[i];
      if (l$objectKeys$entry != lOther$objectKeys$entry) {
        return false;
      }
    }
    return true;
  }

  @override
  int get hashCode {
    final l$objectKeys = objectKeys;
    return Object.hashAll([Object.hashAll(l$objectKeys.map((v) => v))]);
  }
}

abstract class CopyWith$Input$ConfirmPostImageUploadsInput<TRes> {
  factory CopyWith$Input$ConfirmPostImageUploadsInput(
    Input$ConfirmPostImageUploadsInput instance,
    TRes Function(Input$ConfirmPostImageUploadsInput) then,
  ) = _CopyWithImpl$Input$ConfirmPostImageUploadsInput;

  factory CopyWith$Input$ConfirmPostImageUploadsInput.stub(TRes res) =
      _CopyWithStubImpl$Input$ConfirmPostImageUploadsInput;

  TRes call({List<String>? objectKeys});
}

class _CopyWithImpl$Input$ConfirmPostImageUploadsInput<TRes>
    implements CopyWith$Input$ConfirmPostImageUploadsInput<TRes> {
  _CopyWithImpl$Input$ConfirmPostImageUploadsInput(this._instance, this._then);

  final Input$ConfirmPostImageUploadsInput _instance;

  final TRes Function(Input$ConfirmPostImageUploadsInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? objectKeys = _undefined}) => _then(
    Input$ConfirmPostImageUploadsInput._({
      ..._instance._$data,
      if (objectKeys != _undefined && objectKeys != null)
        'objectKeys': (objectKeys as List<String>),
    }),
  );
}

class _CopyWithStubImpl$Input$ConfirmPostImageUploadsInput<TRes>
    implements CopyWith$Input$ConfirmPostImageUploadsInput<TRes> {
  _CopyWithStubImpl$Input$ConfirmPostImageUploadsInput(this._res);

  TRes _res;

  call({List<String>? objectKeys}) => _res;
}

class Input$DeletePostImageInput {
  factory Input$DeletePostImageInput({required String objectKey}) =>
      Input$DeletePostImageInput._({r'objectKey': objectKey});

  Input$DeletePostImageInput._(this._$data);

  factory Input$DeletePostImageInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$objectKey = data['objectKey'];
    result$data['objectKey'] = (l$objectKey as String);
    return Input$DeletePostImageInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get objectKey => (_$data['objectKey'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$objectKey = objectKey;
    result$data['objectKey'] = l$objectKey;
    return result$data;
  }

  CopyWith$Input$DeletePostImageInput<Input$DeletePostImageInput>
  get copyWith => CopyWith$Input$DeletePostImageInput(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$DeletePostImageInput ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$objectKey = objectKey;
    final lOther$objectKey = other.objectKey;
    if (l$objectKey != lOther$objectKey) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$objectKey = objectKey;
    return Object.hashAll([l$objectKey]);
  }
}

abstract class CopyWith$Input$DeletePostImageInput<TRes> {
  factory CopyWith$Input$DeletePostImageInput(
    Input$DeletePostImageInput instance,
    TRes Function(Input$DeletePostImageInput) then,
  ) = _CopyWithImpl$Input$DeletePostImageInput;

  factory CopyWith$Input$DeletePostImageInput.stub(TRes res) =
      _CopyWithStubImpl$Input$DeletePostImageInput;

  TRes call({String? objectKey});
}

class _CopyWithImpl$Input$DeletePostImageInput<TRes>
    implements CopyWith$Input$DeletePostImageInput<TRes> {
  _CopyWithImpl$Input$DeletePostImageInput(this._instance, this._then);

  final Input$DeletePostImageInput _instance;

  final TRes Function(Input$DeletePostImageInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? objectKey = _undefined}) => _then(
    Input$DeletePostImageInput._({
      ..._instance._$data,
      if (objectKey != _undefined && objectKey != null)
        'objectKey': (objectKey as String),
    }),
  );
}

class _CopyWithStubImpl$Input$DeletePostImageInput<TRes>
    implements CopyWith$Input$DeletePostImageInput<TRes> {
  _CopyWithStubImpl$Input$DeletePostImageInput(this._res);

  TRes _res;

  call({String? objectKey}) => _res;
}

class Input$BlockUserInput {
  factory Input$BlockUserInput({required String targetMemberId}) =>
      Input$BlockUserInput._({r'targetMemberId': targetMemberId});

  Input$BlockUserInput._(this._$data);

  factory Input$BlockUserInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$targetMemberId = data['targetMemberId'];
    result$data['targetMemberId'] = (l$targetMemberId as String);
    return Input$BlockUserInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get targetMemberId => (_$data['targetMemberId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$targetMemberId = targetMemberId;
    result$data['targetMemberId'] = l$targetMemberId;
    return result$data;
  }

  CopyWith$Input$BlockUserInput<Input$BlockUserInput> get copyWith =>
      CopyWith$Input$BlockUserInput(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$BlockUserInput || runtimeType != other.runtimeType) {
      return false;
    }
    final l$targetMemberId = targetMemberId;
    final lOther$targetMemberId = other.targetMemberId;
    if (l$targetMemberId != lOther$targetMemberId) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$targetMemberId = targetMemberId;
    return Object.hashAll([l$targetMemberId]);
  }
}

abstract class CopyWith$Input$BlockUserInput<TRes> {
  factory CopyWith$Input$BlockUserInput(
    Input$BlockUserInput instance,
    TRes Function(Input$BlockUserInput) then,
  ) = _CopyWithImpl$Input$BlockUserInput;

  factory CopyWith$Input$BlockUserInput.stub(TRes res) =
      _CopyWithStubImpl$Input$BlockUserInput;

  TRes call({String? targetMemberId});
}

class _CopyWithImpl$Input$BlockUserInput<TRes>
    implements CopyWith$Input$BlockUserInput<TRes> {
  _CopyWithImpl$Input$BlockUserInput(this._instance, this._then);

  final Input$BlockUserInput _instance;

  final TRes Function(Input$BlockUserInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? targetMemberId = _undefined}) => _then(
    Input$BlockUserInput._({
      ..._instance._$data,
      if (targetMemberId != _undefined && targetMemberId != null)
        'targetMemberId': (targetMemberId as String),
    }),
  );
}

class _CopyWithStubImpl$Input$BlockUserInput<TRes>
    implements CopyWith$Input$BlockUserInput<TRes> {
  _CopyWithStubImpl$Input$BlockUserInput(this._res);

  TRes _res;

  call({String? targetMemberId}) => _res;
}

class Input$UnblockUserInput {
  factory Input$UnblockUserInput({required String targetMemberId}) =>
      Input$UnblockUserInput._({r'targetMemberId': targetMemberId});

  Input$UnblockUserInput._(this._$data);

  factory Input$UnblockUserInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$targetMemberId = data['targetMemberId'];
    result$data['targetMemberId'] = (l$targetMemberId as String);
    return Input$UnblockUserInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get targetMemberId => (_$data['targetMemberId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$targetMemberId = targetMemberId;
    result$data['targetMemberId'] = l$targetMemberId;
    return result$data;
  }

  CopyWith$Input$UnblockUserInput<Input$UnblockUserInput> get copyWith =>
      CopyWith$Input$UnblockUserInput(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$UnblockUserInput || runtimeType != other.runtimeType) {
      return false;
    }
    final l$targetMemberId = targetMemberId;
    final lOther$targetMemberId = other.targetMemberId;
    if (l$targetMemberId != lOther$targetMemberId) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$targetMemberId = targetMemberId;
    return Object.hashAll([l$targetMemberId]);
  }
}

abstract class CopyWith$Input$UnblockUserInput<TRes> {
  factory CopyWith$Input$UnblockUserInput(
    Input$UnblockUserInput instance,
    TRes Function(Input$UnblockUserInput) then,
  ) = _CopyWithImpl$Input$UnblockUserInput;

  factory CopyWith$Input$UnblockUserInput.stub(TRes res) =
      _CopyWithStubImpl$Input$UnblockUserInput;

  TRes call({String? targetMemberId});
}

class _CopyWithImpl$Input$UnblockUserInput<TRes>
    implements CopyWith$Input$UnblockUserInput<TRes> {
  _CopyWithImpl$Input$UnblockUserInput(this._instance, this._then);

  final Input$UnblockUserInput _instance;

  final TRes Function(Input$UnblockUserInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? targetMemberId = _undefined}) => _then(
    Input$UnblockUserInput._({
      ..._instance._$data,
      if (targetMemberId != _undefined && targetMemberId != null)
        'targetMemberId': (targetMemberId as String),
    }),
  );
}

class _CopyWithStubImpl$Input$UnblockUserInput<TRes>
    implements CopyWith$Input$UnblockUserInput<TRes> {
  _CopyWithStubImpl$Input$UnblockUserInput(this._res);

  TRes _res;

  call({String? targetMemberId}) => _res;
}

class Input$ReportContentInput {
  factory Input$ReportContentInput({
    required Enum$ReportTargetType targetType,
    required String targetId,
    required Enum$ReportReason reason,
    String? detail,
  }) => Input$ReportContentInput._({
    r'targetType': targetType,
    r'targetId': targetId,
    r'reason': reason,
    if (detail != null) r'detail': detail,
  });

  Input$ReportContentInput._(this._$data);

  factory Input$ReportContentInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$targetType = data['targetType'];
    result$data['targetType'] = fromJson$Enum$ReportTargetType(
      (l$targetType as String),
    );
    final l$targetId = data['targetId'];
    result$data['targetId'] = (l$targetId as String);
    final l$reason = data['reason'];
    result$data['reason'] = fromJson$Enum$ReportReason((l$reason as String));
    if (data.containsKey('detail')) {
      final l$detail = data['detail'];
      result$data['detail'] = (l$detail as String?);
    }
    return Input$ReportContentInput._(result$data);
  }

  Map<String, dynamic> _$data;

  Enum$ReportTargetType get targetType =>
      (_$data['targetType'] as Enum$ReportTargetType);

  String get targetId => (_$data['targetId'] as String);

  Enum$ReportReason get reason => (_$data['reason'] as Enum$ReportReason);

  String? get detail => (_$data['detail'] as String?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$targetType = targetType;
    result$data['targetType'] = toJson$Enum$ReportTargetType(l$targetType);
    final l$targetId = targetId;
    result$data['targetId'] = l$targetId;
    final l$reason = reason;
    result$data['reason'] = toJson$Enum$ReportReason(l$reason);
    if (_$data.containsKey('detail')) {
      final l$detail = detail;
      result$data['detail'] = l$detail;
    }
    return result$data;
  }

  CopyWith$Input$ReportContentInput<Input$ReportContentInput> get copyWith =>
      CopyWith$Input$ReportContentInput(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$ReportContentInput ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$targetType = targetType;
    final lOther$targetType = other.targetType;
    if (l$targetType != lOther$targetType) {
      return false;
    }
    final l$targetId = targetId;
    final lOther$targetId = other.targetId;
    if (l$targetId != lOther$targetId) {
      return false;
    }
    final l$reason = reason;
    final lOther$reason = other.reason;
    if (l$reason != lOther$reason) {
      return false;
    }
    final l$detail = detail;
    final lOther$detail = other.detail;
    if (_$data.containsKey('detail') != other._$data.containsKey('detail')) {
      return false;
    }
    if (l$detail != lOther$detail) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$targetType = targetType;
    final l$targetId = targetId;
    final l$reason = reason;
    final l$detail = detail;
    return Object.hashAll([
      l$targetType,
      l$targetId,
      l$reason,
      _$data.containsKey('detail') ? l$detail : const {},
    ]);
  }
}

abstract class CopyWith$Input$ReportContentInput<TRes> {
  factory CopyWith$Input$ReportContentInput(
    Input$ReportContentInput instance,
    TRes Function(Input$ReportContentInput) then,
  ) = _CopyWithImpl$Input$ReportContentInput;

  factory CopyWith$Input$ReportContentInput.stub(TRes res) =
      _CopyWithStubImpl$Input$ReportContentInput;

  TRes call({
    Enum$ReportTargetType? targetType,
    String? targetId,
    Enum$ReportReason? reason,
    String? detail,
  });
}

class _CopyWithImpl$Input$ReportContentInput<TRes>
    implements CopyWith$Input$ReportContentInput<TRes> {
  _CopyWithImpl$Input$ReportContentInput(this._instance, this._then);

  final Input$ReportContentInput _instance;

  final TRes Function(Input$ReportContentInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? targetType = _undefined,
    Object? targetId = _undefined,
    Object? reason = _undefined,
    Object? detail = _undefined,
  }) => _then(
    Input$ReportContentInput._({
      ..._instance._$data,
      if (targetType != _undefined && targetType != null)
        'targetType': (targetType as Enum$ReportTargetType),
      if (targetId != _undefined && targetId != null)
        'targetId': (targetId as String),
      if (reason != _undefined && reason != null)
        'reason': (reason as Enum$ReportReason),
      if (detail != _undefined) 'detail': (detail as String?),
    }),
  );
}

class _CopyWithStubImpl$Input$ReportContentInput<TRes>
    implements CopyWith$Input$ReportContentInput<TRes> {
  _CopyWithStubImpl$Input$ReportContentInput(this._res);

  TRes _res;

  call({
    Enum$ReportTargetType? targetType,
    String? targetId,
    Enum$ReportReason? reason,
    String? detail,
  }) => _res;
}

class Input$HidePostInput {
  factory Input$HidePostInput({required String postId}) =>
      Input$HidePostInput._({r'postId': postId});

  Input$HidePostInput._(this._$data);

  factory Input$HidePostInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$postId = data['postId'];
    result$data['postId'] = (l$postId as String);
    return Input$HidePostInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get postId => (_$data['postId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$postId = postId;
    result$data['postId'] = l$postId;
    return result$data;
  }

  CopyWith$Input$HidePostInput<Input$HidePostInput> get copyWith =>
      CopyWith$Input$HidePostInput(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$HidePostInput || runtimeType != other.runtimeType) {
      return false;
    }
    final l$postId = postId;
    final lOther$postId = other.postId;
    if (l$postId != lOther$postId) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$postId = postId;
    return Object.hashAll([l$postId]);
  }
}

abstract class CopyWith$Input$HidePostInput<TRes> {
  factory CopyWith$Input$HidePostInput(
    Input$HidePostInput instance,
    TRes Function(Input$HidePostInput) then,
  ) = _CopyWithImpl$Input$HidePostInput;

  factory CopyWith$Input$HidePostInput.stub(TRes res) =
      _CopyWithStubImpl$Input$HidePostInput;

  TRes call({String? postId});
}

class _CopyWithImpl$Input$HidePostInput<TRes>
    implements CopyWith$Input$HidePostInput<TRes> {
  _CopyWithImpl$Input$HidePostInput(this._instance, this._then);

  final Input$HidePostInput _instance;

  final TRes Function(Input$HidePostInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? postId = _undefined}) => _then(
    Input$HidePostInput._({
      ..._instance._$data,
      if (postId != _undefined && postId != null) 'postId': (postId as String),
    }),
  );
}

class _CopyWithStubImpl$Input$HidePostInput<TRes>
    implements CopyWith$Input$HidePostInput<TRes> {
  _CopyWithStubImpl$Input$HidePostInput(this._res);

  TRes _res;

  call({String? postId}) => _res;
}

class Input$UnhidePostInput {
  factory Input$UnhidePostInput({required String postId}) =>
      Input$UnhidePostInput._({r'postId': postId});

  Input$UnhidePostInput._(this._$data);

  factory Input$UnhidePostInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$postId = data['postId'];
    result$data['postId'] = (l$postId as String);
    return Input$UnhidePostInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get postId => (_$data['postId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$postId = postId;
    result$data['postId'] = l$postId;
    return result$data;
  }

  CopyWith$Input$UnhidePostInput<Input$UnhidePostInput> get copyWith =>
      CopyWith$Input$UnhidePostInput(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$UnhidePostInput || runtimeType != other.runtimeType) {
      return false;
    }
    final l$postId = postId;
    final lOther$postId = other.postId;
    if (l$postId != lOther$postId) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$postId = postId;
    return Object.hashAll([l$postId]);
  }
}

abstract class CopyWith$Input$UnhidePostInput<TRes> {
  factory CopyWith$Input$UnhidePostInput(
    Input$UnhidePostInput instance,
    TRes Function(Input$UnhidePostInput) then,
  ) = _CopyWithImpl$Input$UnhidePostInput;

  factory CopyWith$Input$UnhidePostInput.stub(TRes res) =
      _CopyWithStubImpl$Input$UnhidePostInput;

  TRes call({String? postId});
}

class _CopyWithImpl$Input$UnhidePostInput<TRes>
    implements CopyWith$Input$UnhidePostInput<TRes> {
  _CopyWithImpl$Input$UnhidePostInput(this._instance, this._then);

  final Input$UnhidePostInput _instance;

  final TRes Function(Input$UnhidePostInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? postId = _undefined}) => _then(
    Input$UnhidePostInput._({
      ..._instance._$data,
      if (postId != _undefined && postId != null) 'postId': (postId as String),
    }),
  );
}

class _CopyWithStubImpl$Input$UnhidePostInput<TRes>
    implements CopyWith$Input$UnhidePostInput<TRes> {
  _CopyWithStubImpl$Input$UnhidePostInput(this._res);

  TRes _res;

  call({String? postId}) => _res;
}

class Input$LikePostInput {
  factory Input$LikePostInput({required String postId}) =>
      Input$LikePostInput._({r'postId': postId});

  Input$LikePostInput._(this._$data);

  factory Input$LikePostInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$postId = data['postId'];
    result$data['postId'] = (l$postId as String);
    return Input$LikePostInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get postId => (_$data['postId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$postId = postId;
    result$data['postId'] = l$postId;
    return result$data;
  }

  CopyWith$Input$LikePostInput<Input$LikePostInput> get copyWith =>
      CopyWith$Input$LikePostInput(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$LikePostInput || runtimeType != other.runtimeType) {
      return false;
    }
    final l$postId = postId;
    final lOther$postId = other.postId;
    if (l$postId != lOther$postId) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$postId = postId;
    return Object.hashAll([l$postId]);
  }
}

abstract class CopyWith$Input$LikePostInput<TRes> {
  factory CopyWith$Input$LikePostInput(
    Input$LikePostInput instance,
    TRes Function(Input$LikePostInput) then,
  ) = _CopyWithImpl$Input$LikePostInput;

  factory CopyWith$Input$LikePostInput.stub(TRes res) =
      _CopyWithStubImpl$Input$LikePostInput;

  TRes call({String? postId});
}

class _CopyWithImpl$Input$LikePostInput<TRes>
    implements CopyWith$Input$LikePostInput<TRes> {
  _CopyWithImpl$Input$LikePostInput(this._instance, this._then);

  final Input$LikePostInput _instance;

  final TRes Function(Input$LikePostInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? postId = _undefined}) => _then(
    Input$LikePostInput._({
      ..._instance._$data,
      if (postId != _undefined && postId != null) 'postId': (postId as String),
    }),
  );
}

class _CopyWithStubImpl$Input$LikePostInput<TRes>
    implements CopyWith$Input$LikePostInput<TRes> {
  _CopyWithStubImpl$Input$LikePostInput(this._res);

  TRes _res;

  call({String? postId}) => _res;
}

class Input$UnlikePostInput {
  factory Input$UnlikePostInput({required String postId}) =>
      Input$UnlikePostInput._({r'postId': postId});

  Input$UnlikePostInput._(this._$data);

  factory Input$UnlikePostInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$postId = data['postId'];
    result$data['postId'] = (l$postId as String);
    return Input$UnlikePostInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get postId => (_$data['postId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$postId = postId;
    result$data['postId'] = l$postId;
    return result$data;
  }

  CopyWith$Input$UnlikePostInput<Input$UnlikePostInput> get copyWith =>
      CopyWith$Input$UnlikePostInput(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$UnlikePostInput || runtimeType != other.runtimeType) {
      return false;
    }
    final l$postId = postId;
    final lOther$postId = other.postId;
    if (l$postId != lOther$postId) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$postId = postId;
    return Object.hashAll([l$postId]);
  }
}

abstract class CopyWith$Input$UnlikePostInput<TRes> {
  factory CopyWith$Input$UnlikePostInput(
    Input$UnlikePostInput instance,
    TRes Function(Input$UnlikePostInput) then,
  ) = _CopyWithImpl$Input$UnlikePostInput;

  factory CopyWith$Input$UnlikePostInput.stub(TRes res) =
      _CopyWithStubImpl$Input$UnlikePostInput;

  TRes call({String? postId});
}

class _CopyWithImpl$Input$UnlikePostInput<TRes>
    implements CopyWith$Input$UnlikePostInput<TRes> {
  _CopyWithImpl$Input$UnlikePostInput(this._instance, this._then);

  final Input$UnlikePostInput _instance;

  final TRes Function(Input$UnlikePostInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? postId = _undefined}) => _then(
    Input$UnlikePostInput._({
      ..._instance._$data,
      if (postId != _undefined && postId != null) 'postId': (postId as String),
    }),
  );
}

class _CopyWithStubImpl$Input$UnlikePostInput<TRes>
    implements CopyWith$Input$UnlikePostInput<TRes> {
  _CopyWithStubImpl$Input$UnlikePostInput(this._res);

  TRes _res;

  call({String? postId}) => _res;
}

enum Enum$ReportReason {
  SPAM,
  ABUSE,
  INAPPROPRIATE_CONTENT,
  OTHER,
  $unknown;

  factory Enum$ReportReason.fromJson(String value) =>
      fromJson$Enum$ReportReason(value);

  String toJson() => toJson$Enum$ReportReason(this);
}

String toJson$Enum$ReportReason(Enum$ReportReason e) {
  switch (e) {
    case Enum$ReportReason.SPAM:
      return r'SPAM';
    case Enum$ReportReason.ABUSE:
      return r'ABUSE';
    case Enum$ReportReason.INAPPROPRIATE_CONTENT:
      return r'INAPPROPRIATE_CONTENT';
    case Enum$ReportReason.OTHER:
      return r'OTHER';
    case Enum$ReportReason.$unknown:
      return r'$unknown';
  }
}

Enum$ReportReason fromJson$Enum$ReportReason(String value) {
  switch (value) {
    case r'SPAM':
      return Enum$ReportReason.SPAM;
    case r'ABUSE':
      return Enum$ReportReason.ABUSE;
    case r'INAPPROPRIATE_CONTENT':
      return Enum$ReportReason.INAPPROPRIATE_CONTENT;
    case r'OTHER':
      return Enum$ReportReason.OTHER;
    default:
      return Enum$ReportReason.$unknown;
  }
}

enum Enum$ReportTargetType {
  POST,
  COMMENT,
  MEMBER,
  FEED_ITEM,
  $unknown;

  factory Enum$ReportTargetType.fromJson(String value) =>
      fromJson$Enum$ReportTargetType(value);

  String toJson() => toJson$Enum$ReportTargetType(this);
}

String toJson$Enum$ReportTargetType(Enum$ReportTargetType e) {
  switch (e) {
    case Enum$ReportTargetType.POST:
      return r'POST';
    case Enum$ReportTargetType.COMMENT:
      return r'COMMENT';
    case Enum$ReportTargetType.MEMBER:
      return r'MEMBER';
    case Enum$ReportTargetType.FEED_ITEM:
      return r'FEED_ITEM';
    case Enum$ReportTargetType.$unknown:
      return r'$unknown';
  }
}

Enum$ReportTargetType fromJson$Enum$ReportTargetType(String value) {
  switch (value) {
    case r'POST':
      return Enum$ReportTargetType.POST;
    case r'COMMENT':
      return Enum$ReportTargetType.COMMENT;
    case r'MEMBER':
      return Enum$ReportTargetType.MEMBER;
    case r'FEED_ITEM':
      return Enum$ReportTargetType.FEED_ITEM;
    default:
      return Enum$ReportTargetType.$unknown;
  }
}

enum Enum$PostSortOrder {
  LATEST,
  DISTANCE,
  $unknown;

  factory Enum$PostSortOrder.fromJson(String value) =>
      fromJson$Enum$PostSortOrder(value);

  String toJson() => toJson$Enum$PostSortOrder(this);
}

String toJson$Enum$PostSortOrder(Enum$PostSortOrder e) {
  switch (e) {
    case Enum$PostSortOrder.LATEST:
      return r'LATEST';
    case Enum$PostSortOrder.DISTANCE:
      return r'DISTANCE';
    case Enum$PostSortOrder.$unknown:
      return r'$unknown';
  }
}

Enum$PostSortOrder fromJson$Enum$PostSortOrder(String value) {
  switch (value) {
    case r'LATEST':
      return Enum$PostSortOrder.LATEST;
    case r'DISTANCE':
      return Enum$PostSortOrder.DISTANCE;
    default:
      return Enum$PostSortOrder.$unknown;
  }
}
