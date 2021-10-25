import 'package:flutter_test/flutter_test.dart';
import 'package:imu_processor/imu_processor/imu_data.dart';

void feed_data_var(ImuData data, int num_points, int var_mode) {
  for (int i = 0; i < num_points; i++) {
    int ts = (i / 10).toInt();
    int hn = (i / 100).toInt();
    int sign = 1;
    if (i % var_mode == 1) {
      sign = -1;
    }
    if (hn % 2 == 0) {
      data.feed(
          ts, sign * 1.0, sign * 1.0, sign * 1.0, 1.0 + i, 1.0 + i, 1.0 + i);
    } else {
      data.feed(
          ts, sign * 0.5, sign * 0.5, sign * 0.5, 1.0 + i, 1.0 + i, 1.0 + i);
    }
  }
}

void main() {
  testWidgets('imu data gravity filter0...', (tester) async {
    ImuData idat = ImuData(50);

    feed_data_var(idat, 100, 10);

    List lstAcce0 = idat.getAverageAcce();
    print(lstAcce0);
    idat.removeGravity();
    List lstAcce1 = idat.getAverageAcce();
    print(lstAcce1);

    expect((lstAcce1[0] * 10).toInt(), 0);
    expect((lstAcce1[0] * 10).toInt(), 0);
    expect((lstAcce1[0] * 10).toInt(), 0);
  });
  testWidgets('imu data gravity filter1...', (tester) async {
    ImuData idat = ImuData(50);

    feed_data_var(idat, 100, 1);

    List lstAcce0 = idat.getAverageAcce();
    print(lstAcce0);
    idat.removeGravity();
    List lstAcce1 = idat.getAverageAcce();
    print(lstAcce1);

    expect((lstAcce1[0] * 10).toInt(), 0);
    expect((lstAcce1[0] * 10).toInt(), 0);
    expect((lstAcce1[0] * 10).toInt(), 0);
  });
}
