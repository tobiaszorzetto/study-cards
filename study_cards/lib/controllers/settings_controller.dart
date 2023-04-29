


class SettingsController {
  List<Duration> timesToStudy = [Duration(minutes: 10), Duration(days: 1), Duration(days: 6)];

  static SettingsController instance = SettingsController();

  void changeTimeToStudy(int i, Duration duration){
    timesToStudy[i] = duration;
  }
  
}