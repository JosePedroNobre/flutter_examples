import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:staffapp/constants/enums.dart';
import 'package:staffapp/constants/styles.dart';
import 'package:staffapp/features/task/data/barcode_scanner.dart';
import 'package:staffapp/features/task/presentation/task.dart';
import 'package:staffapp/features/task/presentation/ticket_clipper.dart';
import 'package:staffapp/painters/dashed_line_vertical_painter.dart';
import 'package:staffapp/widgets/sensei_number_picker.dart';

enum TaskCardState { OPEN, LOCKED, COMPLETED, DEFAULT }

class TaskCard extends StatefulWidget {
  final Task task;
  final bool readOnly;
  final bool isNewTask;
  final TaskCardState cardState;
  final Function onImageTap;
  final Function(Task task) onTaskCompleted;
  final Function(Task task) onTaskSnoozed;
  final Function(Task task) onTaskArchived;
  final Function onTap;
  final Function onCancel;
  final SlidableController slidableController;
  TaskCard(
      {Key key,
      @required this.task,
      this.onTap,
      this.readOnly = false,
      this.onCancel,
      this.onTaskCompleted,
      this.onTaskArchived,
      this.onTaskSnoozed,
      this.cardState = TaskCardState.DEFAULT,
      this.isNewTask = false,
      this.onImageTap,
      this.slidableController})
      : super(key: key);

  @override
  _TaskCardState createState() => _TaskCardState(isNewTask);
}

class _TaskCardState extends State<TaskCard> {
  StreamController<int> _isScanningStreamController;
  StreamController<int> _numProducts;
  int currentConfirmationStep = 0;
  String dropdownValue;
  int currentNumProducts;

  _TaskCardState(bool isNewTask) {
    this.currentNumProducts = isNewTask ? 0 : 1;
  }

  @override
  void initState() {
    _isScanningStreamController = StreamController<int>.broadcast();
    _numProducts = StreamController<int>.broadcast();
    super.initState();
  }

