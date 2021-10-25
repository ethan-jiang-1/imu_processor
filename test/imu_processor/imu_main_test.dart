// ignore_for_file: avoid_print

import 'package:flutter_test/flutter_test.dart';
import 'package:imu_processor/imu_processor/imu_config.dart';
import 'package:imu_processor/imu_processor/imu_data.dart';
import 'package:imu_processor/imu_processor/imu_processor.dart';

int cntRecord = 0;
void logRecord(
    DateTime dt, int duration, double distanceInMeter, double burnKiloCalorie) {
  print(
      // ignore: unnecessary_brace_in_string_interps
      "get record ${cntRecord}: ${dt}  ${duration}  ${distanceInMeter} ${burnKiloCalorie}");
  cntRecord += 1;
}

List<List<double>> genImuData(int numPoints) {
  List<List<double>> lst = [];
  for (int i = 0; i < numPoints; i++) {
    int ts = 0;
    int sign = 1;
    if (i % 2 == 1) {
      sign = -1;
    }
    int hn = i ~/ 100;
    if (hn % 2 == 0) {
      lst.add([
        ts.toDouble(),
        sign * 1.0,
        sign * 1.0,
        sign * 1.0,
        1.0 + i,
        1.0 + i,
        1.0 + i
      ]);
    } else {
      lst.add([
        ts.toDouble(),
        sign * 0.5,
        sign * 0.5,
        sign * 0.5,
        1.0 + i,
        1.0 + i,
        1.0 + i
      ]);
    }
  }
  return lst;
}

void main() {
  testWidgets('imu processor 675/10 ...', (tester) async {
    var config = ImuConfig(logRecord, aAccThreshold: 1.0);
    var processor = ImuProcessor(config);
    var data = ImuData(aSampleRate:1000); // for testing alter rate here, should be 50 by default

    List<List<double>> lst = genImuData(675);
    for (int i = 0; i < lst.length; i++) {
      List<double> imu = lst[i];
      var ret = data.feed(
          imu[0].toInt(), imu[1], imu[2], imu[3], imu[4], imu[5], imu[6]);
      if (!ret) {
        break;
      }
    }

    cntRecord = 0;
    processor.process(data);
    expect(cntRecord, 4);
  });
  testWidgets('imu processor 1080/10 ...', (tester) async {
    var config = ImuConfig(logRecord, aAccThreshold: 1.0);
    var processor = ImuProcessor(config);
    var data = ImuData(aSampleRate:2000); // for testing alter rate here, should be 50 by default

    List<List<double>> lst = genImuData(1080);
    for (int i = 0; i < lst.length; i++) {
      List<double> imu = lst[i];
      var ret = data.feed(
          imu[0].toInt(), imu[1], imu[2], imu[3], imu[4], imu[5], imu[6]);
      if (!ret) {
        break;
      }
    }


    cntRecord = 0;
    processor.process(data);
    expect(cntRecord, 6);
  });
}
