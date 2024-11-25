import 'package:flutter/material.dart';
import 'package:jc_hk/app_state.dart';
import 'package:jc_hk/routes/app_routes.dart';
import 'package:jc_hk/utils/custom_button_style.dart';
import 'package:jc_hk/widget/alert.dart';
import 'package:jc_hk/widget/custom_outlined_button.dart';
import 'package:jc_hk/utils/theme.helper.dart';
import 'package:jc_hk/api/auth.dart' as auth;
import 'package:jc_hk/api/user.dart' as user;
import 'package:jc_hk/api/Employee_api.dart' as employee;
import 'package:jc_hk/api/room_status.dart' as roomStatus;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  dynamic dataUser;
  dynamic dataEmployee;

  bool _isPasswordVisible = false;
  bool isLoading = false;

  String _errorMessage = '';

//   Future<void> _handleLogin() async {
//   final username = _phoneController.text.trim();
//   final password = _passwordController.text.trim();

//   if (username.isEmpty || password.isEmpty) {
//     setState(() {
//       _errorMessage = 'Username and password cannot be empty';
//     });
//     return;
//   }

//   setState(() {
//     isLoading = true;
//     _errorMessage = ''; 
//   });

//   final loginRequest = auth.LoginRequest(username: username, password: password);

//   try {
//     final response = await auth.login(loginRequest);
//     if (response['message'] == 'Logged In') {
//       final user.UserDetailRequest requestUser  = user.UserDetailRequest(
//         cookie: AppState().cookieData,
//         id: username,
//       );

//       final callUser  = await user.requestuser(requestQuery: requestUser );
//       final employee.EmployeeDetailRequest requestEmployee = employee.EmployeeDetailRequest(
//         cookie: AppState().cookieData,
//         fields: '["name"]',
//         filters: '[["user_id","=","$username"]]',
//       );

//       final callEmployee = await employee.requestEmployee(requestQuery: requestEmployee);

//       await onCallRoomStatus();

//       if (callUser .containsKey('name') && callEmployee.isNotEmpty) {
//         setState(() {
//           dataUser  = callUser ;
//           dataEmployee = callEmployee.length == 1 ? callEmployee[0] : null;
//           AppState().dataUser  = {
//             'user': dataUser ,
//             'employee': dataEmployee,
//           };
//         });
//         if (mounted) {
//           Navigator.of(context).pushNamedAndRemoveUntil(
//             AppRoutes.company,
//             (route) => false,
//           );
//         }
//       } else {
//         setState(() {
//           _errorMessage = 'User  data not found';
//         });
//         if (mounted) {
//           alertError(context, 'User  data not found');
//         }
//       }
//     } else {
//       setState(() {
//         _errorMessage = 'Invalid username or password';
//       });
//       if (mounted) {
//         alertError(context, 'Invalid username or password');
//       }
//     }
//   } catch (e) {
//     setState(() {
//       _errorMessage = 'An error occurred. Please try again.';
//     });
//     if (mounted) {
//       alertError(context, e.toString());
//     }
//   } finally {
//     setState(() {
//       isLoading = false;
//     });
//   }
// }

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

  final loginRequest = auth.LoginRequest(username: username, password: password);

  try {
    final response = await auth.login(loginRequest);
    if (response['message'] == 'Logged In') {
      // Skip user data retrieval entirely
      // You can also reset AppState or other relevant states here if needed

      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          AppRoutes.company,
          (route) => false,
        );
      }
    } else {
      setState(() {
        _errorMessage = 'Invalid username or password';
      });
      if (mounted) {
        alertError(context, 'Invalid username or password');
      }
    }
  } catch (e) {
    setState(() {
      _errorMessage = 'An error occurred. Please try again.';
    });
    if (mounted) {
      alertError(context, e.toString());
    }
  } finally {
    setState(() {
      isLoading = false;
    });
  }
}

  onCallRoomStatus() async {
    final roomStatus.RoomStatus requestCall = roomStatus.RoomStatus(
      cookie: AppState().cookieData,
      fields: '["name","status_name"]',
    );

    try {
      final request = await roomStatus.request(requestQuery: requestCall);

      if (request.isNotEmpty) {
        setState(() {
          AppState().roomStatus = request;
        });
      }
    } catch (error) {
      print('error, ${error.toString()}');

      if (mounted) {
        alertError(context, error.toString());
      }
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
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
                'assets/image/logo_housekeeping.png',
                height: 200,
                width: 200,
              ),
            ),
            // Align(
            //   alignment: Alignment.centerRight,
            //   child: Text(
            //     'House Keeping',
            //     style: TextStyle(
            //       fontSize: 10,
            //       fontWeight: FontWeight.normal,
            //       fontFamily: 'OpenSans',
            //     ),
            //     textAlign: TextAlign.left,
            //   ),
            // ),
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
                  // SizedBox(
                  //   width: double.infinity,
                  //   child: ElevatedButton(
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor: theme.colorScheme.primary,
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(4),
                  //       ),
                  //     ),
                  //     onPressed: _handleLogin,
                  //     child: Text(
                  //       'LOG IN',
                  //       style: TextStyle(
                  //         fontFamily: 'OpenSans',
                  //         color: Colors.white,
                  //         fontSize: 14,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
