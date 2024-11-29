import 'dart:convert';

class UserDevice {
  final int? userDeviceId;
  final String? fcmToken;

  UserDevice({
    required this.userDeviceId,
    required this.fcmToken,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (userDeviceId != null) {
      result.addAll({'userDeviceId': userDeviceId});
    }
    if (fcmToken != null) {
      result.addAll({'fcmToken': fcmToken});
    }

    return result;
  }

  factory UserDevice.fromMap(Map<String, dynamic> map) {
    return UserDevice(
      userDeviceId: map['userDeviceId']?.toInt(),
      fcmToken: map['fcmToken'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserDevice.fromJson(String source) =>
      UserDevice.fromMap(json.decode(source));
}
