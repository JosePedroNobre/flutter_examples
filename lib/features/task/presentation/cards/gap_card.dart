import 'dart:async';

import 'package:flutter/material.dart';
import 'package:staffapp/constants/styles.dart';
import 'package:staffapp/features/task/presentation/cards/helper_widgets/cancel_button.dart';
import 'package:staffapp/features/task/presentation/cards/helper_widgets/card_decoration.dart';
import 'package:staffapp/features/task/presentation/cards/helper_widgets/scan_confirmation_button.dart';
import 'package:staffapp/features/task/presentation/cards/helper_widgets/tag_row.dart';
import 'package:staffapp/features/task/presentation/task_card.dart';
import 'package:staffapp/network/model/gaptask.dart';
import 'package:staffapp/painters/dashed_line_vertical_painter.dart';
import 'package:staffapp/widgets/sensei_number_picker.dart';
import 'package:staffapp/constants/enums.dart';

class GapCard extends StatefulWidget {
  final GapTask task;
  final TaskCardState cardState;
  final Function(GapTask task) onScan;
  final Function onCancel;
  final Function onError;

  final StreamController<int> isScanningStreamController;
  final StreamController<int> numProductsStreamController;
  final int currentNumProducts;
  final int currentConfirmationStep;

  GapCard({
    Key key,
    @required this.task,
    this.cardState = TaskCardState.DEFAULT,
    this.onScan,
    this.onCancel,
    @required this.onError,
    this.currentNumProducts = 1,
    this.currentConfirmationStep = 0,
    this.isScanningStreamController,
    this.numProductsStreamController,
  }) : super(key: key);

  @override
  _GapCardState createState() => _GapCardState();
}

class _GapCardState extends State<GapCard> {
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

  _buildTaskLeftSection(GapTask task) {
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
          Container(
            height: widget.cardState == TaskCardState.OPEN ? null : 0.0,
            child: _buildTaskBottomSection(task),
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

  _buildTaskBottomSection(GapTask task) {
    return widget.currentConfirmationStep > 0
        ? Padding(
            padding: const EdgeInsets.only(top: 24),
            child: Container(
              color: Colors.black,
              height: 40,
              width: 220,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check, color: Colors.white),
                    SizedBox(width: 11),
                    Text(
                      "Tarefa completa",
                      style: poppins(
                          size: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          )
        : StreamBuilder(
            stream:
                widget.isScanningStreamController.stream.asBroadcastStream(),
            builder: (context, snapshot) {
              bool _isScanning = snapshot.data == 1;
              return Padding(
                padding: const EdgeInsets.only(top: 16, left: 0),
                child: Row(
                  children: [
                    CancelButton(
                      isScanning: _isScanning,
                      onPressed: () {
                        widget.onCancel();
                      },
                    ),
                    SizedBox(width: 8),
                    StreamBuilder(
                        stream: widget.numProductsStreamController.stream
                            .asBroadcastStream(),
                        builder: (context, snapshot) {
                          bool _isEnabled =
                              (snapshot?.data ?? widget.currentNumProducts) > 0;
                          return ScanConfirmationButton(
                              isScanning: _isScanning,
                              isEnabled: _isEnabled,
                              onPressed: () async {
                                widget.onScan(widget.task);
                                widget.isScanningStreamController.add(1);
                              });
                        }),
                  ],
                ),
              );
            });
  }

  _buildTaskRightSection(GapTask task) {
    return StreamBuilder(
        stream: widget.isScanningStreamController.stream.asBroadcastStream(),
        builder: (context, snapshot) {
          bool _isScanning = snapshot.data == 1;
          return widget.cardState == TaskCardState.OPEN
              ? SenseiNumberPicker(
                  selectedNumber: widget.currentNumProducts,
                  minValue: 1,
                  isLoading:
                      _isScanning || (widget.currentConfirmationStep > 0),
                  onChanged: (value) {
                    widget.numProductsStreamController.add(value);
                  },
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Visibility(
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
        });
  }
}
