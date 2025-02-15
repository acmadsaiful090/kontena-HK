import 'package:flutter/material.dart';
import 'package:kontena_hk/app_state.dart';
import 'package:kontena_hk/routes/app_routes.dart';
import 'package:kontena_hk/utils/custom_button_style.dart';
import 'package:kontena_hk/utils/theme.helper.dart';
import 'package:kontena_hk/widget/custom_outlined_button.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String username = "John Doe";
  String phone = "01234567890";
  String appVersion = "2.0.0";

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    String username = AppState().dataUser['user']['full_name'] ?? '';
    String phone = AppState().dataUser['user']['name'] ?? '';

    setState(() {
      this.username = username;
      this.phone = phone;
    });
  }

  onLogout() async {
    setState(() {
      AppState().dataUser = {};
      AppState().cookieData = '';
    });

    if (mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.login,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                  'https://www.gravatar.com/avatar/placeholder',
                ),
              ),
              SizedBox(height: 16),
              Text(
                username,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.secondary,
                ),
              ),
              // SizedBox(height: 2),
              Text(
                phone,
                style: TextStyle(
                  fontSize: 18,
                  color: theme.colorScheme.secondary,
                ),
              ),
              Text(
                AppState().company,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: theme.colorScheme.secondary,
                ),
              ),
              SizedBox(height: 60),
              CustomOutlinedButton(
                height: 60.0,
                text: "LOG OUT",
                isDisabled: false,
                buttonTextStyle: TextStyle(
                  color: theme.colorScheme.primaryContainer,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
                buttonStyle: CustomButtonStyles.error,
                onPressed: () {
                  // onTapPay(context);
                  onLogout();
                },
              ),
              const Spacer(),
              Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'JC House Keeping',
                    style: TextStyle(
                      fontSize: 16,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  Text(
                    ' - v${AppState().version}',
                    style: TextStyle(
                      fontSize: 16,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  Text(
                    ' ${(AppState().domain.contains('erp2')) ? ' - Testing' : ''}',
                    style: TextStyle(
                      fontSize: 16,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
              // LayoutBuilder(
              //   builder: (context, constraints) {
              //     double containerWidth = constraints.maxWidth;

              //     return Column(
              //       children: [
              //         Container(
              //           width: containerWidth,
              //           padding: const EdgeInsets.all(24.0),
              //           decoration: BoxDecoration(
              //             color: Colors.white,
              //             borderRadius: BorderRadius.circular(8),
              //             boxShadow: [
              //               BoxShadow(
              //                 color: Colors.black12,
              //                 blurRadius: 4,
              //                 spreadRadius: 2,
              //               ),
              //             ],
              //           ),
              //           child: Row(
              //             children: [
              //               Image.asset(
              //                 'assets/image/logo-kontena.png',
              //                 height: 45,
              //               ),
              //               SizedBox(width: 16),
              //               Column(
              //                 crossAxisAlignment: CrossAxisAlignment.start,
              //                 children: [
              //                   Text(
              //                     'Kontena - House Keeping',
              //                     style: TextStyle(
              //                       fontSize: 16,
              //                       fontWeight: FontWeight.bold,
              //                       color: Colors.blueGrey[800],
              //                     ),
              //                   ),
              //                   SizedBox(height: 4),
              //                   Text(
              //                     'V $appVersion',
              //                     style: TextStyle(
              //                       fontSize: 14,
              //                       color: Colors.blueGrey[600],
              //                     ),
              //                   ),
              //                 ],
              //               )
              //             ],
              //           ),
              //         ),
              //         SizedBox(
              //             height: MediaQuery.of(context).size.height * 0.3),
              //         SizedBox(
              //           width: containerWidth,
              //           child: ElevatedButton(
              //             style: ElevatedButton.styleFrom(
              //               backgroundColor: Colors.red,
              //               shape: RoundedRectangleBorder(
              //                 borderRadius: BorderRadius.circular(8),
              //               ),
              //             ),
              //             onPressed: () {
              //               logout();
              //             },
              //             child: Text(
              //               'Log Out',
              //               style: TextStyle(
              //                 fontFamily: 'OpenSans',
              //                 color: Colors.white,
              //                 fontSize: 14,
              //               ),
              //             ),
              //           ),
              //         ),
              //       ],
              //     );
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
