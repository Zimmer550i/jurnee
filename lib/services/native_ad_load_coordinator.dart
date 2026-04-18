import 'dart:async';

/// Serializes [NativeAd.load] starts so many feed slots do not hit AdMob at once.
class NativeAdLoadCoordinator {
  NativeAdLoadCoordinator._();
  static final NativeAdLoadCoordinator instance = NativeAdLoadCoordinator._();

  Future<void> _queue = Future<void>.value();
  bool _delayBeforeNext = false;

  /// Runs [startLoad] after prior scheduled loads; inserts a gap before each load after the first.
  Future<void> scheduleLoad(void Function() startLoad) {
    final done = Completer<void>();
    _queue = _queue.then((_) async {
      try {
        if (_delayBeforeNext) {
          await Future<void>.delayed(const Duration(milliseconds: 450));
        }
        _delayBeforeNext = true;
        startLoad();
      } finally {
        if (!done.isCompleted) done.complete();
      }
    });
    return done.future;
  }
}
