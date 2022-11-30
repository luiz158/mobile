import 'package:fpdart/fpdart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lichess_mobile/src/common/errors.dart';
import 'package:lichess_mobile/src/common/http.dart';
import 'package:lichess_mobile/src/constants.dart';

class ChallengeRepository {
  const ChallengeRepository({
    required this.apiClient,
  });

  final ApiClient apiClient;

  TaskEither<IOError, void> createChallenge(
      String username, ChallengeRequest req) {
    return apiClient.post(Uri.parse('$kLichessHost/api/challenge/$username'),
        body: req.toRequestBody);
  }

  TaskEither<IOError, void> challengeAI(AiChallengeRequest req) {
    return apiClient.post(Uri.parse('$kLichessHost/api/challenge/ai'),
        body: req.toRequestBody);
  }

  void dispose() {
    apiClient.close();
  }
}

final challengeRepositoryProvider = Provider<ChallengeRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final repo = ChallengeRepository(apiClient: apiClient);
  ref.onDispose(() => repo.dispose());
  return repo;
});

class ChallengeRequest {
  const ChallengeRequest({
    required this.time,
    required this.increment,
    this.side,
  });

  /// Clock initial time in seconds.
  final int time;

  /// Clock increment in seconds
  final int increment;

  /// Which side you get to play. Default is random.
  final ChallengeSide? side;

  Map<String, dynamic> get toRequestBody => {
        'clock.limit': time,
        'clock.increment': increment,
        'color': side?.name ?? ChallengeSide.random.name,
      };
}

class AiChallengeRequest extends ChallengeRequest {
  const AiChallengeRequest({
    required super.time,
    required super.increment,
    super.side,
    required this.level,
  });

  /// AI Strength
  final int level;

  @override
  Map<String, dynamic> get toRequestBody => {
        'level': level,
        'clock.limit': time,
        'clock.increment': increment,
        'color': side?.name ?? ChallengeSide.random.name,
      };
}

enum ChallengeSide {
  white,
  black,
  random;
}