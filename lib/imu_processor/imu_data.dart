class ImuData {
  int _mSampleRate = 50;

  int _mUnixTimeInSecStart = -1;
  int _mUnixTimeInSecCur = -1;
  int _mUnixTimeInSecEnd = -1;
  int _mTick = 0;

  List<List<double>> _mLstImu = <List<double>>[];

  ImuData(int aSampleRate) {
    _mSampleRate = aSampleRate;
  }

  bool checkDataAcceptable(int unixTimestampInSec) {
    if (_mUnixTimeInSecStart == -1) {
      _mUnixTimeInSecStart = unixTimestampInSec;
      _mUnixTimeInSecCur = unixTimestampInSec;
      _mUnixTimeInSecEnd = unixTimestampInSec;
      _mTick = 0;
    } else if (_mUnixTimeInSecCur + 1 == unixTimestampInSec) {
      if (_mUnixTimeInSecStart == -1) {
        _mUnixTimeInSecStart = unixTimestampInSec;
      }
      _mUnixTimeInSecCur = unixTimestampInSec;
      _mUnixTimeInSecEnd = unixTimestampInSec;
      _mTick = 0;
    } else if (_mUnixTimeInSecCur != unixTimestampInSec) {
      return false;
    }
    return true;
  }

  bool feed(int unixTimestampInSec, double acceX, double acceY, double acceZ,
      double gyroX, double gyroY, double gyroZ) {
    if (!checkDataAcceptable(unixTimestampInSec)) {
      print("ERROR: timestamp does not match with previous group");
      return false;
    }
    if (_mTick >= _mSampleRate) {
      print("ERROR: the total number of data accepted in slot is overflowed");
      return false;
    }

    double tsMs = unixTimestampInSec * 1000.0 + (_mTick / _mSampleRate) * 1000;

    List<double> lstImu = [acceX, acceY, acceZ, gyroX, gyroY, gyroZ, tsMs];
    _mLstImu.add(lstImu);

    _mTick += 1;
    return true;
  }

  List<List<double>> getLstImu() {
    return _mLstImu;
  }
  
  int getTimeStampStart() {
    return _mUnixTimeInSecStart;
  }

  int getTimeStampCur() {
    return _mUnixTimeInSecCur;
  }

  int getTimeStampEnd() {
    return _mUnixTimeInSecEnd;
  }
}
