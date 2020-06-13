import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:web/ui/load/load_viewmodel.dart';
import 'package:web/widgets/custom_spinner.dart';

class LoadView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoadViewModel>.reactive(
      viewModelBuilder: () => LoadViewModel(),
      onModelReady: (model) => model.init(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: Colors.blue[300],
        body: Center(
          child: CustomSpinner(),
        ),
      ),
    );
  }
}