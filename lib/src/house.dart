part of geomancy;

/// A Geomantic House
class House {

  int index;
  Figure figure;
  bool querent;
  bool quesited;

  House(index, {Figure figure: null, bool querent: false, bool quesited: false}) {
    /// The index of the house (0-based)
    this.index = index;
    /// The figure, if any, in this house
    this.figure = figure;
    /// Boolean indicating if this house is for the querent
    this.querent = querent;
    /// Boolean indicating if this house is for the quesited
    this.quesited = quesited;
  }

  /// equality comparison
  bool equals (House other) {
    if (other == null) return false;
    return other.index == index;
  }

  /// returns the index, wrapped around the chart axis if needed
  int indexPlus (delta) {
    return houseRange(index + delta);
  }

  /// returns the companion house index.
  int get companion {
    bool isEven = index % 2 == 0;
    return indexPlus(isEven ? 1 : -1);
  }

  /// returns indexes of this house's trines
  List<int> get trines {
    return [indexPlus(4), indexPlus(8)];
  }

  /// tests whether [other] is trine to this
  bool isTrineTo (House other) {
    return trines.indexOf(other.index) > -1;
  }

  /// returns indexes of this house's squares
  List<int> get squares {
    return [indexPlus(3), indexPlus(-3)];
  }

  /// tests whether [other] is square to this
  bool isSquareTo (House other) {
    return squares.indexOf(other.index) > -1;
  }

  /// returns indexes of this house's sextiles
  List<int> get sextiles {
    return [indexPlus(2), indexPlus(-2)];
  }

  /// tests whether [other] is sextile to this
  bool isSextileTo (House other) {
    return sextiles.indexOf(other.index) > -1;
  }

  /// returns the index of this house's opposition
  int get opposition {
    return this.indexPlus(6);
  }

  /// tests whether [other] is opposed to this
  bool isOpposedTo (House other) {
    return this.opposition == other.index;
  }

  /// returns a list of the indexes of parents for this house
  List<int> get parents {
    if (this.index < 8) {
      return [];
    }
    return [(this.index - 8) * 2, (this.index - 8) * 2 + 1];
  }

  /// gets the company type for this house in relation to [other]
  String getCompanyType (House other) {
    return this.figure.getCompanyType(other.figure);
  }

  /// tests whether [other] has the same figure as this
  bool hasFigure (House other) {
    if (other == null) {
      return false;
    }
    return figure.equals(other.figure);
  }

  /// tests whether this house is to the clockwise of [other] given the [quesited] position
  bool isLessThan (House other, House quesited) {
    num otherIx = other.index - quesited.index;
    return index < otherIx;
  }

  /// tests whether this house is sinister to [other]
  bool isSinisterOf (House other) {
    List<int> range = new List<int>(6);
    for (int i = 1; i < 6; i++) {
      range[i] = indexPlus(i);
    }
    return range.indexOf(other.index) > -1;
  }

  /// tests whether this house is dexter to [other]
  bool isDexterOf (House other) {
    return (other.index != index && other.index != indexPlus(6) && !isSinisterOf(other));
  }

  /// returns the strength of this [figure] in this house, if any.
  int get strength {
    if (figure == null) {
      return 0;
    }
    return figure.getStrength(index);
  }

  /// returns a list of neighboring houses.
  List<House> getNeighbors (List<House> houses) {
    return [
      houses[indexPlus(-1)],
      houses[indexPlus(1)]
    ];
  }

  /// tests whether [other] is a neighbor.
  bool isNextTo (House other) {
    return (
      other.index == indexPlus(-1) ||
      other.index == indexPlus(1)
    );
  }
}
