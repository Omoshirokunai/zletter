import 'dart:math';

// #region genletter
String generateRandomString(int len) {
  var r = Random();
  const _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  return List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
}
// #endregion
