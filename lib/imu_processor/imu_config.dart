typedef ImuRecordPump = void Function(
    DateTime dt, int duration, double distanceInMeter, double burnKiloCalorie);

class ImuConfig {
  int _mSampleRate = 50; //sample rate in HZ
  int _mYieldDataSecGap = 10; //yeild in sec
  double _mAccThreshold = 1.0; //acc trigger still -> movement
  ImuRecordPump? _imuRecordPump;

  ImuConfig(ImuRecordPump? aImuRecordPump,
      {aSampleRate = 50, aYieldDataSecGap = 10, aAccThreshold = 1.0}) {
    if (aImuRecordPump != null) {
      _imuRecordPump = aImuRecordPump;
    }
    _mSampleRate = aSampleRate;
    _mYieldDataSecGap = aYieldDataSecGap;
    _mAccThreshold = aAccThreshold;
  }

  int getSampleRate() {
    return _mSampleRate;
  }

  int getYieldDataSecGap() {
    return _mYieldDataSecGap;
  }

  double getAccThreshold() {
    return _mAccThreshold;
  }

  ImuRecordPump? getImuRecordPump() {
    return _imuRecordPump;
  }
}
