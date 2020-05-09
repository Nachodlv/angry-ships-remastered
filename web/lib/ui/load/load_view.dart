import 'package:flutter/cupertino.dart';
import 'package:stacked/stacked.dart';
import 'package:web/ui/load/load_viewmodel.dart';

class LoadView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoadViewModel>.reactive(
      viewModelBuilder: () => LoadViewModel(),
      onModelReady: (model) => model.init(),
      builder: (context, model, child) => Center(
        child: Text("This is a big test."),
      ),
    );
  }
}