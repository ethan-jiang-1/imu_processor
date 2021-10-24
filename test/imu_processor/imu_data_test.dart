import 'package:flutter_test/flutter_test.dart';
import 'package:imu_processor/imu_processor/imu_data.dart';

void main() {
  testWidgets('imu data feed groupcheck0...', (tester) async {
    ImuData id = ImuData(50);
    //print(id);

    expect(id.checkDataAcceptable(0), true);
    expect(id.checkDataAcceptable(0), true);
    expect(id.checkDataAcceptable(1), true);
    expect(id.checkDataAcceptable(2), true);
    expect(id.checkDataAcceptable(5), false);

    expect(id.getTimeStampStart(), 0);
    expect(id.getTimeStampEnd(), 2);
  });

  testWidgets('imu data feed groupcheck1...', (tester) async {
    ImuData id = ImuData(50);
    //print(id);

    expect(id.checkDataAcceptable(5), true);
    expect(id.checkDataAcceptable(5), true);
    expect(id.checkDataAcceptable(6), true);
    expect(id.checkDataAcceptable(7), true);
    expect(id.checkDataAcceptable(5), false);

    expect(id.getTimeStampStart(), 5);
    expect(id.getTimeStampEnd(), 7);
  });

  testWidgets('imu data feed one_group with 2 items...', (tester) async {
    ImuData id = ImuData(50);
    //print(id);

    id.feed(0, 1.0, 1.1, 1.2, 2.0, 2.1, 2.2);
    id.feed(0, 1.1, 1.2, 1.3, 2.1, 2.2, 2.3);

    var imu = id.getLstImu();
    //print(acce);
    expect(imu.length, 2);
  });
  testWidgets('imu data feed one_goupe with 20 items ...', (tester) async {
    ImuData id = ImuData(50);
    //print(id);

    for (int i = 0; i < 10; i++) {
      id.feed(0, 1.0 + i, 1.1, 1.2, 2.0, 2.1, 2.2);
      id.feed(0, 1.1 + i, 1.2, 1.3, 2.1, 2.2, 2.3);
    }

    var imu = id.getLstImu();
    //print(acce);
    expect(imu.length, 20);
  });
  testWidgets('imu data feed 40 items not in same group  ...', (tester) async {
    ImuData id = ImuData(50);
    var ret0;
    var ret1;
    var ret2;
    //print(id);
    for (int i = 0; i < 10; i++) {
      ret0 = id.feed(0, 1.0 + i, 1.1, 1.2, 2.0, 2.1, 2.2);
    }
    for (int i = 0; i < 10; i++) {
      ret1 = id.feed(1, 10.0 + i, 1.1, 1.2, 2.0, 2.1, 2.2);
    }
    for (int i = 0; i < 10; i++) {
      ret2 = id.feed(10, 20.0 + i, 1.1, 1.2, 2.0, 2.1, 2.2);
    }

    var imu = id.getLstImu();
    //print(acce);
    expect(imu.length, 20);
    expect(ret0, true);
    expect(ret1, true);
    expect(ret2, false);
  });
}
