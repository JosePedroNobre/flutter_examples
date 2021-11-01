import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rxdart/rxdart.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:staffapp/constants/enums.dart';
import 'package:staffapp/constants/styles.dart';
import 'package:staffapp/features/task/bloc/task_bloc.dart';
import 'package:staffapp/features/task/data/barcode_scanner.dart';
import 'package:staffapp/features/task/presentation/cards/create_task_card.dart';
import 'package:staffapp/features/task/presentation/cards/default_card.dart';
import 'package:staffapp/features/task/presentation/cards/gap_card.dart';
import 'package:staffapp/features/task/presentation/cards/helper_widgets/task_wrapper.dart';
import 'package:staffapp/features/task/presentation/cards/misplacement_card.dart';
import 'package:staffapp/features/task/presentation/cards/replenishment_card.dart';
import 'package:staffapp/features/task/presentation/task_card.dart';
import 'package:staffapp/network/model/default_task.dart';
import 'package:staffapp/network/model/gaptask.dart';
import 'package:staffapp/network/model/misplaced_task.dart';
import 'package:staffapp/network/model/product.dart';
import 'package:staffapp/network/model/replenishment_task.dart';
import 'package:staffapp/network/model/requests/complete_gap_task_request.dart';
import 'package:staffapp/network/model/requests/complete_misplacement_task_request.dart';
import 'package:staffapp/network/model/requests/complete_replenishment_task_request.dart';
import 'package:staffapp/network/model/requests/unsaleable_task_input.dart';
import 'package:staffapp/network/model/requests/withdrawn_task_input.dart';
import 'package:staffapp/network/model/shelf.dart';
import 'package:staffapp/network/model/task_response.dart';
import 'package:staffapp/network/model/work_session_status_payload.dart';

class TaskScreen extends StatefulWidget {
  final Stream<List<TaskResponse>> storeTaskPayloadStream;
  final Stream<List<TaskResponse>> storeTaskCompletedStream;
  final Stream<WorkSessionStatusPayload> workSessionStatusStream;

  TaskScreen(
      {this.storeTaskPayloadStream,
      this.storeTaskCompletedStream,
      this.workSessionStatusStream});

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  int currentIndexSelected = 0;
  int _selectedTaskId;
  Product _scannedProduct;
  bool isTaskOpen = false;
  StreamController<int> _selectedIdStreamController = BehaviorSubject<int>();
  ItemScrollController _scrollController = ItemScrollController();
  final SlidableController slidableController = SlidableController();

  // Task Card variables
  //
  //
  StreamController<int> _isScanningStreamController;
  StreamController<int> _numProductsStreamController;
  StreamController<TaskType> _taskTypeStreamController;
  int _currentNumProducts = 1;
  int _currentConfirmationStep = 0;
  TaskType _taskType;
  List<Shelf> _shelves = [];

  @override
  void initState() {
    _resetTaskCardVariables();
    super.initState();
  }

  @override
  void dispose() {
    _selectedIdStreamController?.close();
    _isScanningStreamController?.close();
    _numProductsStreamController?.close();
    _taskTypeStreamController?.close();
    super.dispose();
  }

  _resetState() {
    isTaskOpen = false;
    _scannedProduct = null;
    _selectedIdStreamController.add(null);
  }

