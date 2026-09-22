void main() {
  var list = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89];

  // list.where((el) => x < 5).forEach(print)

  for (final el in list) {
    if (el < 5) print(el);
  }
}
