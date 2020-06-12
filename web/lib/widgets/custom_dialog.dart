import 'package:flutter/material.dart';
import 'package:web/widgets/error_text.dart';

class CustomDialog extends StatelessWidget {
  final String title, description, acceptText, cancelText;
  final Image image;
  final Function onAccept;
  final Function onCancel;
  final bool loading;
  final String error;
  final String profilePicture;

  CustomDialog({
    @required this.title,
    @required this.description,
    @required this.acceptText,
    @required this.cancelText,
    Function onAccept,
    Function onCancel,
    this.profilePicture,
    this.loading = false,
    this.error,
    this.image,
  })  : onAccept = onAccept ?? (() {}),
        onCancel = onCancel ?? (() {});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0.0,
      insetPadding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.2),
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Stack(
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
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
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
        Positioned(
          left: 16,
          right: 16,
          child: CircleAvatar(
            backgroundColor: Colors.blueAccent,
            backgroundImage: NetworkImage(profilePicture),
            radius: 66,
          ),
        ),
        //...top circlular image part,
      ],
    );
  }
  
  Widget _getBottomLine(context) {
    if(loading) return CircularProgressIndicator();
    else if(error != null) return ErrorText(error);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: [
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
            onCancel();
          },
          child: Text(cancelText),
        ),
        FlatButton(
          onPressed: onAccept,
          child: Text(acceptText),
        ),
      ],
    );
  }
}
