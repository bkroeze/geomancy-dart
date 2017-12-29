import 'package:geomancy_dart/geomancy.dart';
import 'package:test/test.dart';

List<House> getHouses([int count = 12]) {
  var houses = new List<House>(count);
  for (int i=0; i<count; i++) {
    houses[i] = new House(i);
  }
  return houses;
}

void main() {
  group('Houses', () {
    test('Should know its company type', () {
      var via = new House(0, figure: Figure.byName('via'));
      var via2 = new House(1, figure: Figure.byName('via'));
      expect(via.getCompanyType(via2), 'simple');

      var carcer = new House(1, figure: Figure.byName('carcer'));
      expect(via.getCompanyType(carcer), 'capitular');
      expect(carcer.getCompanyType(via), 'capitular');

      var albus = new House(0, figure: Figure.byName('albus'));
      var conjunctio = new House(2, figure: Figure.byName('conjunctio'));
      expect(albus.getCompanyType(conjunctio), 'demi-simple');
      expect(conjunctio.getCompanyType(albus), 'demi-simple');

      var rubeus = new House(2, figure: Figure.byName('rubeus'));
      expect(albus.getCompanyType(rubeus), 'compound');
      expect(rubeus.getCompanyType(albus), 'compound');
    });

    test('should test figure equality', () {
      var via = new House(0, figure: Figure.byName('via'));
      var via2 = new House(1, figure: Figure.byName('via'));
      var rubeus = new House(2, figure: Figure.byName('rubeus'));
      var empty = new House(3);
      expect(via.hasFigure(null), false);
      expect(via.hasFigure(empty), false);
      expect(via.hasFigure(via2), true);
      expect(via.hasFigure(rubeus), false);
    });

    test('should have strength', () {
      var via = new House(0, figure: Figure.byName('via'));
      expect(via.strength, 0);
      var empty = new House(3);
      expect(empty.strength, 0);
    });

    test('should get Neighbors', () {
      var houses = getHouses();
      expect(houses[0].getNeighbors(houses), [houses[11], houses[1]]);
      expect(houses[6].getNeighbors(houses), [houses[5], houses[7]]);
    });

    test('should have equals', () {
      var houses = getHouses();
      expect(houses[0].equals(houses[0]), true);
      expect(houses[1].equals(houses[1]), true);
      expect(houses[0].equals(houses[1]), false);
      expect(houses[10].equals(houses[5]), false);
    });

    test('should know its neighbors', () {
      var houses = getHouses();
      var h = new House(6);
      expect(h.isNextTo(houses[2]), false);
      expect(h.isNextTo(houses[5]), true);
      expect(h.isNextTo(houses[7]), true);
      expect(h.isNextTo(houses[10]), false);
    });

    test('should know its neighbors, wrapping around', () {
      var houses = getHouses();
      var h = new House(0);
      expect(h.isNextTo(houses[4]), false);
      expect(h.isNextTo(houses[1]), true);
      expect(h.isNextTo(houses[11]), true);
      expect(h.isNextTo(houses[10]), false);
    });

    test('should compare less than', () {
      var houses = getHouses();
      var h = new House(6);
      expect(h.isLessThan(houses[7], houses[0]), true);
      expect(h.isLessThan(houses[5], houses[0]), false);
      expect(h.isLessThan(houses[0], houses[0]), false);
      expect(h.isLessThan(houses[10], houses[0]), true);
      expect(h.isLessThan(houses[10], houses[8]), false);
    });

    test('should know its aspects', () {
      var h = new House(0);
      var houses = getHouses();
      expect(h.trines, [4, 8]);
      expect(h.isTrineTo(houses[4]), true);
      expect(h.isTrineTo(houses[5]), false);

      expect(h.squares, [3, 9]);
      expect(h.isSquareTo(houses[3]), true);
      expect(h.isSquareTo(houses[5]), false);

      expect(h.sextiles, [2, 10]);
      expect(h.isSextileTo(houses[10]), true);
      expect(h.isSextileTo(houses[5]), false);

      expect(h.opposition, 6);
      expect(h.isOpposedTo(houses[6]), true);
      expect(h.isOpposedTo(houses[5]), false);
    });

    test('should know sinister/dexter', () {
      var houses = getHouses();
      var h = new House(0);
      expect(h.isSinisterOf(houses[1]), true);
      expect(h.isDexterOf(houses[2]), false);
      expect(h.isSinisterOf(houses[2]), true);
      expect(h.isSinisterOf(houses[5]), true);
      expect(h.isDexterOf(houses[5]), false);
      expect(h.isSinisterOf(houses[6]), false);
      expect(h.isDexterOf(houses[6]), false);
      expect(h.isSinisterOf(houses[11]), false);
      expect(h.isDexterOf(houses[11]), true);
    });

    test('should know sinister too', () {
      var houses = getHouses();
      var h = new House(6);
      expect(h.isSinisterOf(houses[1]), false);
      expect(h.isSinisterOf(houses[2]), false);
      expect(h.isSinisterOf(houses[5]), false);
      expect(h.isSinisterOf(houses[0]), false);
      expect(h.isSinisterOf(houses[7]), true);
      expect(h.isSinisterOf(houses[11]), true);
    });

    test('should know its parents', () {
      var houses = getHouses(15);
      for (var i = 0; i < 8; i++) {
        expect(houses[i].parents, []);
      }
      expect(houses[8].parents, [0, 1]);
      expect(houses[9].parents, [2, 3]);
      expect(houses[10].parents, [4, 5]);
      expect(houses[11].parents, [6, 7]);
      expect(houses[12].parents, [8, 9]);
      expect(houses[13].parents, [10, 11]);
      expect(houses[14].parents, [12, 13]);
    });

    test('should know its companion', () {
      var houses = getHouses();
      expect(houses[0].companion, 1);
      expect(houses[1].companion, 0);
      expect(houses[2].companion, 3);
      expect(houses[3].companion, 2);
      expect(houses[4].companion, 5);
      expect(houses[5].companion, 4);
      expect(houses[6].companion, 7);
      expect(houses[7].companion, 6);
      expect(houses[8].companion, 9);
      expect(houses[9].companion, 8);
      expect(houses[10].companion, 11);
      expect(houses[11].companion, 10);
    });
  });
}
