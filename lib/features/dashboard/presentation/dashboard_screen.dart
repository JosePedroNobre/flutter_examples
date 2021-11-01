import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:staffapp/constants/enums.dart';
import 'package:staffapp/constants/styles.dart';
import 'package:staffapp/features/authentication/presentation/pages/authentication_screen.dart';
import 'package:staffapp/features/dashboard/bloc/dashboard_bloc.dart';
import 'package:staffapp/features/dashboard/presentation/store_capacity_card.dart';
import 'package:staffapp/network/model/store_occupancy_payload.dart';
import 'package:staffapp/network/model/system_status_payload.dart';
import 'package:staffapp/network/model/task_response.dart';
import 'package:staffapp/network/model/work_session_status_payload.dart';
import 'package:staffapp/network/network_defaults.dart';
import 'package:staffapp/network/work_session_payload.dart';
import 'package:staffapp/widgets/sensei_fill_button.dart';
import 'package:staffapp/widgets/sensei_shimmer.dart';

class DashboardScreen extends StatefulWidget {
  final Stream<SystemStatusPayload> systemStatusStream;
  final Stream<StoreOccupancyPayload> occupancyStream;
  final Stream<WorkSessionPayload> numberOpenSessionsStream;
  final Stream<WorkSessionStatusPayload> workSessionStatusStream;
  final Stream<List<TaskResponse>> storeTaskPayloadStream;
  final Stream<List<TaskResponse>> storeTaskCompletedStream;

  DashboardScreen({
    this.systemStatusStream,
    this.occupancyStream,
    this.numberOpenSessionsStream,
    this.workSessionStatusStream,
    this.storeTaskPayloadStream,
    this.storeTaskCompletedStream,
  });
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool activityInProgress = true;
  bool storeStatus = true;

