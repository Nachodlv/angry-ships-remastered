import 'package:flutter/cupertino.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:stacked/stacked.dart';
import 'package:web/widgets/custom_dialog.dart';
import 'package:web/widgets/room_invite/room_invite_dialog_model.dart';

class RoomInviteDialog extends StatelessWidget {
  final Socket socket;

  RoomInviteDialog(this.socket);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RoomInviteDialogModel>.reactive(
      viewModelBuilder: () =>
          RoomInviteDialogModel(socket: socket, getDialog: getDialog),
      onModelReady: (model) => model.init(context),
      builder: (context, model, child) => Container(),
    );
  }

  Widget getDialog(context, String name, String profilePicture, RoomInviteDialogModel model) {
    final dialog = (bool loading, {String error}) => _customDialog(name, profilePicture, model, loading, error);
    return model.acceptInviteData.when(
        success: (_) => dialog(false),
        error: (result) => dialog(false, error: result),
        loading: () => dialog(true),
        notAsked: () => dialog(false));
  }


  Widget _customDialog(String name, String profilePicture, RoomInviteDialogModel model,
      bool loading, String error) =>
      CustomDialog(
        title: "Game Invite",
        description: "$name invited you to join a game",
        acceptText: "Accept",
        cancelText: "Cancel",
        onAccept: model.acceptInvite,
        onCancel: model.cancelInvite,
        profilePicture: profilePicture,
        loading: loading,
        error: error,
      );
}
