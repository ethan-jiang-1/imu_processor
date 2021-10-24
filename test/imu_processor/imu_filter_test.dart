import 'package:flutter_test/flutter_test.dart';
import 'package:iirjdart/butterworth.dart';


void main() {
  testWidgets('imu processor low pass ...', (tester) async {
    List<double> dataToFilter = List.filled(500, 0.0);
    dataToFilter[10] = 1.0;

    Butterworth butterworth = Butterworth();
    butterworth.lowPass(4, 250, 50);

    List<double> filteredData = [];
    for(var v in dataToFilter) {
      filteredData.add(butterworth.filter(v));
    }

    print(filteredData);

  });
}
