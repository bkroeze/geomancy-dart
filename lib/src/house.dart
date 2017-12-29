part of geomancy;

class House {
  int index;
  Figure figure;
  bool querent;
  bool quesited;

  House(index, {Figure figure: null, bool querent: false, bool quesited: false}) {
    this.index = index;
    this.figure = figure;
    this.querent = querent;
    this.quesited = quesited;
  }

  bool equals (House other) {
    if (other == null) return false;
    return other.index == index;
  }

  int indexPlus (delta) {
    return houseRange(index + delta);
  }

  /// returns the companion house index.
  int get companion {
    bool isEven = index % 2 == 0;
    return indexPlus(isEven ? 1 : -1);
  }

  List<int> get trines {
    return [indexPlus(4), indexPlus(8)];
  }

  bool isTrineTo (House other) {
    return trines.indexOf(other.index) > -1;
  }

  List<int> get squares {
    return [indexPlus(3), indexPlus(-3)];
  }

  bool isSquareTo (House other) {
    return squares.indexOf(other.index) > -1;
  }

  List<int> get sextiles {
    return [indexPlus(2), indexPlus(-2)];
  }

  bool isSextileTo (House other) {
    return sextiles.indexOf(other.index) > -1;
  }

  int get opposition {
    return this.indexPlus(6);
  }

  bool isOpposedTo (House other) {
    return this.opposition == other.index;
  }

  List<int> get parents {
    if (this.index < 8) {
      return [];
    }
    return [(this.index - 8) * 2, (this.index - 8) * 2 + 1];
  }

  String getCompanyType (House other) {
    return this.figure.getCompanyType(other.figure);
  }

  bool hasFigure (House other) {
    if (other == null) {
      return false;
    }
    return figure.equals(other.figure);
  }

  bool isLessThan (House other, House quesited) {
    num otherIx = other.index - quesited.index;
    return index < otherIx;
  }

  bool isSinisterOf (House other) {
    List<int> range = new List<int>(6);
    for (int i = 1; i < 6; i++) {
      range[i] = indexPlus(i);
    }
    return range.indexOf(other.index) > -1;
  }

  bool isDexterOf (House other) {
    return (other.index != index && other.index != indexPlus(6) && !isSinisterOf(other));
  }

  int get strength {
    if (figure == null) {
      return 0;
    }
    return figure.getStrength(index);
  }

  List<House> getNeighbors (List<House> houses) {
    return [
      houses[indexPlus(-1)],
      houses[indexPlus(1)]
    ];
  }

  bool isNextTo (House other) {
    return (
      other.index == indexPlus(-1) ||
      other.index == indexPlus(1)
    );
  }
}