  @override
  void dispose() {
    _isScanningStreamController?.close();
    _numProducts?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Slidable(
          key: Key(widget.task.id.toString()),
          controller: widget.slidableController,
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          actions: widget.readOnly ||
                  (widget.cardState != TaskCardState.DEFAULT)
              ? null
              : [
                  IconSlideAction(
                    color: Color(0xffADB5BD),
                    iconWidget: Icon(Icons.snooze, color: Colors.white),
                    onTap: () => showSnackbar(false),
                  ),
                  IconSlideAction(
                    color: Color(0xffd9dee2),
                    iconWidget:
                        Icon(Icons.archive_outlined, color: Color(0xffa3acb4)),
                    onTap: () => showSnackbar(true),
                  ),
                ],
          child: Stack(
            children: [
              Visibility(
                visible: widget.cardState == TaskCardState.OPEN &&
                    widget.task.type == TaskType.MISPLACEMENT,
                child: Padding(
                  padding: const EdgeInsets.only(top: 175),
                  child: Container(
                    child: _buildProgressBar(),
                  ),
                ),
              ),
              ClipShadowPath(
                shadow: widget.cardState == TaskCardState.OPEN
                    ? Shadow(
                        blurRadius: 5,
                        color: Colors.grey[300],
                        offset: Offset(0, 3))
                    : null,
                clipper: TicketClipper(offsetRight: 60),
                child: Opacity(
                  opacity: widget.cardState == TaskCardState.LOCKED ? 0.5 : 1,
                  child: Container(
                      width: double.infinity,
                      child: IntrinsicHeight(
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
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(4),
                              bottomRight: Radius.circular(4),
                              topLeft: Radius.circular(4),
                              topRight: Radius.circular(4)))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildTaskLeftSection(Task task) {
    bool _isComplete = currentConfirmationStep >= widget.task.type.steps();
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
                              child: Image.asset(
                                "images/test.png",
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          ));
                },
                child: Image.asset("images/test.png"),
              ),
              SizedBox(width: 18),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                widget.isNewTask
                    ? Container(
                        width: 168,
                        child: AbsorbPointer(
                          absorbing: _isComplete,
                          child: DropdownButton(
                            hint: Text("Selecionar tarefa"),
                            iconDisabledColor: Color(0XFFF1F3F5),
                            dropdownColor: Colors.white,
                            value: dropdownValue,
                            icon: Icon(Icons.arrow_drop_down),
                            isExpanded: true,
                            style: roboto(
                                size: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                            onChanged: (String newValue) {
                              setState(() {
                                dropdownValue = newValue;
                              });
                            },
                            items: <String>[
                              'Reposição',
                              'Arranjo',
                              'Quebra',
                              'Retirada'
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      )
                    : Text(
                        task.type.description(),
                        style: roboto(
                            size: 14,
                            fontWeight: FontWeight.bold,
                            color: widget.readOnly
                                ? Color(0xff6A7178)
                                : Colors.black),
                      ),
                SizedBox(height: 8),
                _tags(),
                SizedBox(height: 7),
                Container(
                  width: 160,
                  child: Text(
                    "Café white Heron, Lote Chávena, 500g",
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

  _tags() {
    return Row(
      children: [
        _tag("M1 - C21"),
        Icon(
          Icons.arrow_right_alt_sharp,
          size: 16,
          color: Color(0XFF6A7178),
        ),
        _tag("M1 - C21"),
      ],
    );
  }

  Widget _tag(String text) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(4),
              bottomRight: Radius.circular(4),
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4))),
      child: Padding(
        padding: const EdgeInsets.only(left: 4, right: 4, top: 2, bottom: 2),
        child: Text(text,
            style: roboto(
                size: 12,
                fontWeight: FontWeight.w300,
                color: Color(0XFF6A7178))),
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

  _buildTaskRightSection(Task task) {
    return StreamBuilder(
        stream: _isScanningStreamController.stream.asBroadcastStream(),
        builder: (context, snapshot) {
          bool _isScanning = snapshot.data == 1;
          bool _isComplete =
              currentConfirmationStep >= widget.task.type.steps();
          return widget.cardState == TaskCardState.OPEN
              ? SenseiNumberPicker(
                  selectedNumber: currentNumProducts,
                  minValue: widget.isNewTask ? 0 : 1,
                  isLoading: _isScanning || _isComplete,
                  onChanged: (value) {
                    currentNumProducts = value;
                    _numProducts.add(value);
                  },
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Visibility(
                          visible: widget.readOnly,
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
                        task.currentSelectedValue.toString(),
                        style: poppins(
                            fontWeight: FontWeight.bold,
                            size: 21,
                            color: widget.readOnly
                                ? Color(0xff6A7178)
                                : Colors.black),
                      ),
                    ],
                  ),
                );
        });
  }

  _buildTaskBottomSection(Task task) {
    bool _isComplete = currentConfirmationStep >= widget.task.type.steps();
    return _isComplete
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
            stream: _isScanningStreamController.stream.asBroadcastStream(),
            builder: (context, snapshot) {
              bool _isScanning = snapshot.data == 1;
              return Padding(
                padding: const EdgeInsets.only(top: 16, left: 0),
                child: Row(
                  children: [
                    _buildCancelButton(_isScanning),
                    SizedBox(width: 8),
                    _buildScanAndConfirmButton(
                        task: task, isScanning: _isScanning),
                  ],
                ),
              );
            });
  }

  _buildProgressBar() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProgressionBar(
                (currentConfirmationStep * 100) / widget.task.type.steps()),
            SizedBox(height: 8),
            Text(
                currentConfirmationStep.toString() +
                    "/" +
                    widget.task.type.steps().toString() +
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

  _buildCancelButton(bool isScanning) {
    return Theme(
      data: ThemeData(splashColor: Colors.black26),
      child: FlatButton(
        padding: const EdgeInsets.all(8),
        height: 40,
        minWidth: 40,
        onPressed: isScanning
            ? null
            : () {
                currentNumProducts = 1;
                widget.onCancel();
                Future.delayed(Duration(milliseconds: 500), () {
                  widget.slidableController?.activeState?.close();
                });
              },
        child: Text(
          "Cancel",
          style: poppins(
              fontWeight: FontWeight.bold,
              color: isScanning ? Color(0XFFDEE2E6) : Colors.black,
              size: 14),
        ),
      ),
    );
  }

  _buildScanAndConfirmButton({Task task, bool isScanning}) {
    return Expanded(
      child: Container(
        height: 40,
        child: StreamBuilder(
            stream: _numProducts.stream.asBroadcastStream(),
            builder: (context, snapshot) {
              bool _hasDropdownValue =
                  (dropdownValue != null && dropdownValue.isNotEmpty);
              bool _hasNumProducts = (snapshot?.data ?? currentNumProducts) > 0;
              bool isEnabled = widget.isNewTask
                  ? _hasNumProducts && _hasDropdownValue
                  : _hasNumProducts;
              return Theme(
                data: ThemeData(
                  splashColor: Colors.white24,
                ),
                child: FlatButton(
                    height: 40,
                    color: isEnabled
                        ? Theme.of(context).primaryColor
                        : Color(0XFFDEE2E6),
                    padding: const EdgeInsets.all(8),
                    splashColor:
                        isEnabled ? Colors.white24 : Colors.transparent,
                    onPressed: isEnabled
                        ? () async {
                            _isScanningStreamController.add(1);
                            BarcodeScanner().scan((barcode) {
                              _confirmBarcode(barcode);
                              _isScanningStreamController.add(0);
                            });
                          }
                        : () {},
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Visibility(
                          visible: isScanning,
                          child: SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 1,
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                  Colors.white),
                            ),
                          ),
                        ),
                        Opacity(
                          opacity: isScanning ? 0 : 1,
                          child: Text(
                            "Scan e confirmar",
                            style: poppins(
                                size: 14,
                                fontWeight: FontWeight.bold,
                                color: isEnabled
                                    ? Colors.white
                                    : Color(0XFF8C939B)),
                          ),
                        ),
                      ],
                    )),
              );
            }),
      ),
    );
  }

  void showSnackbar(bool taskArchived) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        elevation: 0,
        action: SnackBarAction(
          textColor: Colors.white,
          label: 'Anular',
          onPressed: () {
            if (taskArchived) {
              widget.onTaskArchived(widget.task);
            } else {
              widget.onTaskSnoozed(widget.task);
            }
          },
        ),
        margin: EdgeInsets.fromLTRB(24, 0, 24, 80),
        behavior: SnackBarBehavior.floating,
        content: Container(
            child: Text(taskArchived
                ? "A tarefa foi eliminada."
                : "A tarefa foi adiada.")),
      ),
    );
  }

  _confirmBarcode(dynamic barcode) {
    try {
      Map barcodeScan = jsonDecode(barcode);
      String _barcodeScanData = barcodeScan['scanData'];
      // TODO: regex to make sure the barcode is the right type.
      setState(() {
        currentConfirmationStep++;
        if (currentConfirmationStep >= widget.task.type.steps()) {
          widget.task.currentSelectedValue = currentNumProducts;
          // call callback here onTaskCompleted() and remove this item from the list(in the task_screen).
          widget.onTaskCompleted(widget.task);
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
