import 'dart:async';

import 'package:flutter/material.dart';
import 'package:staffapp/constants/styles.dart';
import 'package:staffapp/features/task/presentation/cards/helper_widgets/cancel_button.dart';
import 'package:staffapp/features/task/presentation/cards/helper_widgets/card_decoration.dart';
import 'package:staffapp/features/task/presentation/cards/helper_widgets/scan_confirmation_button.dart';
import 'package:staffapp/features/task/presentation/cards/helper_widgets/tag_row.dart';
import 'package:staffapp/features/task/presentation/task_card.dart';
import 'package:staffapp/network/model/misplaced_task.dart';
import 'package:staffapp/painters/dashed_line_vertical_painter.dart';
import 'package:staffapp/widgets/sensei_number_picker.dart';
import 'package:staffapp/constants/enums.dart';

class MisplacementCard extends StatefulWidget {
  final MisplacedTask task;
  final TaskCardState cardState;
  final Function(MisplacedTask task) onScan;
  final Function onCancel;
  final Function onError;

  final StreamController<int> isScanningStreamController;
  final StreamController<int> numProductsStreamController;
  final int currentNumProducts;
  final int currentConfirmationStep;

  MisplacementCard({
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
  _MisplacementCardState createState() => _MisplacementCardState();
}

class _MisplacementCardState extends State<MisplacementCard> {
  int _totalNumConfirmationSteps = 2;

  @override
  Widget build(BuildContext context) {
    return Column(
      verticalDirection: VerticalDirection.up,
      mainAxisSize: MainAxisSize.min,
      children: [
        Visibility(
          visible: widget.cardState == TaskCardState.OPEN,
          child: Transform.translate(
            offset: const Offset(0, -8),
            child: _buildProgressBar(),
          ),
        ),
        CardDecoration(
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
        ),
      ],
    );
  }

  _buildProgressBar() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProgressionBar((widget.currentConfirmationStep * 100) /
                _totalNumConfirmationSteps),
            SizedBox(height: 8),
            Text(
                widget.currentConfirmationStep.toString() +
                    "/" +
                    _totalNumConfirmationSteps.toString() +
                    "— QR code da prateleira de origem",
                style: roboto(
                    fontWeight: FontWeight.w400,
                    size: 12,
                    color: Color(0xff4F575E)))
          ],
        ),
      ),
      decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: new BorderRadius.only(
            bottomLeft: const Radius.circular(4),
            bottomRight: const Radius.circular(4),
          )),
      width: double.infinity,
      height: 70,
    );
  }

  _buildProgressionBar(double percentage) {
    return Container(
        height: 6,
        decoration: BoxDecoration(
          color: Color(0xffDEE2E6),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Stack(
          alignment: Alignment.centerLeft,
          children: <Widget>[
            FractionallySizedBox(
              heightFactor: percentage == 0 ? 0 : 1,
              widthFactor: percentage > 6 ? (percentage / 100) : (6 / 100),
              child: Container(
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(100),
                  )),
            ),
            Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 0), child: Container())
          ],
        ));
  }

  _buildTaskLeftSection(MisplacedTask task) {
    var tags = [task.shelf];
    tags.addAll(task?.destinationShelf ?? []);
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
                TagRow(tags: tags.map((e) => e?.externalId ?? "").toList()),
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

  _buildTaskBottomSection(MisplacedTask task) {
    return widget.currentConfirmationStep >= 2
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

  _buildTaskRightSection(MisplacedTask task) {
    return StreamBuilder(
        stream: widget.isScanningStreamController.stream.asBroadcastStream(),
        builder: (context, snapshot) {
          bool _isScanning = snapshot.data == 1;
          return widget.cardState == TaskCardState.OPEN
              ? SenseiNumberPicker(
                  selectedNumber: widget.currentNumProducts,
                  minValue: 1,
                  isLoading:
                      _isScanning || (widget.currentConfirmationStep >= 2),
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
