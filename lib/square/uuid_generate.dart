import 'package:uuid/uuid.dart';

class UUIDGenerate {
  var uuid = const Uuid();

  // Generate a v4 (random) id
  String generateCode() => uuid.v4();
}
