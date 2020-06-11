class GameOverResponse {
  final String winnerId;
  final String loserId;

  GameOverResponse(this.winnerId, this.loserId);

  factory GameOverResponse.fromJson(Map<String, dynamic> json) {
    return GameOverResponse(json['winnerId'], json['loserId']);
  }
}
