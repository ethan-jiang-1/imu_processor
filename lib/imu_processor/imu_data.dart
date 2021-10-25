class ImuData {
  int _mSampleRate = 50;

  int _mUnixTimeInSecStart = -1;
  int _mUnixTimeInSecCur = -1;
  int _mUnixTimeInSecEnd = -1;
  int _mTick = 0;
  bool _mGravityRemoved = false;
  String _mErr = "";

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
    if (!_mErr.isEmpty) {
      return false;
    }
    if (!checkDataAcceptable(unixTimestampInSec)) {
      _mErr = "NoNewDataAccecpt_TimeStampNotAligned";
      print("ERROR: " + _mErr);
      return false;
    }
    if (_mTick >= _mSampleRate) {
      _mErr = "NoNewDataAccept_SlotInTheSecIsFull";
      print("ERROR: " + _mErr);
      return false;
    }
    if (_mGravityRemoved) {
      _mErr = "NoNewDataAccecpt_GravityFiltered";
      print("ERROR: " + _mErr);
      return false;
    }

    double tsMs = unixTimestampInSec * 1000.0 + (_mTick / _mSampleRate) * 1000;

    List<double> lstImu = [acceX, acceY, acceZ, gyroX, gyroY, gyroZ, tsMs];
    _mLstImu.add(lstImu);

    _mTick += 1;
    return true;
  }

  List getAverageAcce() {
    double atx = 0.0;
    double aty = 0.0;
    double atz = 0.0;
    for (int ndx = 0; ndx < _mLstImu.length; ndx += 1) {
      List<double> imu = _mLstImu[ndx];
      atx += imu[0];
      aty += imu[1];
      atz += imu[2];
    }
    atx /= _mLstImu.length;
    aty /= _mLstImu.length;
    atz /= _mLstImu.length;
    return [atx, aty, atz];
  }

  bool removeAverageGravity() {
    List atl = getAverageAcce();
    double atx = atl[0];
    double aty = atl[1];
    double atz = atl[2];
    for (int ndx = 0; ndx < _mLstImu.length; ndx += 1) {
      List<double> imu = _mLstImu[ndx];
      imu[0] -= atx;
      imu[1] -= aty;
      imu[2] -= atz;
    }
    return true;
  }

  bool removeGravity() {
    if (_mGravityRemoved) {
      return true;
    }
    removeAverageGravity();
    _mGravityRemoved = true;
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

  int getSampleRate() {
    return _mSampleRate;
  }

  bool getGravityRemoved() {
    return _mGravityRemoved;
  }

  String getErr() {
    return _mErr;
  }
}
