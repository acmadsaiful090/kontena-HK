import 'package:flutter/material.dart';
import 'package:kontena_hk/app_state.dart';
import 'package:kontena_hk/routes/app_routes.dart';
import 'package:kontena_hk/utils/custom_button_style.dart';
import 'package:kontena_hk/widget/alert.dart';
import 'package:kontena_hk/widget/custom_outlined_button.dart';
import 'package:kontena_hk/utils/theme.helper.dart';
import 'package:kontena_hk/api/auth.dart' as auth;
import 'package:kontena_hk/api/user.dart' as user;
import 'package:kontena_hk/api/Employee_api.dart' as employee;
import 'package:kontena_hk/api/room_status.dart' as room_status;
import 'package:kontena_hk/api/company_api.dart' as company;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final unfocusNode = FocusNode();

  dynamic dataUser;
  dynamic dataEmployee;

  bool _isPasswordVisible = false;
  bool isLoading = false;

  String _errorMessage = '';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => setState(
        () {
          _phoneController.text = '';
          _passwordController.text = '';
        },
      ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final username = _phoneController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Username and password cannot be empty';
      });
      return;
    }

    setState(() {
      isLoading = true;
      _errorMessage = '';
    });

    final loginRequest =
        auth.LoginRequest(username: username, password: password);

    try {
      final response = await auth.login(loginRequest);
      if (response['message'] == 'Logged In') {
        final user.UserDetailRequest requestUser = user.UserDetailRequest(
          cookie: AppState().cookieData,
          id: username,
        );
        final callUser = await user.requestuser(requestQuery: requestUser);
        final employee.EmployeeDetailRequest requestEmployee =
            employee.EmployeeDetailRequest(
          cookie: AppState().cookieData,
          fields: '["name"]',
          filters: '[["user_id","=","$username"]]',
        );
        final callEmployee =
            await employee.requestEmployee(requestQuery: requestEmployee);
        // await onCallRoomStatus();
        // await onCallCompany();
        if (callUser.containsKey('name') && callEmployee.isNotEmpty) {
          setState(() {
            dataUser = callUser;
            dataEmployee = callEmployee.length == 1 ? callEmployee[0] : null;
            AppState().dataUser = {
              'user': dataUser,
              'employee': dataEmployee,
            };
          });
          if (mounted) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              AppRoutes.home,
              (route) => false,
            );
          }
        } else {
          setState(() {
            isLoading = false;
            _errorMessage = 'User  data not found';
          });
          if (mounted) {
            alertError(context, 'User  data not found');
          }
        }
      } else {
        setState(() {
          _errorMessage = 'Invalid username or password';
          isLoading = false;
        });
        if (mounted) {
          isLoading = false;
          alertError(context, 'Invalid username or password');
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Invalid username or password';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  dynamic onCallCompany() async {
    try {
      final companyRequest = company.CompanyRequest(
        cookie: AppState().cookieData,
        fields: '["name"]',
        limit: 50,
      );

      // onCallRoomStatus() async {
      final response =
          await company.requestCompany(requestQuery: companyRequest);

      if (response.isNotEmpty) {
        setState(() {
          AppState().companylist = response;
        });
      }
    } catch (error) {
      if (mounted) {
        isLoading = false;
        alertError(context, error.toString());
      }
    }
  }

  dynamic onCallRoomStatus() async {
    final room_status.RoomStatus requestCall = room_status.RoomStatus(
      cookie: AppState().cookieData,
      fields: '["name","status_name"]',
    );
    try {
      final request = await room_status.request(requestQuery: requestCall);
      if (request.isNotEmpty) {
        setState(() {
          AppState().roomStatus = request;
        });
      }
    } catch (error) {
      print('error, ${error.toString()}');
      if (mounted) {
        isLoading = false;
        alertError(context, error.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(0.0, 80.0, 0.0, 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Image.asset(
                      'assets/image/kontena-hk.png',
                      height: 200,
                      width: 200,
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(32.0),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'OpenSans',
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(height: 4),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Masukkan Username dan Password anda',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              fontFamily: 'OpenSans',
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(height: 16),
                        TextField(
                          controller: _phoneController,
                          decoration: InputDecoration(
                            labelText: 'Enter email/username',
                            labelStyle: TextStyle(
                              fontFamily: 'OpenSans',
                              color: theme.colorScheme.onPrimaryContainer,
                            ),
                            errorText:
                                _errorMessage.isEmpty ? null : _errorMessage,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: theme.colorScheme.outline,
                              ),
                            ),
                          ),
                          // keyboardType: TextInputType.,
                        ),
                        SizedBox(height: 10),
                        TextField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Enter password',
                            labelStyle: TextStyle(
                              fontFamily: 'OpenSans',
                              color: theme.colorScheme.onPrimaryContainer,
                            ),
                            errorText:
                                _errorMessage.isEmpty ? null : _errorMessage,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: theme.colorScheme.outline,
                              ),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                          ),
                          obscureText: !_isPasswordVisible,
                        ),
                        SizedBox(height: 40),
                        if (isLoading)
                          Container(
                            width: double.infinity,
                            height: 60.0,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  8.0, 0.0, 8.0, 0.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                    child: SizedBox(
                                      width: 23,
                                      height: 23,
                                      child: const CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            10.0, 0.0, 8.0, 0.0),
                                    child: Text(
                                      'Loading...',
                                      style: TextStyle(
                                          color: theme
                                              .colorScheme.primaryContainer),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        if (isLoading == false)
                          CustomOutlinedButton(
                            height: 60.0,
                            text: "LOG IN",
                            isDisabled: false,
                            buttonTextStyle: TextStyle(
                              color: theme.colorScheme.primaryContainer,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                            ),
                            buttonStyle: CustomButtonStyles.primary,
                            onPressed: _handleLogin,
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        8.0, 80.0, 8.0, 0.0),
                    child: Text(
                      'HK - Version ${AppState().version} ${(AppState().domain.contains('erp2')) ? ' - Testing' : ''}',
                      style: TextStyle(
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
