import 'dart:async';

import 'package:flutter/material.dart';
import 'package:web/models/boat.dart';
import 'package:web/ui/room/grid_view.dart';

class BoatDraggableController {
  _BoatDraggableState _state;

  rotate() {
    print('State: $_state');
    _state?.rotate();
  }
}

class BoatDraggable extends StatefulWidget {
  final Boat boat;
  final double tileSize;
  final BoatDraggableController controller;
  final FocusNode focusNode;

  BoatDraggable(this.boat, this.tileSize,
      {Key key, BoatDraggableController controller, this.focusNode})
      : this.controller = controller ?? BoatDraggableController(),
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    final state = _BoatDraggableState();
    controller._state = state;
    return state;
  }
}

class _BoatDraggableState extends State<BoatDraggable> {
  final StreamController<Boat> _boatStream = StreamController.broadcast();
  bool dragging = false;

  @override
  void initState() {
    super.initState();
    _boatStream.add(widget.boat);
  }

  @override
  Widget build(BuildContext context) {
    return Draggable<Boat>(
      dragAnchor: DragAnchor.pointer,
      data: widget.boat,
      onDragStarted: () {
        dragging = true;
        FocusScope.of(context).requestFocus(widget.focusNode);
      },
      onDragEnd: (_) => dragging = false,
      onDraggableCanceled: (_, __) => dragging = false,
      onDragCompleted: () => dragging = false,
      feedback: StreamBuilder<Boat>(
          stream: _boatStream.stream,
          initialData: widget.boat,
          builder: (context, snapshot) => snapshot.hasData
              ? snapshot.data.getBox(widget.tileSize, Colors.grey[600])
              : Container()),
      child: widget.boat.getBox(widget.tileSize, Colors.blue[500]),
      childWhenDragging:
          widget.boat.getBox(widget.tileSize, Colors.transparent),
    );
  }

  rotate() {
    print('Dragging: $dragging');
    if (!dragging) return;
    widget.boat.rotationIndex = widget.boat.rotationIndex == 0 ? 1 : 0;
    _boatStream.add(widget.boat);
  }

  @override
  void dispose() {
    _boatStream.close();
    super.dispose();
  }
}
