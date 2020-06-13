import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:web/data_structures/remote_data.dart';
import 'package:web/global.dart';
import 'package:web/models/websocket/game_invite_response.dart';
import 'package:web/services/websockets/room_invite_ws_service.dart';

class RoomInviteDialogModel extends ChangeNotifier {
  final Widget Function(BuildContext, String, String, RoomInviteDialogModel)
      getDialog;
  final RoomInviteWsService _roomInviteWsService =
      locator<RoomInviteWsService>();
  final Socket socket;

  String roomId;
  RemoteData<String, RoomInviteResponse> _roomInviteData =
      RemoteData.notAsked();
  RemoteData<String, Unit> acceptInviteData = RemoteData.notAsked();
  StreamSubscription<RoomInviteResponse> gameInviteSub;
  Widget dialog;

  RoomInviteDialogModel({@required this.socket, @required this.getDialog});

  init(BuildContext context) {
    gameInviteSub = _roomInviteWsService.onRoomInvite.listen((response) {
      roomId = response.roomId;
      _roomInviteData = RemoteData.success(response);
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => getDialog(context, response.name,
              response.profilePicture.getOrElse(() => null), this));
    });
  }

  acceptInvite() {
    if (roomId == null) return;
    acceptInviteData = RemoteData.loading();
    this._roomInviteWsService.acceptInvite(socket, roomId).then((value) {
      if (!value.startFinding) {
        acceptInviteData = RemoteData.error(value.message);
        notifyListeners();
      }
    });
    notifyListeners();
  }

  cancelInvite() {
    if (roomId == null) return;
    _roomInviteWsService.cancelInvite(socket, roomId);
  }

  @override
  void dispose() {
    gameInviteSub.cancel();
    super.dispose();
  }
}
