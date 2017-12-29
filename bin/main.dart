import 'package:dartson/dartson.dart';

// import 'package:geomancy_dart/geomancy_dart.dart' as geomancy_dart;


main(List<String> arguments) {
  Map work = {
    'name': 'Puer',
    'english': 'Boy',
    'flags': '1011',
    'houses': {'strong': 0, 'weak': 6}
  };
  var dson = new Dartson.JSON();

  String j = dson.encode(work);
  print(j);
}
