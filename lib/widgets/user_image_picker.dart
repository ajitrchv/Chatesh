import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
class UserImagePicker extends StatefulWidget {
  //const UserImagePicker({ Key? key }) : super(key: key);
  UserImagePicker(this.imagePickFn);
  final void Function(File pickedImage) imagePickFn;

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImage = null;
  final _picker = ImagePicker();
  void _pickImage()async{
    final pickedImageFile = await _picker
    .pickImage(source: ImageSource.camera, imageQuality: 50,
    maxHeight: 150,
    maxWidth: 150,
    );
    setState(() {
      _pickedImage = File(pickedImageFile!.path);
    });
    widget.imagePickFn(File(pickedImageFile!.path));
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          CircleAvatar(
                          radius: 50,
                          backgroundImage: 
                          _pickedImage != null 
                          ? 
                          FileImage(_pickedImage as File) 
                          : null,
                          
                        ),
                        TextButton.icon(
                          onPressed: _pickImage,
                          icon: const Icon(Icons.camera_enhance),
                          label: const Text(
                            'Click a pic',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
      
    
        ],
      ),);

      
  }
}