  void _resetTaskCardVariables() {
    _isScanningStreamController = StreamController<int>.broadcast();
    _numProductsStreamController = StreamController<int>.broadcast();
    _taskTypeStreamController = StreamController<TaskType>.broadcast();
    _currentNumProducts = 1;
    _currentConfirmationStep = 0;
    _shelves = [];
    _taskType = null;

    _numProductsStreamController.stream.listen((event) {
      _currentNumProducts = event;
    });
    _taskTypeStreamController.stream.listen((event) {
      _taskType = event;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TaskBloc, TaskState>(
      cubit: BlocProvider.of<TaskBloc>(context),
      listenWhen: (previous, current) =>
          (current is ProductLoaded) ||
          (current is TaskCreated) ||
          (current is TaskComplete) ||
          (current is TaskError),
      listener: (context, state) {
        if (state is ProductLoaded) {
          setState(() {
            _scannedProduct = state.product;
            _scrollToIndex(0);
          });
        } else if (state is TaskCreated) {
          _resetTaskCardVariables();
          _resetState();
          _isScanningStreamController.add(0);
          setState(() {});
        } else if (state is TaskComplete) {
          _resetTaskCardVariables();
          _resetState();
          _isScanningStreamController.add(0);
          setState(() {});
        } else if (state is TaskError) {
          setState(() {
            _resetState();
            _resetTaskCardVariables();
            _isScanningStreamController.add(0);
            showErrorSnackbar(
                message:
                    "Código de barras inválido. ${state.senseiError.message}");
          });
        }
      },
      buildWhen: (previous, current) => null,
      builder: (previous, current) {
        return StreamBuilder<WorkSessionStatusPayload>(
            stream: widget.workSessionStatusStream,
            builder: (context, workSessionPayload) {
              return StreamBuilder<List<TaskResponse>>(
                stream: widget.storeTaskCompletedStream,
                builder: (context, completedTasksSnapshot) {
                  return StreamBuilder<List<TaskResponse>>(
                    stream: widget.storeTaskPayloadStream,
                    builder: (context, tasksSnapshot) {
                      if (workSessionPayload.connectionState ==
                          ConnectionState.active) {
                        if (workSessionPayload.data.myWorkSessionStatus ==
                            "closed") {
                          return _buildNoSessionScreen();
                        }
                      }

                      if (completedTasksSnapshot.connectionState ==
                              ConnectionState.active &&
                          tasksSnapshot.connectionState ==
                              ConnectionState.active) {
                        List<TaskResponse> _tasksTodo =
                            tasksSnapshot?.data ?? [];
                        List<TaskResponse> _tasksCompleted =
                            completedTasksSnapshot.data ?? [];

                        BarcodeScanner().turnOn((barcode) {
                          try {
                            Map barcodeScan = jsonDecode(barcode);
                            String _barcodeScanData = barcodeScan['scanData'];
                            bool _isProActive = _scannedProduct != null &&
                                currentIndexSelected == 0;
                            bool _isOpenTask =
                                isTaskOpen && (_selectedTaskId != null);

                            if (_isOpenTask) {
                              dynamic task = _tasksTodo
                                  .map((e) => e.task)
                                  .firstWhere(
                                      (e) => e.taskId == _selectedTaskId);
                              _scanShelf(_barcodeScanData, _isProActive,
                                  task: task);
                            } else if (_isProActive) {
                              _scanShelf(
                                _barcodeScanData,
                                _isProActive,
                                ean: _scannedProduct.ean,
                                quantity: _currentNumProducts,
                                type: _taskType,
                              );
                            } else {
                              _scanProduct(_barcodeScanData, _tasksTodo);
                            }
                          } catch (e) {
                            print(e.toString());
                          }
                        });
                        return Scaffold(
                            backgroundColor: Color(0xE5E5E5),
                            appBar: AppBar(
                              brightness: Brightness.light,
                              centerTitle: false,
                              title: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  "Tarefas",
                                  style: poppins(
                                      fontWeight: FontWeight.bold,
                                      size: 16,
                                      color: Colors.black),
                                ),
                              ),
                              actions: [
                                InkWell(
                                  onTap: () {
                                    _scan(_tasksTodo);
                                  },
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 8, 24, 8),
                                    child: SvgPicture.asset(
                                        "images/ic_scanner.svg"),
                                  ),
                                )
                              ],
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                            ),
                            body: Padding(
                              padding: const EdgeInsets.only(bottom: 70),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  _buildTabs(),
                                  currentIndexSelected == 0
                                      ? Expanded(
                                          child: _buildTodoTaskList(_tasksTodo))
                                      : Expanded(
                                          child: _buildCompletedTaskList(
                                              _tasksCompleted))
                                ],
                              ),
                            ));
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  );
                },
              );
            });
      },
    );
  }

  _buildTabs() {
    return Padding(
      padding: const EdgeInsets.only(top: 4, left: 8, bottom: 16),
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        SizedBox(width: 16),
        GestureDetector(
          onTap: () {
            setState(() {
              currentIndexSelected = 0;
            });
          },
          child: Container(
              decoration: BoxDecoration(
                  boxShadow: currentIndexSelected == 0
                      ? [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ]
                      : null,
                  color: currentIndexSelected == 0
                      ? Colors.black
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(4)),
              height: 32,
              width: 89,
              child: Center(
                child: Text("Atribuídas",
                    style: roboto(
                        color: currentIndexSelected == 0
                            ? Colors.white
                            : Colors.black,
                        size: 13,
                        fontWeight: FontWeight.w500)),
              )),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              currentIndexSelected = 1;
              _selectedIdStreamController.add(null);
            });
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 32),
            child: Container(
                decoration: BoxDecoration(
                    boxShadow: currentIndexSelected == 1
                        ? [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 3,
                              blurRadius: 5,
                              offset: Offset(0, 2),
                            ),
                          ]
                        : null,
                    color: currentIndexSelected == 1
                        ? Colors.black
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(4)),
                height: 32,
                width: 92,
                child: Center(
                  child: Text("Completas",
                      style: roboto(
                          color: currentIndexSelected == 1
                              ? Colors.white
                              : Colors.black,
                          size: 13,
                          fontWeight: FontWeight.w500)),
                )),
          ),
        )
      ]),
    );
  }

  _buildTodoTaskList(List<TaskResponse> _tasks) {
    return _tasks.length > 0 || _scannedProduct != null
        ? StreamBuilder<Object>(
            stream: _selectedIdStreamController.stream,
            builder: (context, idSnapshot) {
              if (idSnapshot.hasError) {
                return Text("Errors!");
              } else {
                _selectedTaskId = idSnapshot.data;
                int _taskId = idSnapshot.data;
                isTaskOpen = _taskId != null;
                int _numItems = (_tasks?.length ?? 0) + 2;
                return ScrollablePositionedList.separated(
                  physics: _taskId == null && _scannedProduct == null
                      ? BouncingScrollPhysics()
                      : NeverScrollableScrollPhysics(),
                  itemScrollController: _scrollController,
                  itemCount: _numItems,
                  separatorBuilder: (context, index) {
                    return Padding(padding: const EdgeInsets.only(top: 16));
                  },
                  itemBuilder: (context, index) {
                    int _index = index - 1;
                    if (index == 0) {
                      return _listHeader(_tasks);
                    } else if (index == (_numItems - 1)) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "Não há mais tarefas.",
                            style: roboto(
                              size: 12,
                              fontWeight: FontWeight.w400,
                              color: Color(0XFFADB5BD),
                            ),
                          ),
                        ),
                      );
                    } else {
                      switch (_tasks[_index].type) {
                        case TaskType.REPLENISMENT:
                          ReplenishmentTask _task =
                              _tasks[_index].task as ReplenishmentTask;
                          TaskCardState _cardState = (_task.taskId == _taskId &&
                                  _scannedProduct == null)
                              ? TaskCardState.OPEN
                              : (_taskId != null || _scannedProduct != null)
                                  ? TaskCardState.LOCKED
                                  : TaskCardState.DEFAULT;
                          return Padding(
                            padding: const EdgeInsets.only(left: 24, right: 24),
                            child: TaskWrapper(
                              id: _task.taskId,
                              cardState: _cardState,
                              slidableController: slidableController,
                              slideActions: [
                                IconSlideAction(
                                  color: Color(0xffADB5BD),
                                  iconWidget:
                                      Icon(Icons.snooze, color: Colors.white),
                                  onTap: () =>
                                      showSnackbar("A tarefa foi adiada.", () {
                                    BlocProvider.of<TaskBloc>(context)
                                        .add(SnoozeTask(id: _task.taskId));
                                  }),
                                ),
                                IconSlideAction(
                                  color: Color(0xffd9dee2),
                                  iconWidget: Icon(Icons.archive_outlined,
                                      color: Color(0xffa3acb4)),
                                  onTap: () => showSnackbar(
                                      "A tarefa foi eliminada.", () {
                                    BlocProvider.of<TaskBloc>(context)
                                        .add(ArchiveTask(id: _task.taskId));
                                  }),
                                ),
                              ],
                              onTap: () {
                                if (_cardState == TaskCardState.DEFAULT)
                                  openTask(_task, _tasks);
                              },
                              child: ReplenishmentCard(
                                task: _task,
                                cardState: _cardState,
                                onScan: (task) {
                                  _openScanner(task: task);
                                },
                                onCancel: () {
                                  _selectedIdStreamController.add(null);
                                  setState(() {});
                                },
                                onError: showErrorSnackbar,
                                currentNumProducts: _currentNumProducts,
                                currentConfirmationStep:
                                    _currentConfirmationStep,
                                isScanningStreamController:
                                    _isScanningStreamController,
                                numProductsStreamController:
                                    _numProductsStreamController,
                              ),
                            ),
                          );
                        case TaskType.MISPLACEMENT:
                          MisplacedTask _task =
                              _tasks[_index].task as MisplacedTask;
                          TaskCardState _cardState = (_task.taskId == _taskId &&
                                  _scannedProduct == null)
                              ? TaskCardState.OPEN
                              : (_taskId != null || _scannedProduct != null)
                                  ? TaskCardState.LOCKED
                                  : TaskCardState.DEFAULT;
                          return Padding(
                              padding:
                                  const EdgeInsets.only(left: 24, right: 24),
                              child: TaskWrapper(
                                id: _task.taskId,
                                cardState: _cardState,
                                slidableController: slidableController,
                                slideActions: [
                                  IconSlideAction(
                                    color: Color(0xffADB5BD),
                                    iconWidget:
                                        Icon(Icons.snooze, color: Colors.white),
                                    onTap: () => showSnackbar(
                                        "A tarefa foi adiada.", () {
                                      BlocProvider.of<TaskBloc>(context)
                                          .add(SnoozeTask(id: _task.taskId));
                                    }),
                                  ),
                                  IconSlideAction(
                                    color: Color(0xffd9dee2),
                                    iconWidget: Icon(Icons.archive_outlined,
                                        color: Color(0xffa3acb4)),
                                    onTap: () => showSnackbar(
                                        "A tarefa foi eliminada.", () {
                                      BlocProvider.of<TaskBloc>(context)
                                          .add(ArchiveTask(id: _task.taskId));
                                    }),
                                  ),
                                ],
                                onTap: () {
                                  if (_cardState == TaskCardState.DEFAULT)
                                    openTask(_task, _tasks);
                                },
                                child: MisplacementCard(
                                  task: _task,
                                  cardState: _cardState,
                                  onScan: (task) {
                                    _openScanner(task: task);
                                  },
                                  onCancel: () {
                                    _selectedIdStreamController.add(null);
                                    _resetTaskCardVariables();
                                    setState(() {});
                                  },
                                  onError: showErrorSnackbar,
                                  currentNumProducts: _currentNumProducts,
                                  currentConfirmationStep:
                                      _currentConfirmationStep,
                                  isScanningStreamController:
                                      _isScanningStreamController,
                                  numProductsStreamController:
                                      _numProductsStreamController,
                                ),
                              ));
                        case TaskType.GAP:
                          GapTask _task = _tasks[_index].task as GapTask;
                          TaskCardState _cardState = (_task.taskId == _taskId &&
                                  _scannedProduct == null)
                              ? TaskCardState.OPEN
                              : (_taskId != null || _scannedProduct != null)
                                  ? TaskCardState.LOCKED
                                  : TaskCardState.DEFAULT;
                          return Padding(
                              padding:
                                  const EdgeInsets.only(left: 24, right: 24),
                              child: TaskWrapper(
                                id: _task.taskId,
                                cardState: _cardState,
                                slidableController: slidableController,
                                slideActions: [
                                  IconSlideAction(
                                    color: Color(0xffADB5BD),
                                    iconWidget:
                                        Icon(Icons.snooze, color: Colors.white),
                                    onTap: () => showSnackbar(
                                        "A tarefa foi adiada.", () {
                                      BlocProvider.of<TaskBloc>(context)
                                          .add(SnoozeTask(id: _task.taskId));
                                    }),
                                  ),
                                  IconSlideAction(
                                    color: Color(0xffd9dee2),
                                    iconWidget: Icon(Icons.archive_outlined,
                                        color: Color(0xffa3acb4)),
                                    onTap: () => showSnackbar(
                                        "A tarefa foi eliminada.", () {
                                      BlocProvider.of<TaskBloc>(context)
                                          .add(ArchiveTask(id: _task.taskId));
                                    }),
                                  ),
                                ],
                                onTap: () {
                                  if (_cardState == TaskCardState.DEFAULT)
                                    openTask(_task, _tasks);
                                },
                                child: GapCard(
                                  task: _task,
                                  cardState: _cardState,
                                  onScan: (task) {
                                    _openScanner(task: task);
                                  },
                                  onCancel: () {
                                    _selectedIdStreamController.add(null);
                                    _resetTaskCardVariables();
                                    setState(() {});
                                  },
                                  onError: showErrorSnackbar,
                                  currentNumProducts: _currentNumProducts,
                                  currentConfirmationStep:
                                      _currentConfirmationStep,
                                  isScanningStreamController:
                                      _isScanningStreamController,
                                  numProductsStreamController:
                                      _numProductsStreamController,
                                ),
                              ));
                        default:
                          return Container();
                      }
                    }
                  },
                );
              }
            })
        : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset("images/ic_no_tasks.svg"),
                SizedBox(height: 36),
                Text(
                  "Parabéns!",
                  style: poppins(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      size: 16),
                ),
                SizedBox(height: 8),
                Text("Completaste todas as tuas tarefas!",
                    style: roboto(
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        size: 12))
              ],
            ),
          );
  }

  _buildNoSessionScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset("images/ic_no_session.svg"),
          SizedBox(height: 36),
          Text(
            "Aviso",
            style: poppins(
                color: Colors.black, fontWeight: FontWeight.bold, size: 16),
          ),
          SizedBox(height: 8),
          Text("Reinicia a tua atividade para conseguires realizar as tarefas",
              style: roboto(
                  fontWeight: FontWeight.w400, color: Colors.black, size: 12))
        ],
      ),
    );
  }

  _buildCompletedTaskList(List<TaskResponse> _tasks) {
    int _numItems = (_tasks?.length ?? 0) + 2;
    return _tasks.length > 0
        ? ListView.separated(
            padding: const EdgeInsets.only(bottom: 24),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: _numItems,
            separatorBuilder: (context, index) {
              return Padding(padding: const EdgeInsets.only(top: 16));
            },
            itemBuilder: (BuildContext context, int index) {
              int _index = index - 1;
              if (index == 0) {
                return _listHeader(_tasks);
              } else if (index == (_numItems - 1)) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Não existem mais tarefas completas.",
                      style: roboto(
                        size: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0XFFADB5BD),
                      ),
                    ),
                  ),
                );
              } else {
                switch (_tasks[_index].type) {
                  case TaskType.REPLENISMENT:
                    ReplenishmentTask _task =
                        _tasks[_index].task as ReplenishmentTask;
                    return Padding(
                      padding: const EdgeInsets.only(left: 24, right: 24),
                      child: ReplenishmentCard(
                        task: _task,
                        cardState: TaskCardState.COMPLETED,
                        onCancel: () {
                          _selectedIdStreamController.add(null);
                          setState(() {});
                        },
                        onError: showErrorSnackbar,
                        currentNumProducts: _currentNumProducts,
                        currentConfirmationStep: _currentConfirmationStep,
                        isScanningStreamController: _isScanningStreamController,
                        numProductsStreamController:
                            _numProductsStreamController,
                      ),
                    );
                  case TaskType.MISPLACEMENT:
                    MisplacedTask _task = _tasks[_index].task as MisplacedTask;
                    return Padding(
                        padding: const EdgeInsets.only(left: 24, right: 24),
                        child: MisplacementCard(
                          task: _task,
                          cardState: TaskCardState.COMPLETED,
                          onCancel: () {
                            _selectedIdStreamController.add(null);
                            setState(() {});
                          },
                          onError: showErrorSnackbar,
                          currentNumProducts: _currentNumProducts,
                          currentConfirmationStep: _currentConfirmationStep,
                          isScanningStreamController:
                              _isScanningStreamController,
                          numProductsStreamController:
                              _numProductsStreamController,
                        ));
                  case TaskType.GAP:
                    GapTask _task = _tasks[_index].task as GapTask;
                    return Padding(
                        padding: const EdgeInsets.only(left: 24, right: 24),
                        child: GapCard(
                          task: _task,
                          cardState: TaskCardState.COMPLETED,
                          onCancel: () {
                            _selectedIdStreamController.add(null);
                            setState(() {});
                          },
                          onError: showErrorSnackbar,
                          currentNumProducts: _currentNumProducts,
                          currentConfirmationStep: _currentConfirmationStep,
                          isScanningStreamController:
                              _isScanningStreamController,
                          numProductsStreamController:
                              _numProductsStreamController,
                        ));
                  default:
                    DefaultTask _task = _tasks[_index].task as DefaultTask;
                    return Padding(
                        padding: const EdgeInsets.only(left: 24, right: 24),
                        child: DefaultCard(
                          task: _task,
                          cardState: TaskCardState.COMPLETED,
                        ));
                }
              }
            },
          )
        : Center(
            child: Text("Ainda não há tarefas completas.",
                style: roboto(size: 12, color: Colors.black)));
  }

  /// Builds the number of results indicator and new task widget if the scanned
  /// product doesn't exist in the list.
  Widget _listHeader(List<TaskResponse> _tasks) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 24, right: 24),
          child: Text("${_tasks?.length} resultados",
              style: roboto(
                  size: 12,
                  fontWeight: FontWeight.w400,
                  color: Color(0xffADB5BD))),
        ),
        _scannedProduct != null && currentIndexSelected == 0
            ? Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 12),
                child: CreateTaskCard(
                  onError: showErrorSnackbar,
                  onScan: ({numProducts, product, type}) {
                    _openScanner(
                      ean: product.ean,
                      type: type,
                      quantity: _currentNumProducts,
                    );
                  },
                  onCancel: () {
                    _resetState();
                    setState(() {});
                  },
                  currentNumProducts: _currentNumProducts,
                  currentConfirmationStep: _currentConfirmationStep,
                  isScanningStreamController: _isScanningStreamController,
                  numProductsStreamController: _numProductsStreamController,
                  taskTypeStreamController: _taskTypeStreamController,
                  product: _scannedProduct,
                ),
              )
            : Container(),
      ],
    );
  }

  /// Active scan with no tasks open.
  void _scan(List<TaskResponse> _tasks) async {
    BarcodeScanner().scan((barcode) {
      try {
        Map barcodeScan = jsonDecode(barcode);
        String _barcodeScanData = barcodeScan['scanData'];
        _scanProduct(_barcodeScanData, _tasks);
      } catch (e) {
        print(e.toString());
      }
    });
  }

  void _openScanner(
      {dynamic task, String ean, TaskType type, int quantity}) async {
    BarcodeScanner().scan((barcode) {
      try {
        Map barcodeScan = jsonDecode(barcode);
        String _barcodeScanData = barcodeScan['scanData'];
        bool isProactive = task == null;
        _scanShelf(
          _barcodeScanData,
          isProactive,
          ean: ean,
          task: task,
          type: type,
          quantity: quantity,
        );
      } catch (e) {
        _isScanningStreamController.add(0);
        print(e.toString());
      }
    });
  }

  /// Takes the result of a product scan, scrolls to its position in the list
  /// and opens the card. If the task does not exist in the list, a proactive
  /// card will be created and opened.
  void _scanProduct(String ean, List<TaskResponse> tasks) {
    if (!isTaskOpen) {
      currentIndexSelected = 0;
      TaskResponse _task = tasks
          .firstWhere((element) => element.task.product.ean == ean, orElse: () {
        print("Scanned but didnt find in list");
        BlocProvider.of<TaskBloc>(context).add(GetProduct(ean.toString()));
        return null;
      });
      slidableController?.activeState?.close();
      if (_task != null) {
        openTask(_task.task, tasks);
      }
    }
  }

  /// Takes the result of a shelf scan, which means a task card is open, and
  /// handles it if it's valid.
  _scanShelf(String shelfCode, bool isProActive,
      {dynamic task, String ean, TaskType type, int quantity}) {
    _isScanningStreamController.add(1);
    bool isValid = _confirmShelfEan(shelfCode);
    if (isValid) {
      isProActive
          ? _handleProActiveTask(
              ean, type, shelfCode.replaceAll("shelf:", ""), quantity)
          : _handleOpenTask(shelfCode, task);
    } else {
      showErrorSnackbar(message: "Código de prateleira inválido. ($shelfCode)");
    }
  }

  // Handlers
  //
  //

  void openTask(dynamic task, List<TaskResponse> tasks) {
    int index = tasks.map((e) => e.task).toList().indexOf(task);
    _scrollToIndex(index);
    _selectedIdStreamController.add(task.taskId);
    _currentNumProducts = task.quantity;
    slidableController?.activeState?.close();
  }

  Future _scrollToIndex(int index) async {
    _scrollController.scrollTo(
        index: index, duration: Duration(milliseconds: 500));
  }

  void _handleOpenTask(String ean, dynamic task) {
    String type = task.type;

    switch (type.toTaskType()) {
      case TaskType.MISPLACEMENT:
        _handleMisplacement(ean, () {
          var completeMisplacementTaskRequest = CompleteMisplacementTaskRequest(
              taskId: task.taskId,
              ean: task.product.ean,
              originShelfExternalId: _shelves[0].externalId,
              destinationShelfExternalId: _shelves[1].externalId,
              quantity: _currentNumProducts);
          BlocProvider.of<TaskBloc>(context)
              .add(CompleteMisplacedTask(completeMisplacementTaskRequest));
        });
        break;
      case TaskType.REPLENISMENT:
        var completeReplenishmentTaskRequest = CompleteReplenishmentTaskRequest(
            taskId: task.taskId,
            ean: task.product.ean,
            shelfExternalId: ean.replaceAll("shelf:", ""),
            quantity: _currentNumProducts);
        BlocProvider.of<TaskBloc>(context)
            .add(CompleteReplenishmentTask(completeReplenishmentTaskRequest));
        break;
      case TaskType.GAP:
        var completeGapTaskRequest = CompleteGapTaskRequest(
            taskId: task.taskId,
            ean: task.product.ean,
            shelfExternalId: ean.replaceAll("shelf:", ""),
            quantity: _currentNumProducts);
        BlocProvider.of<TaskBloc>(context)
            .add(CompleteGapTask(completeGapTaskRequest));
        break;
      default:
    }
  }

  void _handleProActiveTask(
      String ean, TaskType type, String shelf, int quantity) {
    TaskEvent event;
    switch (type) {
      case TaskType.MISPLACEMENT:
        _handleMisplacement(ean, () {
          event = CreateMisplacementTask(
            CompleteMisplacementTaskRequest(
              ean: ean,
              quantity: quantity,
              originShelfExternalId: _shelves[0].externalId,
              destinationShelfExternalId: _shelves[1].externalId,
            ),
          );
        });
        break;
      case TaskType.REPLENISMENT:
        _shelves.add(Shelf(externalId: shelf));
        event = CreateReplenishmentTask(
          CompleteReplenishmentTaskRequest(
            ean: ean,
            quantity: quantity,
            shelfExternalId: _shelves[0].externalId,
          ),
        );
        break;
      case TaskType.GAP:
        _shelves.add(Shelf(externalId: shelf));
        event = CreateGapTask(
          CompleteGapTaskRequest(
            ean: ean,
            quantity: quantity,
            shelfExternalId: _shelves[0].externalId,
          ),
        );
        break;
      case TaskType.WITHDRAWN:
        _shelves.add(Shelf(externalId: shelf));
        event = CreateWithdrawnTask(
          WithdrawnTaskInput(
            ean: ean,
            quantity: quantity,
            shelfExternalId: _shelves[0].externalId,
          ),
        );
        break;
      case TaskType.UNSALEABLE:
        _shelves.add(Shelf(externalId: shelf));
        event = CreateUnsaleableTask(
          UnsaleableTaskInput(
            ean: ean,
            quantity: quantity,
            shelfExternalId: _shelves[0].externalId,
          ),
        );
        break;
      default:
    }
    if (event != null) BlocProvider.of<TaskBloc>(context).add(event);
  }

  _handleMisplacement(String ean, Function completion) {
    setState(() {
      _currentConfirmationStep++;
      _shelves.add(Shelf(externalId: ean.replaceAll("shelf:", "")));
      if (_currentConfirmationStep >= 2) {
        completion();
      }
    });
  }

  bool _confirmShelfEan(dynamic ean) {
    try {
      bool _isValid = ean.startsWith("shelf:");
      return _isValid;
    } catch (e) {
      return false;
    }
  }

  // Warnings
  //
  //

  void showSnackbar(String message, Function onLeewayPassed) {
    bool _shouldComplete = true;
    Future.delayed(Duration(seconds: 3), () {
      if (_shouldComplete) onLeewayPassed();
    });
    Scaffold.of(context).showSnackBar(
      SnackBar(
        elevation: 0,
        duration: Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Anular',
          textColor: Colors.white,
          onPressed: () {
            _shouldComplete = false;
            setState(() {
              _resetState();
            });
          },
        ),
        margin: EdgeInsets.fromLTRB(24, 0, 24, 0),
        behavior: SnackBarBehavior.floating,
        content: Container(
          child: Text(
            message ?? "",
            style: roboto(
              size: 12,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  void showErrorSnackbar({@required String message}) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        elevation: 0,
        duration: Duration(seconds: 3),
        backgroundColor: Colors.red,
        margin: EdgeInsets.fromLTRB(24, 0, 24, 0),
        behavior: SnackBarBehavior.floating,
        content: Container(child: Text(message)),
      ),
    );
  }
}
