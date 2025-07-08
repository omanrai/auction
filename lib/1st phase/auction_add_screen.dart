import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'auction_list_screen.dart';

class AuctionAddScreen extends StatefulWidget {
  @override
  _AuctionAddScreenState createState() => _AuctionAddScreenState();
}

class _AuctionAddScreenState extends State<AuctionAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();
  List<File> _images = [];
  bool _isUploading = false;
  double _uploadProgress = 0;

  String? _name;
  String? _address;
  String? _mobile;
  double? _price;

  Future<void> _pickImages() async {
    final picked = await _picker.pickMultiImage();
    if (picked != null && picked.isNotEmpty) {
      setState(() {
        _isUploading = true;
        _uploadProgress = 0;
      });

      for (int i = 0; i < picked.length; i++) {
        await Future.delayed(
          Duration(milliseconds: 500),
        ); // Simulate upload delay
        setState(() {
          _uploadProgress = (i + 1) / picked.length;
          _images.add(File(picked[i].path));
        });
      }

      setState(() {
        _isUploading = false;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_images.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("At least one image is required.")),
        );
        return;
      }

      _formKey.currentState!.save();
      final newItem = AuctionItem(
        name: _name!,
        address: _address!,
        price: _price!,
        addedTime: DateTime.now(),
        images: _images.map((f) => f.path).toList(),
      );

      Navigator.pop(context, newItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Auction Item')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                onSaved: (v) => _name = v,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Address'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                onSaved: (v) => _address = v,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Mobile Number (Optional)',
                ),
                keyboardType: TextInputType.phone,
                onSaved: (v) => _mobile = v,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Item Price'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Required';
                  if (double.tryParse(v) == null) return 'Enter valid number';
                  return null;
                },
                onSaved: (v) => _price = double.parse(v!),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: Icon(Icons.upload),
                label: Text('Upload Images'),
                onPressed: _isUploading ? null : _pickImages,
              ),
              if (_isUploading)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: LinearProgressIndicator(value: _uploadProgress),
                ),
              // Wrap(
              //   spacing: 8,
              //   children: _images.map((img) {
              //     return Image.file(img, width: 80, height: 80, fit: BoxFit.cover);
              //   }).toList(),
              // ),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _images.asMap().entries.map((entry) {
                  int index = entry.key;
                  File img = entry.value;
                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          img,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _images.removeAt(index);
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),
              ElevatedButton(onPressed: _submitForm, child: Text('Submit')),
            ],
          ),
        ),
      ),
    );
  }
}
