import 'package:flutter_test/flutter_test.dart';
import 'package:imu_processor/imu_processor/imu_config.dart';

void main() {
  testWidgets('config basic...', (tester) async {
    var config = ImuConfig(null, aAccThreshold: 5.0);
    //print(config);
    expect(config.getYieldDataSecGap(), 10);
    expect(config.getYieldMinSamples(), 3);
    expect(config.getAccThreshold(), 5.0);
    expect(config.getImuRecordPump(), null);
  });
}
