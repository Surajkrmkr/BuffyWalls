import 'package:flutter_test/flutter_test.dart';
import 'package:buffywalls/app/app.locator.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('FavouriteViewModel Tests -', () {
    setUp(() => registerServices());
    tearDown(() => locator.reset());
  });
}
