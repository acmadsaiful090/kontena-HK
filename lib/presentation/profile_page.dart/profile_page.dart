import 'package:flutter/material.dart';
import 'package:kontena_hk/app_state.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final appState = Provider.of<AppState>(context, listen: false);
  String username = appState.dataUser?['employee_name'] ?? 'John Doe';
  String phone = appState.dataUser?['cell_number'] ?? '01234567890';

  setState(() {
    this.username = username;
    this.phone = phone;
  });
}


  void logout() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    print("User logged out");
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
                  color: Colors.blueGrey[900],
                ),
              ),
              SizedBox(height: 8),
              Text(
                phone,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.blueGrey[700],
                ),
              ),
              SizedBox(height: 24),
              LayoutBuilder(
                builder: (context, constraints) {
                  double containerWidth = constraints.maxWidth;

                  return Column(
                    children: [
                      Container(
                        width: containerWidth,
                        padding: const EdgeInsets.all(24.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/image/logo-kontena.png',
                              height: 45,
                            ),
                            SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Kontena - House Keeping',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueGrey[800],
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'V $appVersion',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.blueGrey[600],
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                      SizedBox(
                        width: containerWidth,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            logout();
                          },
                          child: Text(
                            'Log Out',
                            style: TextStyle(
                              fontFamily: 'OpenSans',
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
