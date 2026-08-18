import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../common/storage/app_preferences.dart';
import '../repository/seen_answer_counts_store.dart';

part 'seen_answer_counts_providers.g.dart';

/// 「마지막에 본 답변 수」 저장소의 출처. 테스트는 이것만 오버라이드해 페이크를 준다.
@riverpod
SeenAnswerCountsStore seenAnswerCountsStore(Ref ref) =>
    SharedPreferencesSeenAnswerCountsStore(ref.watch(sharedPreferencesProvider));
