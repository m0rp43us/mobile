import 'package:async/async.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tuple/tuple.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart'
    hide Tuple2;

import 'package:lichess_mobile/src/common/models.dart';
import 'package:lichess_mobile/src/model/auth/user_session.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_theme.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_repository.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_storage.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_service.dart';

part 'puzzle_providers.g.dart';

@riverpod
Future<Tuple2<UserId?, Puzzle?>> nextPuzzle(
  NextPuzzleRef ref,
  PuzzleTheme theme,
) async {
  final session = ref.watch(userSessionStateProvider);
  final puzzleService = ref.watch(defaultPuzzleServiceProvider);
  final userId = session?.user.id;
  final puzzle = await puzzleService.nextPuzzle(
    userId: userId,
    angle: theme,
  );
  return Tuple2(session?.user.id, puzzle);
}

@riverpod
Future<Puzzle> dailyPuzzle(DailyPuzzleRef ref) {
  final repo = ref.watch(puzzleRepositoryProvider);
  return Result.release(repo.daily());
}

@riverpod
Future<ISet<PuzzleTheme>> savedThemes(SavedThemesRef ref) async {
  final session = ref.watch(userSessionStateProvider);
  final storage = ref.watch(puzzleStorageProvider);
  final themes = await storage.fetchSavedThemes(userId: session?.user.id);
  return themes;
}
