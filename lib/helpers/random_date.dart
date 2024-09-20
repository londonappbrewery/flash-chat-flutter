import 'dart:math';

DateTime randomDate() {
  DateTime date = DateTime.now();
  return date.subtract(Duration(seconds: Random().nextInt(200000)));
}
