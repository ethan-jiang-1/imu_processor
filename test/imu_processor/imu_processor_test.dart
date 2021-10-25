import 'package:flutter_test/flutter_test.dart';
import 'package:imu_processor/imu_processor/imu_config.dart';
import 'package:imu_processor/imu_processor/imu_processor.dart';

void main() {
  testWidgets('imu processor getMovementLevel ...', (tester) async {
    var config = ImuConfig(null, aAccThreshold: 1.0);
    var processor = ImuProcessor(config);

    List<List<double>> imus = [];
    for (int i = 0; i < 3; i++) {
      List<double> imu1 = [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 0.0];
      imus.add(imu1);
    }
    for (int i = 0; i < 3; i++) {
      List<double> imu2 = [0.5, 0.5, 0.5, 0.0, 0.0, 0.0, 0.0];
      imus.add(imu2);
    }
    int mv0 = processor.getMovmentLevel(imus, 0);
    expect(mv0, 1);
    int mv1 = processor.getMovmentLevel(imus, 1);
    expect(mv1, 1);
    int mv2 = processor.getMovmentLevel(imus, 2);
    expect(mv2, 1);
    int mv3 = processor.getMovmentLevel(imus, 3);
    expect(mv3, 1);
    int mv4 = processor.getMovmentLevel(imus, 4);
    expect(mv4, 0);
    int mv5 = processor.getMovmentLevel(imus, 5);
    expect(mv5, 0);
    int mv6 = processor.getMovmentLevel(imus, 6);
    expect(mv6, 0);
    int mv7 = processor.getMovmentLevel(imus, 7);
    expect(mv7, 0);
  });
}
