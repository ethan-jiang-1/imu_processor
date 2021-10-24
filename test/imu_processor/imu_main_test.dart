import 'package:flutter_test/flutter_test.dart';
import 'package:imu_processor/imu_processor/imu_config.dart';
import 'package:imu_processor/imu_processor/imu_data.dart';
import 'package:imu_processor/imu_processor/imu_processor.dart';

int cnt_record = 0;
void logRecord(
    DateTime dt, int duration, double distanceInMeter, double burnKiloCalorie) {
  print(
      "get record ${cnt_record}: ${dt}  ${duration}  ${distanceInMeter} ${burnKiloCalorie}");
  cnt_record += 1;
}

void feed_data(data, num_points) {
  for (int i = 0; i < num_points; i++) {
    int ts = (i / 10).toInt();
    int hn = (i / 100).toInt();
    if (hn % 2 == 0) {
      data.feed(ts, 1.0, 1.0, 1.0, 1.0 + i, 1.0 + i, 1.0 + i);
    } else {
      data.feed(ts, 0.5, 0.5, 0.5, 1.0 + i, 1.0 + i, 1.0 + i);
    }
  }
}

void main() {
  testWidgets('imu processor 675/10 ...', (tester) async {
    var config = ImuConfig(logRecord, aAccThreshold: 1.0);
    var processor = ImuProcessor(config);
    var data = ImuData(10);

    feed_data(data, 675);

    cnt_record = 0;
    processor.process(data);
    expect(cnt_record, 4);
  });
  testWidgets('imu processor 1080/10 ...', (tester) async {
    var config = ImuConfig(logRecord, aAccThreshold: 1.0);
    var processor = ImuProcessor(config);
    var data = ImuData(10);

    feed_data(data, 1080);

    cnt_record = 0;
    processor.process(data);
    expect(cnt_record, 6);
  });
}
