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

  bool compute_move_chunk(List<List<double>> lstImu, int mvChunkStart,
      int mvChunkEnd, int sampleRate) {
    double durationInSec = (mvChunkEnd - mvChunkStart) / sampleRate;

    DateTime dt =
        DateTime.fromMicrosecondsSinceEpoch(lstImu[mvChunkStart][6].toInt());

    double distanceInMeter = durationInSec;
    double burnKiloCalorie = distanceInMeter;

    ImuRecordPump? irp = _mImuConfig!.getImuRecordPump();
    if (irp != null) {
      irp(dt, durationInSec.toInt(), distanceInMeter, burnKiloCalorie);
    }
    return true;
  }

  bool compute_move_sequence(
      List<List<double>> lstImu, int mvNdxStart, int mvNdxEnd, int sampleRate) {
    int chunkCount = _mImuConfig!.getYieldDataSecGap() * sampleRate;

    int seqCount = mvNdxEnd - mvNdxStart;
    if (seqCount < 0) {
      print("ERROR: seqCount < 0 ?!");
      return false;
    }
    for (int i = 0; i < seqCount; i += chunkCount) {
      int chunkStart = i + mvNdxStart;
      int chunkEnd = chunkStart + chunkCount;
      if (chunkEnd > mvNdxEnd) {
        chunkEnd = mvNdxEnd;
      }
      compute_move_chunk(lstImu, chunkStart, chunkEnd, sampleRate);
    }
    return true;
  }

  bool process(ImuData imuData) {
    List<List<double>> lstImu = imuData.getLstImu();
    int sampleRate = imuData.getSampleRate();
    int len_data = lstImu.length;

    bool isStill = true;
    int lastMv = 0;
    int mvNdxStart = -1;
    int mvNdxEnd = -1;

    for (int i = 0; i < len_data; i++) {
      List<double> imu7 = lstImu[i];
      int mv = getMovmentLevel(imu7);
      if (isStill) {
        if (mv > 0) {
          // still -> move
          isStill = false;
          lastMv = mv;
          mvNdxStart = i;
        } else {
          // still -> still
        }
      } else {
        if (mv == 0) {
          // move -> still
          mvNdxEnd = i;
          compute_move_sequence(lstImu, mvNdxStart, mvNdxEnd, sampleRate);
          mvNdxStart = -1;
          mvNdxEnd = -1;
          isStill = true;
        } else {
          // move -> move

        }
      }
    }
    if (!isStill) {
      if (mvNdxStart != -1) {
        compute_move_sequence(lstImu, mvNdxStart, len_data - 1, sampleRate);
      }
    }

    return true;
  }
}
