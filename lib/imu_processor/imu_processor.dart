import 'dart:math';
import 'package:imu_processor/imu_processor/imu_config.dart';
import 'package:imu_processor/imu_processor/imu_data.dart';

class ImuProcessor {
  ImuConfig? _mImuConfig;

  ImuProcessor(ImuConfig config) {
    _mImuConfig = config;
  }

  int getMovmentLevel(List<List<double>> lstImu, int ndx) {
    double ax = 0;
    double ay = 0;
    double az = 0;

    int cnt = 0;
    for (int i = -1; i < 2; i++) {
      int indx = ndx + i;
      if ((indx >= 0) && (indx < lstImu.length)) {
        ax += lstImu[indx][0].abs();
        ay += lstImu[indx][1].abs();
        az += lstImu[indx][2].abs();
        cnt += 1;
      }
    }
    ax = ax / cnt;
    ay = ay / cnt;
    az = az / cnt;

    double acct = _mImuConfig!.getAccThreshold();

    double accr = sqrt(ax * ax + ay * ay + az * az);
    if (accr > acct) {
      return 1;
    }
    return 0;
  }

  double calKilocalorie(List<List<double>> lstImu, int mvChunkStart,
      int mvChunkEnd, int sampleRate) {
    double durationInSec = (mvChunkEnd - mvChunkStart) / sampleRate;
    double burnKiloCalorie = durationInSec;
    return burnKiloCalorie;
  }

  double calDistance(List<List<double>> lstImu, int mvChunkStart,
      int mvChunkEnd, int sampleRate) {
    double durationInSec = (mvChunkEnd - mvChunkStart) / sampleRate;
    double distanceInMeter = durationInSec;
    return distanceInMeter;
  }

  bool computeMoveChunk(List<List<double>> lstImu, int mvChunkStart,
      int mvChunkEnd, int sampleRate) {
    double durationInSec = (mvChunkEnd - mvChunkStart) / sampleRate;

    DateTime dt =
        DateTime.fromMicrosecondsSinceEpoch(lstImu[mvChunkStart][6].toInt());

    double distanceInMeter =
        calDistance(lstImu, mvChunkStart, mvChunkEnd, sampleRate);
    double burnKiloCalorie =
        calKilocalorie(lstImu, mvChunkStart, mvChunkEnd, sampleRate);

    ImuRecordPump? irpCallback = _mImuConfig!.getImuRecordPump();
    if (irpCallback != null) {
      irpCallback(dt, durationInSec.toInt(), distanceInMeter, burnKiloCalorie);
    }
    return true;
  }

  bool computeMoveSequence(
      List<List<double>> lstImu, int mvNdxStart, int mvNdxEnd, int sampleRate) {
    int chunkCount = _mImuConfig!.getYieldDataSecGap() * sampleRate;
    int minSamples = _mImuConfig!.getYieldMinSamples();

    int seqCount = mvNdxEnd - mvNdxStart;
    if (seqCount < minSamples) {
      // ignore: avoid_print
      print("WARNING: seqCount " +
          seqCount.toString() +
          " < " +
          minSamples.toString());
      return false;
    }
    for (int ndx = 0; ndx < seqCount; ndx += chunkCount) {
      int chunkStart = ndx + mvNdxStart;
      int chunkEnd = chunkStart + chunkCount;
      if (chunkEnd > mvNdxEnd) {
        chunkEnd = mvNdxEnd;
      }
      computeMoveChunk(lstImu, chunkStart, chunkEnd, sampleRate);
    }
    return true;
  }

  bool scanImuToYieldRecords(ImuData imuData) {
    List<List<double>> lstImu = imuData.getLstImu();
    int sampleRate = imuData.getSampleRate();
    int lenData = lstImu.length;

    bool isStill = true;
    //int lastMv = 0;
    int mvNdxStart = -1;
    int mvNdxEnd = -1;

    int chunkCount = _mImuConfig!.getYieldDataSecGap() * sampleRate;

    for (int ndx = 0; ndx < lenData; ndx++) {
      int mv = getMovmentLevel(lstImu, ndx);
      if (isStill) {
        if (mv > 0) {
          // still -> move
          isStill = false;
          //lastMv = mv;
          mvNdxStart = ndx;
        } else {
          // still -> still
        }
      } else {
        if (mv == 0) {
          // move -> still
          mvNdxEnd = ndx;
          computeMoveSequence(lstImu, mvNdxStart, mvNdxEnd, sampleRate);
          mvNdxStart = -1;
          mvNdxEnd = -1;
          isStill = true;
        } else {
          // move -> move
          if (ndx - mvNdxStart >= chunkCount) {
            mvNdxEnd = ndx;
            computeMoveSequence(lstImu, mvNdxStart, mvNdxEnd, sampleRate);
            mvNdxStart = ndx;
          }
        }
      }
    }
    if (!isStill) {
      if (mvNdxStart != -1) {
        computeMoveSequence(lstImu, mvNdxStart, lenData - 1, sampleRate);
      }
    }
    return true;
  }

  bool process(ImuData imuData) {
    if (_mImuConfig!.getRemoveGravity()) {
      imuData.removeAverageGravity();
    }

    scanImuToYieldRecords(imuData);
    return true;
  }
}
