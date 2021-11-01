import 'package:flutter/material.dart';
import 'package:staffapp/constants/styles.dart';
import 'package:staffapp/features/task/presentation/cards/helper_widgets/card_decoration.dart';
import 'package:staffapp/features/task/presentation/cards/helper_widgets/tag_row.dart';
import 'package:staffapp/features/task/presentation/task_card.dart';
import 'package:staffapp/network/model/default_task.dart';
import 'package:staffapp/painters/dashed_line_vertical_painter.dart';
import 'package:staffapp/constants/enums.dart';

class DefaultCard extends StatefulWidget {
  final DefaultTask task;
  final TaskCardState cardState;
  DefaultCard({Key key, this.task, this.cardState}) : super(key: key);

  @override
  _DefaultCardState createState() => _DefaultCardState();
}

class _DefaultCardState extends State<DefaultCard> {
  @override
  Widget build(BuildContext context) {
    return CardDecoration(
      cardState: widget.cardState,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _buildTaskLeftSection(widget.task),
          ),
          SizedBox(
            width: 1,
            child: _buildTaskSeparator(),
          ),
          SizedBox(
            width: 60,
            child: _buildTaskRightSection(widget.task),
          ),
        ],
      ),
    );
  }

  _buildTaskLeftSection(DefaultTask task) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                            content: Container(
                              height: 312,
                              width: 312,
                              child: Image.network(
                                task?.product?.image?.url ?? "",
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          ));
                },
                child: Image.network(
                  task?.product?.image?.url ?? "",
                  height: 64,
                  width: 40,
                  fit: BoxFit.fitHeight,
                ),
              ),
              SizedBox(width: 18),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  task?.type?.toTaskType()?.description() ?? "",
                  style: roboto(
                      size: 14,
                      fontWeight: FontWeight.bold,
                      color: widget.cardState == TaskCardState.COMPLETED
                          ? Color(0xff6A7178)
                          : Colors.black),
                ),
                SizedBox(height: 8),
                TagRow(tags: [task.shelf?.externalId ?? ""]),
                SizedBox(height: 7),
                Container(
                  width: 160,
                  child: Text(
                    task?.product?.name ?? "",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: roboto(
                        size: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xffADB5BD)),
                  ),
                ),
              ]),
            ],
          ),
        ],
      ),
    );
  }

  _buildTaskSeparator() {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      child: CustomPaint(
        painter: DashedLineVerticalPainter(),
      ),
    );
  }

  _buildTaskRightSection(dynamic task) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Visibility(
              // visible: widget.cardState == TaskCardState.COMPLETED,
              visible: false,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 7),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check,
                      color: Color(0xff33D887),
                      size: 13,
                    ),
                    SizedBox(width: 2),
                    Text("12:00",
                        style: roboto(
                            fontWeight: FontWeight.w500,
                            color: Color(0xff33D887),
                            size: 10)),
                  ],
                ),
              )),
          Text(
            task?.quantity?.toString() ?? "",
            style: poppins(
                fontWeight: FontWeight.bold,
                size: 21,
                color: widget.cardState == TaskCardState.COMPLETED
                    ? Color(0xff6A7178)
                    : Colors.black),
          ),
        ],
      ),
    );
  }
}
