import 'package:flutter/material.dart';
import 'package:staffapp/features/task/presentation/task_card.dart';
import 'package:staffapp/features/task/presentation/ticket_clipper.dart';

class CardDecoration extends StatefulWidget {
  final Widget child;
  final TaskCardState cardState;

  CardDecoration({
    Key key,
    @required this.child,
    this.cardState = TaskCardState.DEFAULT,
  }) : super(key: key);

  @override
  _CardDecorationState createState() => _CardDecorationState();
}

class _CardDecorationState extends State<CardDecoration> {
  @override
  Widget build(BuildContext context) {
    return ClipShadowPath(
      shadow: widget.cardState == TaskCardState.OPEN
          ? Shadow(blurRadius: 5, color: Colors.grey[300], offset: Offset(0, 3))
          : null,
      clipper: TicketClipper(offsetRight: 60),
      child: Opacity(
        opacity: widget.cardState == TaskCardState.LOCKED ? 0.5 : 1,
        child: Container(
            width: double.infinity,
            child: IntrinsicHeight(
              child: widget.child,
            ),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(4),
                    bottomRight: Radius.circular(4),
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(4)))),
      ),
    );
  }
}
