import 'package:customer/env/domain_controller.dart';
import 'package:customer/features/authentication/bloc/authentication_bloc.dart';
import 'package:customer/features/navigation/navigation_screen.dart';
import 'package:customer/features/onboarding/onboarding_screen.dart';
import 'package:customer/network/model/requests/authentication.dart';
import 'package:customer/network/network_defaults.dart';
import 'package:flutter/material.dart';
import 'package:customer/constants/styles.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TermsAndConditionsScreen extends StatefulWidget {
  @override
  _TermsAndConditionsScreenState createState() =>
      _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _buildAppBar(),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 24, top: 8, right: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle(),
              _buildSubtitle(),
              _buildBody(),
              _nextButtonConsumer(),
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
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        brightness: Brightness.light,
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
    );
  }

  _buildTitle() {
    return Padding(
      padding: const EdgeInsets.only(top: 13),
      child: Text(
        "Terms & conditions",
        style:
            font1(size: 28, color: Colors.black, fontWeight: FontWeight.w600),
      ),
    );
  }

  _buildSubtitle() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        "By creating an account on Sensei App, you’re agreeing with our Terms of Service and Privacy Policy.",
        style: font2(
            size: 16, color: Color(0xff4F575E), fontWeight: FontWeight.w300),
      ),
    );
  }

  _buildBody() {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Container(
        height: MediaQuery.of(context).size.height - 420,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Text(
            "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.",
            style: font2(
                size: 16,
                color: Color(0xff4F575E),
                fontWeight: FontWeight.w300),
          ),
        ),
      ),
    );
  }

  _nextButtonConsumer() {
    return BlocConsumer<AuthenticationBloc, AuthenticationBlocState>(
        cubit: BlocProvider.of<AuthenticationBloc>(context),
        listenWhen: (previous, current) =>
            current is GetAvailableEmailsLoaded ||
            current is AuthenticationLoaded ||
            current is Error,
        listener: (context, state) async {
          if (state is GetAvailableEmailsLoaded) {
            performMockedAuthentication("cust-s@sensei.tech");
          } else if (state is AuthenticationLoaded) {
            saveSharedPreferences(state.authenticationResponse.accessToken,
                state.authenticationResponse.refreshToken);
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => OnboardingScreen(
                          onNext: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => NavigationScreen()));
                          },
                          onSkip: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => NavigationScreen()));
                          },
                        )),
                (Route<dynamic> route) => false);
          }
        },
        buildWhen: (previous, current) =>
            (current is AuthenticationInitial) ||
            (current is GetAvailableEmailsLoading) ||
            (current is AuthenticationLoading) ||
            (current is Error),
        builder: (context, state) {
          if (state is AuthenticationInitial) {
            return _buildNextButton();
          } else if (state is GetAvailableEmailsLoading ||
              state is AuthenticationLoading) {
            return Center(
              child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.black)),
            );
          } else if (state is Error) {
            return _buildNextButton();
          } else {
            return _buildNextButton();
          }
        });
  }

  _buildNextButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 48),
      child: RaisedButton(
        onPressed: () {
          // get available emails to mock
          BlocProvider.of<AuthenticationBloc>(context)
              .add(GetAvailableEmails());
        },
        child: Text("NEXT"),
      ),
    );
  }

  performMockedAuthentication(String username) {
    AuthenticationRequest authenticationRequest = AuthenticationRequest(
        username: username, password: "test", domainName: "pickandgo");

    BlocProvider.of<AuthenticationBloc>(context)
        .add(PerformAuthentication(authentication: authenticationRequest));
  }

  saveSharedPreferences(String token, String refreshToken) async {
    await NetworkDefaults.setToken(token);
    await NetworkDefaults.setRefreshToken(refreshToken);
  }
}
