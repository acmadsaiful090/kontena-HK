import 'package:flutter/material.dart';
import 'package:jc_hk/app_state.dart';
import 'package:jc_hk/routes/app_routes.dart'; // Pastikan file ini sesuai dengan struktur project Anda

class CompanyPage extends StatefulWidget {
  @override
  _CompanyPageState createState() => _CompanyPageState();
}

class _CompanyPageState extends State<CompanyPage> {
  String? selectedCompany;
  final List<Map<String, String>> companies = [
    {
      'name': 'Company A',
      'logo': 'https://via.placeholder.com/150',
    },
    {
      'name': 'Company B',
      'logo': 'https://via.placeholder.com/150',
    },
    {
      'name': 'Company C',
      'logo': 'https://via.placeholder.com/150',
    },
    {
      'name': 'Company D',
      'logo': 'https://via.placeholder.com/150',
    },
    {
      'name': 'Company E',
      'logo': 'https://via.placeholder.com/150',
    },
    {
      'name': 'Company F',
      'logo': 'https://via.placeholder.com/150',
    },
  ];

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
                      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                      child: Image.network(
                        company['logo']!,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      company['name']!,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
