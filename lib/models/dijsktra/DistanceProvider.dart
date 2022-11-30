class DistanceProvider {
  double getDistanceBetween(String place1, String place2) {
    var ascii = (place1 + place2).codeUnits;
    double sum = 0;
    ascii.forEach((element) {
      sum += element;
    });
    return sum;
  }
}
