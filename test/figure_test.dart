import 'package:geomancy_dart/geomancy.dart';
import 'package:test/test.dart';

void main() {
  group('Figure Static Methods', () {
    test('.byName()', () {
      var v1 = Figure.byName('via');
      expect(v1.name, 'Via');
      expect(v1.flags, '1111');
    });

    test('.byFlags()', () {
      var v1 = Figure.byName('populus');
      expect(v1.name, 'Populus');
      expect(v1.flags, '0000');
    });

    test('.byElements()', () {
      Map<String, bool> elements = {
        'fire': true,
        'air': true,
        'water': false,
        'earth': false
      };
      var v1 = Figure.byElements(elements);
      expect(v1.name, 'Fortuna Minor');
      expect(v1.flags, '0011');
    });
  });

  group('Figure', () {
    test('should construct via a flags (1)', () {
      var geo = new Figure('1000');
      expect(geo.fire, false);
      expect(geo.air, false);
      expect(geo.water, false);
      expect(geo.earth, true);
      expect(geo.number, 1000);
    });

    test('should construct via a flags (2)', () {
      var geo = new Figure('');
      geo.flags = '1100';
      expect(geo.fire, false);
      expect(geo.air, false);
      expect(geo.water, true);
      expect(geo.earth, true);
      expect(geo.number, 1100);
    });

    test('should construct via a flags (3)', () {
      var geo = new Figure('11');
      expect(geo.fire, true);
      expect(geo.air, true);
      expect(geo.water, false);
      expect(geo.earth, false);
      expect(geo.number, 11);
    });

    test('should get lines of figures by index', () {
      var geo = Figure.byName('carcer');
      expect(geo.getLine(0), true);
      expect(geo.getLine(1), false);
      expect(geo.getLine(2), false);
      expect(geo.getLine(3), true);
    });

    test('should get details of figures', () {
      var geo = Figure.byName('Albus');
      expect(geo.details['english'], 'White');
    });

    test('should add figures together', () {
      var via = Figure.byName('Via');
      var populus = Figure.byName('Populus');
      expect(via.add(populus), via);
      var fmajor = Figure.byName('fortuna major');
      var fminor = Figure.byName('fortuna minor');
      expect(fmajor.add(via), fminor);
    });

    test('should calculate its point count', () {
      var puer = Figure.byName('puer');
      var via = Figure.byName('Via');
      var conj = Figure.byName('Conjunctio');

      expect(puer.getPoints(), 5);
      expect(puer.getActivePoints(), 3);
      expect(via.getPoints(), 4);
      expect(via.getActivePoints(), 4);
      expect(conj.getPoints(), 6);
      expect(conj.getActivePoints(), 2);
    });

    test('should know company types', () {
      var puer = Figure.byName('puer');
      var puella = Figure.byName('puella');
      var rubeus = Figure.byName('rubeus');
      var via = Figure.byName('via');
      var conjunctio = Figure.byName('conjunctio');
      expect(puer.getCompanyType(puer), 'simple');
      expect(puer.getCompanyType(puella), 'compound');
      expect(puer.getCompanyType(rubeus), 'demi-simple');
      expect(puer.getCompanyType(via), 'capitular');
      expect(puer.getCompanyType(conjunctio), '');
      expect(puella.getCompanyType(puella), 'simple');
    });

    test('should render as text', () {
      var puer = Figure.byName('puer');
      expect(puer.toTextFigure(), ' * \n * \n* *\n * ');
    });
  });
}
