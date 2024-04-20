import 'package:maps_toolkit/maps_toolkit.dart';

class MapKit {
  static num getMarkerRotation(s_lat, s_lng, d_lat, d_lng) {
    var rotate = SphericalUtil.computeHeading(
        LatLng(s_lat, s_lng), LatLng(d_lat, d_lng));
    return rotate;
  }
}
