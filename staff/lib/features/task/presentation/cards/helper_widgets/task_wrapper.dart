import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:staffapp/features/task/presentation/task_card.dart';

class TaskWrapper extends StatefulWidget {
  final int id;
  final Widget child;
  final SlidableController slidableController;
  final List<IconSlideAction> slideActions;
  final Function onTap;
  final TaskCardState cardState;

  TaskWrapper({
    Key key,
    @required this.id,
    @required this.child,
    @required this.slidableController,
    this.slideActions = const [],
    this.onTap,
    this.cardState = TaskCardState.DEFAULT,
  }) : super(key: key);

  @override
  _TaskWrapperState createState() => _TaskWrapperState();
}

class _TaskWrapperState extends State<TaskWrapper> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
      },
      child: Slidable(
        key: Key(widget.id.toString()),
        controller: widget.slidableController,
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        actions: widget.cardState != TaskCardState.DEFAULT
            ? null
            : widget.slideActions,
        child: widget.child,
      ),
    );
  }
}
