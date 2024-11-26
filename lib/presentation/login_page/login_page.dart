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

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
    final username = _phoneController.text;
    final password = _passwordController.text;

    setState(() {
      isLoading = true;
    });

    final loginRequest =
        auth.LoginRequest(username: username, password: password);

    try {
      final response = await auth.login(loginRequest);
      if (response['message'] == 'Logged In') {
        final user.UserDetailRequest requestUser = user.UserDetailRequest(
          cookie: AppState().cookieData,
          id: _phoneController.text,
        );

        final callUser = await user.requestuser(requestQuery: requestUser);

        final employee.EmployeeDetailRequest requestEmployee =
            employee.EmployeeDetailRequest(
          cookie: AppState().cookieData,
          fields: '["name"]',
          filters: '[["user_id","=","${_phoneController.text}"]]',
        );

        final callEmployee =
            await employee.requestEmployee(requestQuery: requestEmployee);

        isLoading = false;

        await onCallRoomStatus();

        if ((callUser.containsKey('name')) && (callEmployee.isNotEmpty)) {
          setState(() {
            dataUser = callUser;
            if (callEmployee.isNotEmpty && callEmployee.length == 1) {
              dataEmployee = callEmployee[0];
            }
            AppState().dataUser = {
              'user': dataUser,
              'employee': dataEmployee,
            };
          });

          if (mounted) {
            // Navigator.pushReplacementNamed(context, '/home');
            Navigator.of(context).pushNamedAndRemoveUntil(
              AppRoutes.home,
              (route) => false,
            );
          }
        }
      } else {
        setState(() {
          _errorMessage = 'Invalid username or password';
          isLoading = false;
        });

        if (mounted) {
          alertError(context, 'Sepertinya akun atau passwordmu salah');
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Invalid username or password';
        isLoading = false;
      });
      if (mounted) {
        alertError(context, e.toString());
        isLoading = false;
      }
    }
  }

  onCallRoomStatus() async {
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
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
                      errorText: _errorMessage.isEmpty ? null : _errorMessage,
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
                      errorText: _errorMessage.isEmpty ? null : _errorMessage,
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
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  10.0, 0.0, 8.0, 0.0),
                              child: Text(
                                'Loading...',
                                style: TextStyle(
                                    color: theme.colorScheme.primaryContainer),
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
          ],
        ),
      ),
    );
  }
}