  final int maxNumPeopleStore = 30;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xE5E5E5),
      appBar: _buildAppbar(),
      body: Padding(
          padding: const EdgeInsets.only(left: 24, right: 24),
          child: ScrollConfiguration(
            behavior: new ScrollBehavior()
              ..buildViewportChrome(context, null, AxisDirection.down),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 70),
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 120),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildActivityCard(),
                    _buildStoreStatus(),
                    _buildTasksProgress(),
                    _buildStoreOccupancy(),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  _buildAppbar() {
    return AppBar(
      brightness: Brightness.light,
      centerTitle: false,
      backgroundColor: Color(0xE5E5E5),
      elevation: 0,
      title: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: FutureBuilder(
            future: NetworkDefaults.getUserName(),
            builder: (context, userName) {
              if (userName.hasData)
                return Text(
                  "Olá, ${userName.data}",
                  style: poppins(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      size: 16),
                );
              return Container();
            }),
      ),
      actions: [
        GestureDetector(
          onTap: () => logout(),
          child: Padding(
            padding: const EdgeInsets.only(right: 24),
            child: SvgPicture.asset("images/ic_logout.svg"),
          ),
        )
      ],
    );
  }

  void showSnackbar(bool activityStopped) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        elevation: 0,
        action: SnackBarAction(
          textColor: Colors.white,
          label: 'Ok',
          onPressed: () {
            // Code to execute.
          },
        ),
        margin: EdgeInsets.fromLTRB(24, 0, 24, 0),
        behavior: SnackBarBehavior.floating,
        content: Container(
            child: Text(activityStopped
                ? "As tuas tarefas foram restribuídas."
                : "A tua atividade foi iniciada.")),
      ),
    );
  }

  _buildActivityCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Colors.white,
      ),
      child: StreamBuilder<WorkSessionStatusPayload>(
        stream: widget.workSessionStatusStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SenseiShimmer(height: 100);
          } else if (snapshot.connectionState == ConnectionState.active) {
            activityInProgress = snapshot.data.myWorkSessionStatus != "closed";
            return Padding(
              padding: const EdgeInsets.only(
                  top: 12, left: 16, right: 16, bottom: 16),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset("images/ic_alarm.svg"),
                        SizedBox(width: 4),
                        Text("Actividade",
                            style: roboto(
                                size: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black)),
                        Spacer(),
                        Visibility(
                          visible: !activityInProgress,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color(0xffFB5354).withOpacity(0.4),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(2))),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 6, right: 6, top: 3, bottom: 3),
                              child: Text(
                                "ATENÇÃO",
                                style: poppins(
                                  color: Color(0xffFB5354),
                                  fontWeight: FontWeight.bold,
                                  size: 10,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          "A sua actividade está em",
                          style: roboto(
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                              size: 14),
                        ),
                        SizedBox(width: 4),
                        activityInProgress
                            ? Text(
                                "curso",
                                style: roboto(
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff22cd72),
                                    size: 14),
                              )
                            : Text(
                                "pausa",
                                style: roboto(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.red,
                                    size: 14),
                              ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Container(
                      width: 260,
                      child: Text(
                        activityInProgress
                            ? "Para interromper a sua atividade, pressione continuamente o botão até que este fique preenchido."
                            : "Para executar as suas tarefas, tem que reiniciar a sua atividade na loja. Para este efeito, basta clicar no botão abaixo.",
                        style: roboto(
                            fontWeight: FontWeight.normal,
                            height: 1.4,
                            color: Color(0xffADB5BD),
                            size: 12),
                      ),
                    ),
                    SizedBox(height: 13),
                    SenseiFillButton(
                        activityInProgress: activityInProgress,
                        onReboot: () {
                          BlocProvider.of<DashboardBloc>(context)
                              .add(StartWorkSession());
                          showSnackbar(false);
                        },
                        onComplete: () {
                          BlocProvider.of<DashboardBloc>(context)
                              .add(StopWorkSession());
                          showSnackbar(true);
                        })
                  ]),
            );
          } else {
            return Center(child: Text("Error loading work session activity"));
          }
        },
      ),
    );
  }

  _buildStoreStatus() {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Container(
        width: double.infinity,
        child: StreamBuilder<SystemStatusPayload>(
            stream: widget.systemStatusStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SenseiShimmer(height: 100);
              } else if (snapshot.connectionState == ConnectionState.active) {
                storeStatus = snapshot.data.status == "OK" ? true : false;
                return Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset("images/ic_store.svg"),
                              SizedBox(width: 4),
                              Text("Painel de controlo da loja",
                                  style: roboto(
                                      size: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black)),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                storeStatus
                                    ? "O sistema da loja está em"
                                    : "O sistema da loja está",
                                style: roboto(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                    size: 14),
                              ),
                              SizedBox(width: 4),
                              storeStatus
                                  ? Text(
                                      "funcionamento",
                                      style: roboto(
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xff22cd72),
                                          size: 14),
                                    )
                                  : Text(
                                      "parado",
                                      style: roboto(
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xfffbb675),
                                          size: 14),
                                    ),
                            ],
                          ),
                        ]),
                  ),
                );
              } else {
                return Center(child: Text("Error"));
              }
            }),
      ),
    );
  }

  _buildTasksProgress() {
    return StreamBuilder<WorkSessionPayload>(
        stream: widget.numberOpenSessionsStream,
        builder: (context, numberOpenSessionsSnapshot) {
          return StreamBuilder<StoreOccupancyPayload>(
              stream: widget.occupancyStream,
              builder: (context, storeOccupancySnapshot) {
                return Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.white,
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 16, left: 16),
                            child: Row(
                              children: [
                                SvgPicture.asset("images/ic_tasks.svg"),
                                SizedBox(width: 4),
                                Text("Progresso das tarefas",
                                    style: roboto(
                                        size: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black)),
                              ],
                            ),
                          ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                width: 128,
                                height: 70,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                    border: Border.all(
                                        color: Colors.black.withOpacity(0.4),
                                        width: 0.1)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    numberOpenSessionsSnapshot
                                                .connectionState ==
                                            ConnectionState.waiting
                                        ? SenseiShimmer()
                                        : numberOpenSessionsSnapshot
                                                    .connectionState ==
                                                ConnectionState.active
                                            ? Text(
                                                numberOpenSessionsSnapshot
                                                    .data.openWorkSessions
                                                    ?.toString(),
                                                style: poppins(
                                                    fontWeight: FontWeight.bold,
                                                    size: 16,
                                                    color: Colors.black))
                                            : Text("0",
                                                style: poppins(
                                                    fontWeight: FontWeight.bold,
                                                    size: 16,
                                                    color: Colors.black)),
                                    SizedBox(height: 4),
                                    Text("Colegas online",
                                        style: roboto(
                                            fontWeight: FontWeight.w400,
                                            size: 12,
                                            color: Color(0xff8C939B)),
                                        textAlign: TextAlign.center)
                                  ],
                                ),
                              ),
                              Container(
                                width: 128,
                                height: 70,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                    border: Border.all(
                                        color: Colors.black.withOpacity(0.4),
                                        width: 0.1)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    storeOccupancySnapshot.connectionState ==
                                            ConnectionState.waiting
                                        ? SenseiShimmer()
                                        : storeOccupancySnapshot
                                                    .connectionState ==
                                                ConnectionState.active
                                            ? Text(
                                                storeOccupancySnapshot.data
                                                    .externalAccessesRegistered
                                                    ?.toString(),
                                                style: poppins(
                                                    fontWeight: FontWeight.bold,
                                                    size: 16,
                                                    color: Colors.black))
                                            : Text("0",
                                                style: poppins(
                                                    fontWeight: FontWeight.bold,
                                                    size: 16,
                                                    color: Colors.black)),
                                    SizedBox(height: 4),
                                    Text("Acesso externo reg.",
                                        style: roboto(
                                            fontWeight: FontWeight.w400,
                                            size: 12,
                                            color: Color(0xff8C939B)),
                                        textAlign: TextAlign.center)
                                  ],
                                ),
                              )
                            ],
                          ),
                          _buildTasksProgressValues()
                        ]),
                  ),
                );
              });
        });
  }

  _buildTasksProgressValues() {
    return StreamBuilder<List<TaskResponse>>(
        stream: widget.storeTaskCompletedStream,
        builder: (context, taskCompletedSnapshot) {
          return StreamBuilder<List<TaskResponse>>(
              stream: widget.storeTaskPayloadStream,
              builder: (context, taskTodoSnapshot) {
                int numCompletedMisplacement = getElementsOfType(
                    TaskType.MISPLACEMENT,
                    tasks: taskCompletedSnapshot.data);
                int numCompletedReplenishment = getElementsOfType(
                    TaskType.REPLENISMENT,
                    tasks: taskCompletedSnapshot.data);
                int numCompletedUnsaleable = getElementsOfType(
                    TaskType.UNSALEABLE,
                    tasks: taskCompletedSnapshot.data);
                int numCompletedWithdrawn = getElementsOfType(
                    TaskType.WITHDRAWN,
                    tasks: taskCompletedSnapshot.data);

                int numTodoMisplacement = getElementsOfType(
                    TaskType.MISPLACEMENT,
                    tasks: taskTodoSnapshot.data);
                int numTodoReplenishment = getElementsOfType(
                    TaskType.REPLENISMENT,
                    tasks: taskTodoSnapshot.data);

                bool isLoading = !(taskCompletedSnapshot.connectionState ==
                        ConnectionState.active) ||
                    !(taskTodoSnapshot.connectionState ==
                        ConnectionState.active);

                return Container(
                  child: Column(children: [
                    SizedBox(height: 16),
                    _buildTaskProgressItem(
                      "Reposições",
                      "$numCompletedReplenishment of ${numCompletedReplenishment + numTodoReplenishment}",
                      isLoading,
                    ),
                    _buildTaskProgressItem(
                      "Alocação",
                      "$numCompletedMisplacement of ${numCompletedMisplacement + numTodoMisplacement}",
                      isLoading,
                    ),
                    _buildTaskProgressItem(
                      "Quebras registadas",
                      "$numCompletedUnsaleable",
                      isLoading,
                    ),
                    _buildTaskProgressItem(
                      "Produtos retirados",
                      "$numCompletedWithdrawn",
                      isLoading,
                    ),
                  ]),
                );
              });
        });
  }

  getElementsOfType(TaskType type, {List<TaskResponse> tasks}) {
    if (tasks == null) return 0;
    return tasks.where((element) => element.type == type).toList().length;
  }

  _buildTaskProgressItem(String title, String progress, bool isLoading) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 10),
      child: Row(
        children: [
          Text(title,
              style: roboto(
                  size: 14,
                  fontWeight: FontWeight.w400,
                  color:
                      activityInProgress ? Colors.black : Color(0xffCED4DA))),
          Spacer(),
          !isLoading
              ? Text(progress,
                  style: roboto(
                      size: 14,
                      fontWeight: FontWeight.w400,
                      color: activityInProgress
                          ? Color(0xff8C939B)
                          : Color(0xffCED4DA)))
              : SenseiShimmer(),
          SizedBox(width: 16)
        ],
      ),
    );
  }

  _buildStoreOccupancy() {
    return StreamBuilder<StoreOccupancyPayload>(
        stream: widget.occupancyStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Padding(
              padding: const EdgeInsets.only(top: 10),
              child: SenseiShimmer(
                height: 100,
                width: double.infinity,
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.active) {
            return StoreCapacityCard(
              maxNumPeopleStore:
                  snapshot.hasData ? snapshot.data.maximumOccupancy : 0,
              numPeopleStore: snapshot.hasData ? snapshot.data.occupation : 0,
            );
          } else {
            return Text("Error while loading the store capacity");
          }
        });
  }

  logout() async {
    await NetworkDefaults.removeAll();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => AuthenticationScreen()),
        (Route<dynamic> route) => false);
  }
}
