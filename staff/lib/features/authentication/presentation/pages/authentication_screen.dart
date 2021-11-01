import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:staffapp/constants/styles.dart';
import 'package:staffapp/env/domain_controller.dart';
import 'package:staffapp/features/authentication/bloc/authentication_bloc.dart';
import 'package:staffapp/features/navigation/navigation_shell.dart';
import 'package:staffapp/features/task/data/barcode_scanner.dart';
import 'package:staffapp/network/error_codes.dart';
import 'package:staffapp/network/model/requests/authentication.dart';
import 'package:staffapp/network/model/user.dart';
import 'package:staffapp/network/network_defaults.dart';
import 'package:staffapp/widgets/sensei_text_field.dart';

class AuthenticationScreen extends StatefulWidget {
  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  final _formKeyAuthentication = GlobalKey<FormState>();
  TextEditingController _textEditingControllerUsername;
  TextEditingController _textEditingControllerPassword;
  bool isPasswordVisible = false;
  String usernameError;
  String passwordError;
  BarcodeScanner barcodeScanner = BarcodeScanner();

  @override
  void initState() {
    _textEditingControllerUsername = TextEditingController();
    _textEditingControllerPassword = TextEditingController();
    barcodeScanner.createProfile("SenseiProfile");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          reverse: true,
          child: Column(
            children: [
              _buildTopContainer(),
              _buildTitle(),
              _buildSubtitle(),
              _buildAuthenticationForm(),
              _addSpacing()
            ],
          ),
        ),
      ),
    );
  }

  _buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(35),
      child: AppBar(
          brightness: Brightness.light,
          elevation: 0,
          centerTitle: true,
          backgroundColor: MediaQuery.of(context).viewInsets.bottom == 0
              ? Colors.grey[100]
              : Colors.white,
          title: SvgPicture.asset("images/ic_logo.svg")),
    );
  }

  _buildTopContainer() {
    return Stack(alignment: Alignment.topCenter, children: [
      Container(
          color: Colors.grey[100],
          height: MediaQuery.of(context).size.height * 0.15),
      Padding(
        padding: const EdgeInsets.only(top: 20),
        child: SvgPicture.asset("images/ic_login_icon.svg",
            width: 160, height: 130),
      ),
    ]);
  }

  _buildTitle() {
    return Padding(
      padding: const EdgeInsets.only(top: 13),
      child: Text(
        "Bem-vindo de volta",
        style:
            poppins(size: 16, color: Colors.black, fontWeight: FontWeight.w600),
      ),
    );
  }

  _buildSubtitle() {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Text(
        "Insira as suas credenciais para entrar",
        style:
            roboto(size: 16, color: Colors.black, fontWeight: FontWeight.w400),
      ),
    );
  }

  _buildAuthenticationForm() {
    return Padding(
      padding: const EdgeInsets.only(top: 21, right: 24, left: 24),
      child: Form(
          key: _formKeyAuthentication,
          child: Column(children: <Widget>[
            SenseiTextField(
              onFocusChange: (isFocus) {
                if (isFocus) {
                  setState(() {});
                }
              },
              textEditingController: _textEditingControllerUsername,
              label: "Número mecanográfico",
              errorText: usernameError,
              validator: (value) {
                setState(() {
                  usernameError =
                      value.isEmpty ? setLocalUsernameError() : null;
                });
                return null;
              },
            ),
            SizedBox(height: 5),
            SenseiTextField(
              onFocusChange: (isFocus) {
                if (isFocus) {
                  setState(() {});
                }
              },
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    isPasswordVisible = !isPasswordVisible;
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: SvgPicture.asset(isPasswordVisible
                      ? 'images/ic_password_visible.svg'
                      : 'images/ic_password_invisible.svg'),
                ),
              ),
              textInputType: TextInputType.visiblePassword,
              hideText: !isPasswordVisible,
              textEditingController: _textEditingControllerPassword,
              errorText: passwordError,
              label: "Palavra-passe",
              validator: (value) {
                setState(() {
                  passwordError =
                      value.isEmpty ? setLocalPasswordError() : null;
                });
              },
            ),
            SizedBox(height: 10),
            BlocConsumer<AuthenticationBloc, AuthenticationBlocState>(
                cubit: BlocProvider.of<AuthenticationBloc>(context),
                listenWhen: (previous, current) =>
                    current is AuthenticationLoaded ||
                    current is AuthenticationError,
                listener: (context, state) async {
                  if (state is AuthenticationLoaded) {
                    await saveSharedPreferences(
                      state.authenticationResponse.accessToken,
                      state.authenticationResponse.refreshToken,
                      state.authenticationResponse.user,
                    );
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NavigationShell()),
                    );
                  } else if (state is AuthenticationError) {
                    if (state.senseiError.errorCode ==
                        ErrorCodes().INVALID_PASSWORD) {
                      setState(() {
                        passwordError = setApiCallPasswordError();
                      });
                    } else if (state.senseiError.errorCode ==
                        ErrorCodes().INVALID_USER) {
                      setState(() {
                        usernameError = setApiCallUsernameError();
                      });
                    }
                  }
                },
                buildWhen: (previous, current) =>
                    (current is AuthenticationLoading) ||
                    (current is AuthenticationInitial) ||
                    (current is AuthenticationError),
                builder: (context, state) {
                  if (state is AuthenticationInitial) {
                    return _buildLoginButton();
                  } else if (state is AuthenticationLoading) {
                    return CircularProgressIndicator(
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(Colors.black));
                  } else if (state is AuthenticationError) {
                    return _buildLoginButton();
                  } else {
                    return _buildLoginButton();
                  }
                })
          ])),
    );
  }

  _buildLoginButton() {
    return RaisedButton(
      onPressed: () {
        if (_formKeyAuthentication.currentState.validate()) {
          String username = _textEditingControllerUsername.text;
          String password = _textEditingControllerPassword.text;

          AuthenticationRequest authenticationRequest = AuthenticationRequest(
              username: username,
              password: password,
              domainName: DomainController().domain);

          if (username.isNotEmpty && password.isNotEmpty) {
            BlocProvider.of<AuthenticationBloc>(context).add(
                PerformAuthentication(authentication: authenticationRequest));
          }
        }
      },
      child: Text('Log in'),
    );
  }

  setLocalUsernameError() {
    return 'Insira o seu número mecanográfico';
  }

  setLocalPasswordError() {
    return 'Insira a sua palavra-passe';
  }

  setApiCallUsernameError() {
    return "Número mecanográfico não é válido";
  }

  setApiCallPasswordError() {
    return "Palavra-passe não é valida";
  }

  /// This allows the last widget to be on top of the keyboard all the time
  _addSpacing() {
    return Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 10));
  }

  saveSharedPreferences(String token, String refreshToken, User user) async {
    await NetworkDefaults.setToken(token);
    await NetworkDefaults.setRefreshToken(refreshToken);
    await NetworkDefaults.setUserName(user.name);
  }
}
