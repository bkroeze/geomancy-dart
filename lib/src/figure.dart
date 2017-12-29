part of geomancy;

const List<List<String>> COMPANY_DEMI_SIMPLE = const [
    const ['carcer', 'tristitia', 'cauda-draconis'],
    const ['acquisitio', 'laetitia', 'caput-draconis'],
    const ['puer', 'rubeus', 'cauda-draconis'],
    const ['fortuna-major', 'fortuna-minor'],
    const ['amisso', 'puella', 'caput-draconis'],
    const ['albus', 'conjunctio'],
    const ['populus', 'via']
];

const List<List<String>> COMPANY_COMPOUND = const [
  const ['puer', 'puella'],
  const ['amisso', 'acquisitio'],
  const ['albus', 'rubeus'],
  const ['populus', 'via'],
  const ['fortuna-major', 'fortuna-minor'],
  const ['conjunctio', 'carcer'],
  const ['tristitia', 'laetitia'],
  const ['cauda-draconis', 'caput-draconis']
];

/// A Geomantic Figure
class Figure {
  Map _details;
  bool earth;
  bool water;
  bool air;
  bool fire;

  /// Construct [Figure] using [flags] a 4 character string of 0 or 1, with 1 meaning passive
  Figure(flags) {
    this.flags = flags;
  }

  /// Gets one [Figure] by name.
  static Figure byName (String name) {
    String key = slugify(name);
    var figures = _getFigures();
    if (figures.containsKey(key)) {
      return figures[key];
    }
    throw new RangeError('Figure Not Found: $name');
  }

  /// Gets one [Figure] by its [flags].
  static Figure byFlags (String flags) {
    var figureDetails = _getFigureDetails();
    if (!figureDetails.containsKey(flags)) {
      throw new RangeError('Figure Not Found for flags: $flags');
    }
    Map details = figureDetails[flags];
    return Figure.byName(details['name']);
  }

  /// Gets a [Figure] by [elements] map.
  static Figure byElements (Map<String, bool> elements) {
    var flags = (
      zero1(elements['earth']) +
      zero1(elements['water']) +
      zero1(elements['air']) +
      zero1(elements['fire'])
    );

    return Figure.byFlags(flags);
  }

  /// Get the associated details for the figure.
  Map get details {
    if (_details == null) {
      var figureDetails = _getFigureDetails();
      if (!figureDetails.containsKey(flags)) {
        throw new RangeError('No such figure with flags: $flags');
      }
      _details = figureDetails[flags];
    }
    return _details;
  }

  /// Gets the [flags] of this figure which is a unique
  /// 4-character string, right to left, showing
  /// active (0) or passive (1) of the elements:
  /// fire, air, water, earth.
  String get flags {
    return (
      zero1(earth)
      + zero1(water)
      + zero1(air)
      + zero1(fire)
    );
  }

  void set flags (String raw) {
    String work = raw;
    while(work.length < 4) {
      work = '0$work';
    }

    this._details = null;
    this.earth = work[0] == '1';
    this.water = work[1] == '1';
    this.air = work[2] == '1';
    this.fire = work[3] == '1';
  }

  String get name {
    return details['name'];
  }

  int get number {
    return int.parse(flags);
  }

  String get slug {
    return slugify(name);
  }

  bool equals (Figure other) {
    if (other == null) {
      return false;
    }
    return other.flags == flags;
  }

  String getCompanyType (Figure other) {
    if (other.equals(this)) {
      return 'simple';
    }

    String me = slug;
    String them = other.slug;

    for (List<String> figureSet in COMPANY_DEMI_SIMPLE) {
      if (figureSet.indexOf(me) > -1 && figureSet.indexOf(them) > -1) {
        return 'demi-simple';
      }
    }

    for (List<String> figureSet in COMPANY_COMPOUND) {
      if (figureSet.indexOf(me) > -1 && figureSet.indexOf(them) > -1) {
        return 'compound';
      }
    }

    if (fire == other.fire) {
      return 'capitular';
    }

    return '';
  }

  bool getLine (ix) {
    List<bool> elements = [fire, air, water, earth];
    RangeError.checkValidIndex(ix, elements);
    return elements[ix];
  }

  int getActivePoints () {
    return (fire ? 1 : 0) + (air ? 1 : 0) + (water ? 1 : 0) + (earth ? 1 : 0);
  }

