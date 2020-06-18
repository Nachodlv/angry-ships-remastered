import 'package:flutter/material.dart';
import 'package:web/widgets/error_text.dart';

class CustomDialog extends StatelessWidget {
  final String title, description, acceptText, cancelText;
  final Image image;
  final Function(BuildContext) onAccept;
  final Function(BuildContext) onCancel;
  final bool loading;
  final String error;
  final String profilePicture;

  CustomDialog({
    @required this.title,
    @required this.description,
    @required this.acceptText,
    @required this.cancelText,
    Function(BuildContext) onAccept,
    Function(BuildContext) onCancel,
    this.profilePicture,
    this.loading = false,
    this.error,
    this.image,
  })  : onAccept = onAccept ?? (() {}),
        onCancel = onCancel ?? (() {}) {
    print('error received: $error');
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0.0,
      insetPadding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.25),
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            top: 82,
            bottom: 16,
            left: 16,
            right: 16,
          ),
          margin: EdgeInsets.only(top: 66),
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  fontSize: 35.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25.0,
                ),
              ),
              SizedBox(height: 24.0),
              Align(
                alignment: Alignment.bottomCenter,
                child: _getBottomLine(context),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 170),
          child: CircleAvatar(
            backgroundColor: Colors.blueAccent,
            backgroundImage:
                profilePicture != null ? NetworkImage(profilePicture) : null,
            radius: 50,
          ),
        ),
      ],
    );
  }

  Widget _getBottomLine(context) {
    if (loading)
      return CircularProgressIndicator();
    return Column(
      children: [
        if (error != null) ErrorText(error),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: [
            _button(context, cancelText, onCancel, Colors.red[400]),
            _button(context, acceptText, onAccept, Colors.blue[400])
          ],
        ),
      ],
    );
  }
  
  
  Widget _button(BuildContext context, String text, Function(BuildContext) onPressed, Color hoverColor) =>FlatButton(
    onPressed: () => onPressed(context),
    child: Text(
      text,
      style: TextStyle(fontSize: 25),
    ),
    hoverColor: hoverColor,
  );
}
