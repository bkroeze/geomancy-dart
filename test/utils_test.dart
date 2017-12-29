import 'package:geomancy_dart/geomancy.dart';
import 'package:test/test.dart';

void main() {
  test('slugify', () {
    expect(slugify('foo bar'), 'foo-bar');
    expect(slugify('flim-flam'), 'flim-flam');
  });

  test('xor', () {
    expect(xor(true, false), true);
    expect(xor(true, true), false);
    expect(xor(false, false), false);
    expect(xor(false, true), true);
  });

  test('zero1', () {
    expect(zero1(true), '1');
    expect(zero1(false), '0');
  });
}
