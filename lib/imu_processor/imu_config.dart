typedef ImuRecordPump = void Function(
    DateTime dt, int duration, double distanceInMeter, double burnKiloCalorie);

class ImuConfig {
  int _mYieldDataSecGap = 10; //yeild in sec
  double _mAccMagicThreshold = 1.0; //acc trigger still -> movement (need to be test and backfill)
  ImuRecordPump? _imuRecordPump;

  ImuConfig(ImuRecordPump? aImuRecordPump,
      {aYieldDataSecGap = 10, aAccThreshold = 1.0}) {
    if (aImuRecordPump != null) {
      _imuRecordPump = aImuRecordPump;
    }
    _mYieldDataSecGap = aYieldDataSecGap;
    _mAccMagicThreshold = aAccThreshold;
  }

  int getYieldDataSecGap() {
    return _mYieldDataSecGap;
  }

  double getAccThreshold() {
    return _mAccMagicThreshold;
  }

  ImuRecordPump? getImuRecordPump() {
    return _imuRecordPump;
  }
}
