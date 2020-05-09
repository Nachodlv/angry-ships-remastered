import 'package:flutter/cupertino.dart';
import 'package:stacked/stacked.dart';
import 'package:web/ui/login/login_viewmodel.dart';

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
      viewModelBuilder: () => LoginViewModel(),
      onModelReady: (model) => model.init(),
      builder: (context, model, child) => Center(
        child: Text("This is a big test in login."),
      ),
    );
  }
}