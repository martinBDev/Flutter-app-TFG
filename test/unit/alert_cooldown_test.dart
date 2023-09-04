import 'package:flutter_app_tfg/services/Entities/AlertCoolDown.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:ui';

void main() {
  test('AlertCoolDown initializes correctly', () {
    final alertCoolDown = AlertCoolDown();

    expect(alertCoolDown.isActive, false);
    expect(alertCoolDown.coolDownSeconds, 59);
    expect(alertCoolDown.currentCountDown, 59);
  });

  test('startCountdown changes isActive to true and starts the countdown', () {
    final alertCoolDown = AlertCoolDown();

    alertCoolDown.startCountdown();

    expect(alertCoolDown.isActive, true);
    // We cannot directly test the countdown behavior here because it's asynchronous
    // We will address this in the next test
  });

  test('resetCountdown resets the countdown and calls the onCountdownEnd callback', () {
    final alertCoolDown = AlertCoolDown();

    bool wasCalled = false;

    alertCoolDown.onCountdownEnd = () {
      wasCalled = true;
    };

    alertCoolDown.startCountdown();
    alertCoolDown.resetCountdown();

    expect(alertCoolDown.isActive, false);
    expect(alertCoolDown.currentCountDown, alertCoolDown.coolDownSeconds);
    expect(wasCalled, true); // Verifies that the callback was called
  });

  // More tests here for periodicExecution, etc.
}
