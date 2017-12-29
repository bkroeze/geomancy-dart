part of geomancy;

/// Returns [x], forced into range 0-11.
int houseRange (int x) {
  while (x < 0) { x = x + 12; }
  return x % 12;
}

 /// Returns the slugified version of [name].
String slugify (String name) {
  return name.toLowerCase().replaceAll(new RegExp(' '), '-');
}

String zero1 (bool flag) {
  return flag ? '1' : '0';
}

bool xor (bool a, bool b) {
  return !a != !b;
}
