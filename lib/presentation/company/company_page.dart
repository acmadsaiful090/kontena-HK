import 'package:flutter/material.dart';
import 'package:jc_hk/app_state.dart';
import 'package:jc_hk/routes/app_routes.dart';
import 'package:jc_hk/api/company_api.dart'; 

class CompanyPage extends StatefulWidget {
  @override
  _CompanyPageState createState() => _CompanyPageState();
}

class _CompanyPageState extends State<CompanyPage> {
  String? selectedCompany;
  List<Map<String, dynamic>> companies = [];
  @override
  void initState() {
    super.initState();
    fetchCompanies();
  }
  Future<void> fetchCompanies() async {
  try {
    final companyRequest = CompanyRequest(
      cookie: AppState().cookieData,
      fields: '["company_name"]',
      limit: 50,
    );
    final response = await requestCompany(requestQuery: companyRequest);
    if (response.isNotEmpty) {
      setState(() {
        companies = response.map((company){
          return {
            'name': company['company_name'],
            'logo': company['logo'] ?? 'https://via.placeholder.com/150',
          };
        }).toList();
      });
      AppState().companylist = response;
      print(companies);
    } else {
      debugPrint('No companies found.');
    }
  } catch (e) {
    debugPrint('Error fetching companies: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Failed to fetch companies. Please try again.'),
      ),
    );
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
