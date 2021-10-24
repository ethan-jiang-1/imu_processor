import 'dart:math';

import 'package:imu_processor/imu_processor/imu_config.dart';
import 'package:imu_processor/imu_processor/imu_data.dart';

class ImuProcessor {
  ImuConfig? _mImuConfig;

  ImuProcessor(ImuConfig config) {
    _mImuConfig = config;
  }

  int getMovmentLevel(List<double> imu) {
    double ax = imu[0];
    double ay = imu[1];
    double az = imu[2];
    double acct = _mImuConfig!.getAccThreshold();

    double accr = sqrt(ax * ax + ay * ay + az * az);
    if (accr > acct) {
      return 1;
    }
    return 0;
  }

  bool process(ImuData imuData) {
    List<List<double>> lstImu = imuData.getLstImu();
    int len_data = lstImu.length;

    bool isStill = true;
    int lastMv = 0;
    int lastMvTimeStamp = -1;

    for (int i = 0; i < len_data; i++) {
      int mv = getMovmentLevel(lstImu[i]);
      if (isStill) {
        if (mv >= 0) {
          isStill = false;
          lastMv = mv;
        } else {}
      } else {
        if (mv == 0) {
        } else {}
      }
    }

    return true;
  }
}
