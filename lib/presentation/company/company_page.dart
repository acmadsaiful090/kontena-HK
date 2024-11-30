import 'package:flutter/material.dart';
import 'package:kontena_hk/app_state.dart';
import 'package:kontena_hk/routes/app_routes.dart';

class CompanyPage extends StatefulWidget {
  @override
  _CompanyPageState createState() => _CompanyPageState();
}

class _CompanyPageState extends State<CompanyPage> {
  String? selectedCompany;
  List<dynamic> companies = [];

  @override
  void initState() {
    super.initState();
    _listCompany();
  }

  void _listCompany() {
    print('list company, ${AppState().companylist}');
    if (AppState().companylist.isNotEmpty) {
      setState(() {
        companies = AppState().companylist;
      });
    }
  }

  void selectCompany(String companyName) {
    AppState().company = companyName;
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.home,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = (screenWidth / 200).floor();

    return Scaffold(
      appBar: AppBar(
        title: Text('Select Company'),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount > 3 ? crossAxisCount : 3,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 3 / 4,
        ),
        itemCount: companies.length,
        itemBuilder: (context, index) {
          final company = companies[index];
          String filename =
              company['name'].toString().toLowerCase().replaceAll(' ', '_');
          return GestureDetector(
            onTap: () => selectCompany(company['name']!),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(12)),
                      child: Image.asset(
                        'assets/images/$filename.png',
                        fit: BoxFit.contain,
                        width: 100.0,
                        height: 100.0,
                        errorBuilder: (BuildContext context, Object exception,
                            StackTrace? stackTrace) {
                          // Tampilkan gambar default jika file tidak ada
                          return Image.asset(
                            'assets/images/image_not_found.png',
                            fit: BoxFit.cover,
                            width: 104.0,
                            height: 104.0,
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      company['name']!,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
