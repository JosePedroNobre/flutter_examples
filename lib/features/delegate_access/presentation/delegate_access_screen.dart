import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:staffapp/constants/styles.dart';
import 'package:staffapp/features/delegate_access/bloc/delegate_access_bloc.dart';
import 'package:staffapp/network/model/access.dart';
import 'package:staffapp/widgets/dash_separator.dart';
import 'package:staffapp/widgets/sensei_qr_code.dart';
import 'package:staffapp/widgets/sensei_text_field.dart';

class DelegateAccessScreen extends StatefulWidget {
  @override
  _DelegateAccessScreenState createState() => _DelegateAccessScreenState();
}

class _DelegateAccessScreenState extends State<DelegateAccessScreen> {
  List<Access> listOfAccess;
  TextEditingController inputController;

  @override
  void initState() {
    listOfAccess = _setData();
    inputController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xE5E5E5),
      appBar: AppBar(
        brightness: Brightness.light,
        centerTitle: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            "Delegar Acesso",
            style: poppins(
                color: Colors.black, fontWeight: FontWeight.w600, size: 16),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 70),
        child: _buildList(),
      ),
    );
  }

  _buildList() {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: listOfAccess.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: _buildItem(listOfAccess[index]),
        );
      },
    );
  }

  _buildItem(Access access) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Card(
          elevation: 0,
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    var isAlreadyOpen = access.isOpened;

                    /// close all tabs
                    listOfAccess.forEach((element) {
                      element.isOpened = false;
                    });

                    /// open selected tab only if it's not already open
                    if (!isAlreadyOpen) {
                      access.isOpened = !access.isOpened;
                      if (!access.hasTextInput) {
                        BlocProvider.of<DelegateAccessBloc>(context)
                            .add(GetDelegateAccess(access.name, context));
                      }
                    } else {
                      BlocProvider.of<DelegateAccessBloc>(context)
                          .add(ResetDelegateAccess());
                      inputController.text = "";
                    }
                  });
                },
                child: Container(
                  color: Colors.white,
                  margin: const EdgeInsets.only(
                      left: 4, top: 0, bottom: 0, right: 4),
                  padding: const EdgeInsets.only(
                      left: 20, top: 8, bottom: 8, right: 20),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SvgPicture.asset(access.image, width: 62, height: 62),
                      SizedBox(width: 18),
                      Text(
                        access.name,
                        style: roboto(
                            size: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                  visible: access.isOpened, child: _buildExpandable(access))
            ],
          )),
    );
  }

  _buildExpandable(Access access) {
    return BlocConsumer<DelegateAccessBloc, DelegateAccessState>(
      cubit: BlocProvider.of<DelegateAccessBloc>(context),
      listenWhen: (previous, current) => null,
      listener: (context, state) => null,
      buildWhen: (previous, current) =>
          (current is DelegateAccessInitial) ||
          (current is DelegateAccessLoading) ||
          (current is DelegateAccessLoaded) ||
          (current is DelegateAccessError),
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(
            left: 20,
            top: 8,
            bottom: 8,
            right: 20,
          ),
          child: Column(children: [
            DashSeparator(witdh: 5, height: 1, color: Color(0xffDEE2E6)),
            _buildExpandableInput(access, state),
            _buildExpandableQrCode(access, state),
          ]),
        );
      },
    );
  }

  _buildExpandableInput(Access access, DelegateAccessState state) {
    return Visibility(
      visible: access.hasTextInput,
      child: Padding(
        padding: const EdgeInsets.only(top: 24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 4,
              child: SenseiTextField(
                  labelSize: 15,
                  onFieldSubmitted: (text) {
                    _submit(access);
                  },
                  onTextChange: (text) {
                    BlocProvider.of<DelegateAccessBloc>(context)
                        .add(ResetDelegateAccess());
                  },
                  label: "A quem vais dar acesso?",
                  textEditingController: inputController,
                  errorText: null),
            ),
            SizedBox(width: 18),
            Expanded(
              flex: 1,
              child: _externalAccessSubmitButton(access, state),
            ),
          ],
        ),
      ),
    );
  }

  _submit(Access access) {
    BlocProvider.of<DelegateAccessBloc>(context).add(
      GetDelegateAccess(inputController.text, context),
    );
    access.showQrCode = inputController.text.isNotEmpty;
    FocusScope.of(context).unfocus();
  }

  Widget _externalAccessSubmitButton(Access access, DelegateAccessState state) {
    Widget _icon = Icon(Icons.arrow_forward);
    Function _onTap;
    if (state is DelegateAccessLoaded) {
      _icon = Icon(Icons.check);
    } else if (state is DelegateAccessLoading) {
      _icon = Padding(
        padding: const EdgeInsets.all(16.0),
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
        ),
      );
    } else if (state is DelegateAccessError) {
      _icon = Icon(Icons.arrow_forward);
    } else {
      _onTap = () => _submit(access);
      _icon = Icon(Icons.arrow_forward);
    }

    return Container(
      height: 48,
      width: 48,
      child: _onTap != null ? InkWell(child: _icon, onTap: _onTap) : _icon,
    );
  }

  Widget _buildExpandableQrCode(Access access, DelegateAccessState state) {
    return Visibility(
      visible: access.showQrCode,
      child: _buildQRCode(state),
    );
  }

  Widget _buildQRCode(DelegateAccessState state) {
    if (state is DelegateAccessLoaded) {
      return SenseiQRCode(
        data: state.gateToken.token,
        height: 235,
        width: 235,
      );
    } else if (state is DelegateAccessLoading) {
      return SenseiQRCode(
        data: null,
        height: 235,
        width: 235,
      );
    } else if (state is DelegateAccessError) {
      return Center(
          child: Text(state.senseiError?.message ?? "An error occurred"));
    } else
      return Container();
  }

  /// set data to create the menus
  _setData() {
    return [
      Access(
        id: 1,
        name: "Limpeza",
        qrData: "someToken",
        lastAccess: "20 de Agosto às 08:22",
        image: "images/ic_cleaning.svg",
        hasTextInput: false,
      ),
      Access(
        id: 2,
        name: "Manutenção",
        qrData: "someToken2",
        lastAccess: "20 de Agosto às 08:22",
        image: "images/ic_maintenance.svg",
        hasTextInput: false,
      ),
      Access(
        id: 3,
        name: "Inspeção",
        qrData: "someToken3",
        lastAccess: "20 de Agosto às 08:22",
        image: "images/ic_inspection.svg",
        hasTextInput: false,
      ),
      Access(
        id: 4,
        name: "Visitantes Externos",
        qrData: "someToken4",
        image: "images/ic_external_visitors.svg",
        lastAccess: "20 de Agosto às 08:22",
        hasTextInput: false,
      ),
      Access(
          id: 5,
          name: "Outro",
          qrData: "someToken5",
          showQrCode: false,
          hasTextInput: true,
          lastAccess: "20 de Agosto às 08:22",
          image: "images/ic_other.svg")
    ];
  }

  @override
  void dispose() {
    super.dispose();
  }
}
