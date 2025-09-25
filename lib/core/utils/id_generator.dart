import 'dart:math';

String generateTaskId() {
  final random = Random();
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  final randomNumber = random.nextInt(999999);
  return '$timestamp-$randomNumber';
}
