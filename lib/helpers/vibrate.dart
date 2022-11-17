import 'package:flutter/foundation.dart';
import 'package:vibration/vibration.dart';

Future<void> shortVibrate() async {
  if (defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS) {
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 50);
    }
  }
}
