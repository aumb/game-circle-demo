import 'package:gamecircle/core/entities/user.dart';

class SessionManager {
  User? _user;
  num? _longitude;
  num? _latitude;

  User? get user => _user;
  num? get longitude => _longitude;
  num? get latitude => _latitude;

  void setUser(User? user) {
    _user = user;
  }

  void setCoordinates({num? longitude, num? latitude}) {
    _longitude = longitude;
    _latitude = latitude;
  }

  void reset() {
    _user = null;
    _longitude = null;
    _latitude = null;
  }
}
