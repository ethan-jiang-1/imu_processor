import 'package:flutter_test/flutter_test.dart';
import 'package:imu_processor/imu_processor/imu_config.dart';

void main() {
  testWidgets('config basic...', (tester) async {
    var config = new ImuConfig(null, aAccThreshold: 5.0);
    //print(config);
    expect(config.getAccThreshold(), 5.0);
  });
}
