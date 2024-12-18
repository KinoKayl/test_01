import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AvatarPicker extends StatefulWidget {
  final Function(String) onAvatarSelected;

  AvatarPicker({required this.onAvatarSelected});

  @override
  _AvatarPickerState createState() => _AvatarPickerState();
}

class _AvatarPickerState extends State<AvatarPicker> {
  File? _selectedAvatar;

  Future<void> _pickAvatar() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedAvatar = File(pickedFile.path);
      });
      widget.onAvatarSelected(pickedFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: _pickAvatar,
          child: CircleAvatar(
            radius: 50,
            backgroundImage:
            _selectedAvatar != null ? FileImage(_selectedAvatar!) : null,
            child: _selectedAvatar == null
                ? Icon(Icons.add_a_photo, size: 50)
                : null,
          ),
        ),
        SizedBox(height: 8),
        Text('Выберите аватар')
      ],
    );
  }
}
