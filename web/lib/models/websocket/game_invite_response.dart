import 'package:dartz/dartz.dart';

class RoomInviteResponse {
  final String name;
  final String roomId;
  final Option<String> profilePicture;

  RoomInviteResponse(this.name, this.roomId, this.profilePicture);

  factory RoomInviteResponse.fromJson(Map<String, dynamic> json) {
    final profilePicture = json['profilePicture'];
    return RoomInviteResponse(json['name'], json['roomId'],
        profilePicture != null ? Some(profilePicture) : None());
  }
}
