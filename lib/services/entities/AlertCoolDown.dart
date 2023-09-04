import 'dart:async';

class AlertCoolDown {




  /// This class is a singleton, so callers get the unique instance of this class
  /// by calling AlertCoolDown()


  ///isActive is true if the countdown is running
  late bool _isActive;

  ///coolDownSeconds is the number of seconds the countdown will run for
  late int _coolDownSeconds;

  ///currentCountDown is the number of seconds remaining in the countdown
  late int _currentCountDown;

  ///timer is the timer that runs the countdown
  late Timer timer;

  ///periodicExecution is the function that is called every second of the countdown
  Function(int) _periodicExecution = (int num) {};

  ///onCountdownEnd is the function that is called when the countdown ends
  Function() _onCountdownEnd = (){};


  ///_instance is the unique instance of this class.
  ///The default duration of the countdown is 59 seconds
 static final AlertCoolDown _instance = AlertCoolDown._internal(59);


 factory AlertCoolDown() {
    return _instance;
  }

  /// This named constructor is the "real" constructor
  /// It'll be called exactly once, by the static property assignment above
  /// it's also private, so it can only be called in this class.
  /// It receives the number of seconds the countdown will run for: [coolDownSeconds]
  AlertCoolDown._internal(int coolDownSeconds) {
    // initialization logic
    _coolDownSeconds = coolDownSeconds;
    _currentCountDown = coolDownSeconds;
    _isActive = false;
  }


  ///Set the function that will be called when the countdown ends.
  ///The function must have no parameters and return void
  set onCountdownEnd(Function() onCountdownEnd){
    _onCountdownEnd = onCountdownEnd;
  }

  ///Set the function that will be called every second of the countdown.
  set periodicExecution(Function(int) periodicExecution){
    _periodicExecution = periodicExecution;
  }

  ///Return true if the countdown is running
  bool get isActive => _isActive;

  ///Return the number of seconds the countdown will run for
  int get coolDownSeconds => _coolDownSeconds;

  ///Return the number of seconds remaining in the countdown
  int get currentCountDown => _currentCountDown;


  ///Method to start the countdown
  ///It sets the [_isActive] flag to true, and starts the timer
  ///The timer will call the [_periodicExecution] function every second
  ///If the countdown reaches 0, the [resetCountdown] method is called
  void startCountdown(){
    _isActive = true;
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) => {

          if(_currentCountDown > 0){
            _currentCountDown -= 1,
            _periodicExecution(_currentCountDown)
          }
          else{
            resetCountdown()
          }

    });
  }

  ///Method to reset the countdown
  ///It sets the [_isActive] flag to false,
  ///and resets the [_currentCountDown] to the initial value
  ///It also cancels the timer.
  void resetCountdown(){
    _isActive = false;
    _currentCountDown = _coolDownSeconds;
    timer.cancel();
    _onCountdownEnd();
  }


}