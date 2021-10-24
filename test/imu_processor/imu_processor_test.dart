import 'package:flutter_test/flutter_test.dart';
import 'package:imu_processor/imu_processor/imu_config.dart';
import 'package:imu_processor/imu_processor/imu_processor.dart';

void main() {
  testWidgets('imu processor getMovementLevel ...', (tester) async {
    var config = ImuConfig(null, aAccThreshold: 1.0);
    var processor = ImuProcessor(config);

    List<double> imu1 = [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 0.0];
    int mv1 = processor.getMovmentLevel(imu1);
    //print(mv1);
    expect(mv1, 1);

    List<double> imu2 = [0.5, 0.5, 0.5, 0.0, 0.0, 0.0, 0.0];
    int mv2 = processor.getMovmentLevel(imu2);
    //print(mv2);
    expect(mv2, 0);
  });
}
