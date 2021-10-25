// ignore_for_file: avoid_print

import 'package:flutter_test/flutter_test.dart';
import 'package:imu_processor/imu_processor/imu_data.dart';

void feedDataVar(ImuData data, int numPoints, int varMode) {
  for (int i = 0; i < numPoints; i++) {
    int ts = i ~/ 10;
    int hn = i ~/ 100;
    int sign = 1;
    if (i % varMode == 1) {
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
    ImuData idat = ImuData();

    feedDataVar(idat, 100, 10);

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
    ImuData idat = ImuData();

    feedDataVar(idat, 100, 1);

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
