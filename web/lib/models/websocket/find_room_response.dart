class FindRoomResponse {
  final bool startFinding;
  final String message;
  
  FindRoomResponse(this.startFinding, this.message);

  factory FindRoomResponse.fromJson(Map<String, dynamic> json) {
    return FindRoomResponse(
      json['startFinding'],
      json['message']
    );
  }
}