  int getPoints () {
    return (fire ? 1 : 2) + (air ? 1 : 2) + (water ? 1 : 2) + (earth ? 1 : 2);
  }

  int getStrength (house) {
    int shouldBeStrong = 0;
    if (details['houses']['strong'] == house) shouldBeStrong++;
    else if (details['houses']['weak'] == house) shouldBeStrong--;
    return shouldBeStrong;
  }

  Figure add (Figure other) {
    String computed = (
      zero1(xor(earth, other.earth)) +
      zero1(xor(water, other.water)) +
      zero1(xor(air, other.air)) +
      zero1(xor(fire, other.fire))
    );
    return Figure.byFlags(computed);
  }

  String toJSON () {
    var dson = new Dartson.JSON();
    return dson.encode(details);
  }

  String toTextFigure ({String letter: '*', int width: 3}) {
    lineToText(element) {
      String work = element ? letter : '${letter} ${letter}';
      while (work.length < width) {
        work = (work.length % 2 == 1) ? ' ${work}' : '${work} ';
      }
      return work;
    };
    return [
      lineToText(fire),
      lineToText(air),
      lineToText(water),
      lineToText(earth)
    ].join('\n');
  }
}

Map<String, Figure> _figures = new Map();

Map<String, Map> _figureDetails = new Map();

makeFigures() {
  // note that the houses are in zero-index order
  List<Map> figureDefs = [
    {
      'name': 'Puer',
      'english': 'Boy',
      'flags': '1011',
      'houses': {'strong': 0, 'weak': 6}
    }, {
      'name': 'Amisso',
      'english': 'Loss',
      'flags': '0101',
      'houses': {'strong': 1, 'weak': 7}
    }, {
      'name': 'Albus',
      'english': 'White',
      'flags': '0100',
      'houses': {'strong': 2, 'weak': 8}
    }, {
      'name': 'Populus',
      'english': 'People',
      'flags': '0000',
      'houses': {'strong': 3, 'weak': 9}
    }, {
      'name': 'Fortuna Major',
      'english': 'Greater Fortune',
      'flags': '1100',
      'houses': {'strong': 4, 'weak': 10}
    }, {
      'name': 'Conjunctio',
      'english': 'Confunction',
      'flags': '0110',
      'houses': {'strong': 5, 'weak': 11}
    }, {
      'name': 'Puella',
      'english': 'Girl',
      'flags': '1101',
      'houses': {'strong': 6, 'weak': 0}
    }, {
      'name': 'Rubeus',
      'english': 'Red',
      'flags': '0010',
      'houses': {'strong': 7, 'weak': 1}
    }, {
      'name': 'Acquisitio',
      'english': 'Gain',
      'flags': '1010',
      'houses': {'strong': 8, 'weak': 2}
    }, {
      'name': 'Carcer',
      'english': 'Prison',
      'flags': '1001',
      'houses': {'strong': 9, 'weak': 3}
    }, {
      'name': 'Tristitia',
      'english': 'Sorrow',
      'flags': '1000',
      'houses': {'strong': 10, 'weak': 4}
    }, {
      'name': 'Laetitia',
      'english': 'Joy',
      'flags': '0001',
      'houses': {'strong': 11, 'weak': 5}
    }, {
      'name': 'Cauda Draconis',
      'english': 'Tail of the Dragon',
      'flags': '0111',
      'houses': {'strong': 8, 'weak': 2}
    }, {
      'name': 'Caput Draconis',
      'english': 'Head of the Dragon',
      'flags': '1110',
      'houses': {'strong': 5, 'weak': 11}
    }, {
      'name': 'Fortuna Minor',
      'english': 'Lesser Fortune',
      'flags': '0011',
      'houses': {'strong': 4, 'weak': 10}
    }, {
      'name': 'Via',
      'english': 'Way',
      'flags': '1111',
      'houses': {'strong': 3, 'weak': 9}
    }
  ];
  for (Map details in figureDefs) {
    _figureDetails[details['flags']] = details;
    Figure figure = new Figure(details['flags']);
    String name = slugify(details['name']);
    _figures[name] = figure;
  }
}

Map<String, Figure> _getFigures() {
  if (_figures.isEmpty) {
    makeFigures();
  }
  return _figures;
}

Map<String, Map> _getFigureDetails() {
  if (_figureDetails.isEmpty) {
    makeFigures();
  }
  return _figureDetails;
}
