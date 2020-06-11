class RoomInviteResponse {
  final String name;
  final String roomId;

  RoomInviteResponse(this.name, this.roomId);

  factory RoomInviteResponse.fromJson(Map<String, dynamic> json) {
    return RoomInviteResponse(json['name'], json['roomId']);
  }
}