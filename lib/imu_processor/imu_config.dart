typedef ImuRecordPump = void Function(
    DateTime dt, int duration, double distanceInMeter, double burnKiloCalorie);

class ImuConfig {
  int _mYieldDataSecGap = 10; //yeild in sec
  double _mAccMagicThreshold = 1.0; //acc trigger still -> movement
  final int _mYieldMinSamples = 3; //yield min samples
  final bool _mRemoveGravity = true; //should gravity in imu removed?

  ImuRecordPump? _imuRecordPump;

  ImuConfig(ImuRecordPump? aImuRecordPump,
      {aYieldDataSecGap = 10, aAccThreshold = 1.0, a}) {
    if (aImuRecordPump != null) {
      _imuRecordPump = aImuRecordPump;
    }
    _mYieldDataSecGap = aYieldDataSecGap;
    _mAccMagicThreshold = aAccThreshold;
  }

  int getYieldDataSecGap() {
    return _mYieldDataSecGap;
  }

  int getYieldMinSamples() {
    return _mYieldMinSamples;
  }

  double getAccThreshold() {
    return _mAccMagicThreshold;
  }

  bool getRemoveGravity() {
    return _mRemoveGravity;
  }

  ImuRecordPump? getImuRecordPump() {
    return _imuRecordPump;
  }
}
