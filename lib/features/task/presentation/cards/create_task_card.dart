import 'dart:async';

import 'package:flutter/material.dart';
import 'package:staffapp/constants/enums.dart';
import 'package:staffapp/constants/styles.dart';
import 'package:staffapp/features/task/presentation/cards/helper_widgets/cancel_button.dart';
import 'package:staffapp/features/task/presentation/cards/helper_widgets/card_decoration.dart';
import 'package:staffapp/features/task/presentation/cards/helper_widgets/scan_confirmation_button.dart';
import 'package:staffapp/features/task/presentation/task_card.dart';
import 'package:staffapp/network/model/product.dart';
import 'package:staffapp/painters/dashed_line_vertical_painter.dart';
import 'package:staffapp/widgets/sensei_number_picker.dart';

class CreateTaskCard extends StatefulWidget {
  final Product product;
  final Function({TaskType type, int numProducts, Product product}) onScan;
  final Function onCancel;
  final Function onError;

  final StreamController<int> isScanningStreamController;
  final StreamController<int> numProductsStreamController;
  final StreamController<TaskType> taskTypeStreamController;
  final int currentNumProducts;
  int currentConfirmationStep;

  CreateTaskCard({
    Key key,
    this.product,
    this.onScan,
    this.onCancel,
    @required this.onError,
    this.currentNumProducts = 1,
    this.currentConfirmationStep = 0,
    this.isScanningStreamController,
    this.numProductsStreamController,
    this.taskTypeStreamController,
  }) : super(key: key);

  @override
  _CreateTaskCardState createState() => _CreateTaskCardState();
}

class _CreateTaskCardState extends State<CreateTaskCard> {
  int _totalNumConfirmationSteps = 2;
  TaskType dropdownValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      verticalDirection: VerticalDirection.up,
      children: [
        Visibility(
          visible: dropdownValue == TaskType.MISPLACEMENT,
          child: Transform.translate(
            offset: const Offset(0, -8),
            child: _buildProgressBar(),
          ),
        ),
        CardDecoration(
          cardState: TaskCardState.OPEN,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _buildTaskLeftSection(widget.product),
              ),
              SizedBox(
                width: 1,
                child: _buildTaskSeparator(),
              ),
              SizedBox(
                width: 60,
                child: _buildTaskRightSection(widget.product),
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

  _buildTaskLeftSection(Product product) {
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
                                product.image?.url ??
                                    "https://upload.wikimedia.org/wikipedia/commons/b/b1/Missing-image-232x150.png",
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          ));
                },
                child: Image.network(
                  product.image?.url ??
                      "https://upload.wikimedia.org/wikipedia/commons/b/b1/Missing-image-232x150.png",
                  fit: BoxFit.fitHeight,
                  height: 64,
                  width: 40,
                ),
              ),
              SizedBox(width: 18),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  width: 168,
                  child: AbsorbPointer(
                    absorbing: widget.currentConfirmationStep >=
                        _totalNumConfirmationSteps,
                    child: DropdownButton<TaskType>(
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
                      onChanged: (TaskType newValue) {
                        setState(() {
                          dropdownValue = newValue;
                          widget.taskTypeStreamController.add(newValue);
                          _totalNumConfirmationSteps =
                              newValue == TaskType.MISPLACEMENT ? 2 : 1;
                          widget.currentConfirmationStep = 0;
                        });
                      },
                      items: TaskType.values
                          .map<DropdownMenuItem<TaskType>>((TaskType value) {
                        return DropdownMenuItem<TaskType>(
                          value: value,
                          child: Text(value.description()),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  width: 160,
                  child: Text(
                    product.name,
                    maxLines: 1,
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
            height: null,
            child: _buildTaskBottomSection(widget.product),
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

  _buildTaskBottomSection(Product product) {
    return widget.currentConfirmationStep >= _totalNumConfirmationSteps
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
                          bool _hasDropdownValue = (dropdownValue != null);
                          bool _hasNumProducts =
                              (snapshot?.data ?? widget.currentNumProducts) > 0;
                          bool _isEnabled =
                              _hasNumProducts && _hasDropdownValue;
                          return ScanConfirmationButton(
                              isScanning: _isScanning,
                              isEnabled: _isEnabled,
                              onPressed: () async {
                                widget.isScanningStreamController.add(1);
                                widget.onScan(
                                    numProducts: widget.currentNumProducts,
                                    product: widget.product,
                                    type: dropdownValue);
                              });
                        })
                  ],
                ),
              );
            });
  }

  _buildTaskRightSection(Product product) {
    return StreamBuilder(
        stream: widget.isScanningStreamController.stream.asBroadcastStream(),
        builder: (context, snapshot) {
          bool _isScanning = snapshot.data == 1;
          return SenseiNumberPicker(
            selectedNumber: widget.currentNumProducts ?? 0,
            minValue: 0,
            isLoading: _isScanning ||
                (widget.currentConfirmationStep >= _totalNumConfirmationSteps),
            onChanged: (value) {
              widget.numProductsStreamController.add(value);
            },
          );
        });
  }
}
