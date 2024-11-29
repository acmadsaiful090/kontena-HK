import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kontena_hk/routes/app_routes.dart';

class LostFoundAddPage extends StatefulWidget {
  @override
  _LostFoundAddPageState createState() => _LostFoundAddPageState();
}

class _LostFoundAddPageState extends State<LostFoundAddPage> {
  final _foundController = TextEditingController();
  final _itemDescController = TextEditingController();
  String _errorMessage = '';
  File? _imageFile;
  bool _isLoading = false;
  String? _selectedItemType;

  // Fungsi untuk membuka kamera dan mengambil gambar
  Future<void> _takePicture() async {
    setState(() {
      _isLoading =
          true; // Set isLoading ke true saat proses pengambilan foto dimulai
    });
    final imageFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (imageFile == null) {
      setState(() {
        _isLoading =
            false; // Set isLoading kembali ke false jika tidak ada foto yang diambil
      });
      return;
    }
    setState(() {
      _imageFile = File(imageFile.path);
      _isLoading =
          false; // Set isLoading kembali ke false setelah foto terambil
    });
  }

  void _simulateLostFoundAdd() {
    setState(() {
      if (_foundController.text != '' &&
          _imageFile != null &&
          _selectedItemType != null) {
        _errorMessage = '';
        Navigator.of(context).pushNamedAndRemoveUntil(
              AppRoutes.company,
              (route) => false,
            );
      } else {
        _errorMessage = 'Input is Empty';
      }
    });
  }

  @override
  void dispose() {
    _foundController.dispose();
    _itemDescController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
       
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Align(
                alignment: Alignment.topRight,
                child: Image.asset(
                  'assets/image/logo-kontena.png', // Make sure to replace with the actual path to your logo
                  height: 80, // Set the desired height
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Form L&F',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'OpenSans',
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(32.0),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 4),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: _takePicture,
                          child: Icon(Icons.camera_alt, size: 80),
                        ),
                        SizedBox(width: 8),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Take A Photo',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              fontFamily: 'OpenSans',
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                    if (_isLoading)
                      CircularProgressIndicator() // Tampilkan loading indicator jika sedang loading
                    else if (_imageFile != null)
                      Column(
                        children: [
                          SizedBox(height: 16),
                          Image.file(
                            _imageFile!,
                            height: 200,
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _imageFile = null;
                              });
                            },
                            child: Text('Retake'),
                          ),
                        ],
                      ),
                    SizedBox(height: 32),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Location Found',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          fontFamily: 'OpenSans',
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: _foundController,
                      decoration: InputDecoration(
                        labelText: 'Found At',
                        labelStyle: TextStyle(fontFamily: 'OpenSans'),
                        errorText: _errorMessage.isEmpty ? null : _errorMessage,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Item Type',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          fontFamily: 'OpenSans',
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(height: 8),
                    InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Select Item Type',
                        labelStyle: TextStyle(fontFamily: 'OpenSans'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedItemType,
                          isExpanded: true,
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedItemType = newValue;
                            });
                          },
                          items: <String>[
                            'Item 1',
                            'Item 2',
                            'Item 3'
                          ] // Masukkan item type yang Anda inginkan di sini
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Enter Item Description',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          fontFamily: 'OpenSans',
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: _itemDescController,
                      maxLines: 4, // Set maxLines to 4
                      decoration: InputDecoration(
                        labelText: 'Item Description',
                        labelStyle: TextStyle(fontFamily: 'OpenSans'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF27ae60),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: _simulateLostFoundAdd,
                        child: Text('Save',
                            style: TextStyle(
                                fontFamily: 'OpenSans',
                                color: Colors.white,
                                fontSize: 14)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
