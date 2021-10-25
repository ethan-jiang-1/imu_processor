import 'package:flutter_test/flutter_test.dart';
import 'package:imu_processor/imu_processor/imu_data.dart';

void main() {
  testWidgets('imu data feed groupcheck0...', (tester) async {
    ImuData idat = ImuData();
    //print(idat);

    expect(idat.checkDataAcceptable(0), true);
    expect(idat.checkDataAcceptable(0), true);
    expect(idat.checkDataAcceptable(1), true);
    expect(idat.checkDataAcceptable(2), true);
    expect(idat.checkDataAcceptable(5), false);

    expect(idat.getTimeStampStart(), 0);
    expect(idat.getTimeStampEnd(), 2);
  });

  testWidgets('imu data feed groupcheck1...', (tester) async {
    ImuData idat = ImuData();
    //print(idat);

    expect(idat.checkDataAcceptable(5), true);
    expect(idat.checkDataAcceptable(5), true);
    expect(idat.checkDataAcceptable(6), true);
    expect(idat.checkDataAcceptable(7), true);
    expect(idat.checkDataAcceptable(5), false);

    expect(idat.getTimeStampStart(), 5);
    expect(idat.getTimeStampEnd(), 7);
  });

  testWidgets('imu data feed one_group with 2 items...', (tester) async {
    ImuData idat = ImuData();
    //print(idat);

    idat.feed(0, 1.0, 1.1, 1.2, 2.0, 2.1, 2.2);
    idat.feed(0, 1.1, 1.2, 1.3, 2.1, 2.2, 2.3);

    var imu = idat.getLstImu();
    //print(acce);
    expect(imu.length, 2);
  });
  testWidgets('imu data feed one_goupe with 20 items ...', (tester) async {
    ImuData idat = ImuData();
    //print(idat);

    for (int i = 0; i < 10; i++) {
      idat.feed(0, 1.0 + i, 1.1, 1.2, 2.0, 2.1, 2.2);
      idat.feed(0, 1.1 + i, 1.2, 1.3, 2.1, 2.2, 2.3);
    }

    var imu = idat.getLstImu();
    //print(acce);
    expect(imu.length, 20);
  });
  testWidgets('imu data feed 40 items not in same group  ...', (tester) async {
    ImuData idat = ImuData();
    bool ret0 = false;
    bool ret1 = false;
    bool ret2 = false;
    //print(idat);
    for (int i = 0; i < 10; i++) {
      ret0 = idat.feed(0, 1.0 + i, 1.1, 1.2, 2.0, 2.1, 2.2);
    }
    for (int i = 0; i < 10; i++) {
      ret1 = idat.feed(1, 10.0 + i, 1.1, 1.2, 2.0, 2.1, 2.2);
    }
    for (int i = 0; i < 10; i++) {
      ret2 = idat.feed(10, 20.0 + i, 1.1, 1.2, 2.0, 2.1, 2.2);
    }

    var imu = idat.getLstImu();
    //print(acce);
    expect(imu.length, 20);
    expect(ret0, true);
    expect(ret1, true);
    expect(ret2, false);
  });
}
