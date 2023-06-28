import 'dart:io';
import 'package:image_crop/image_crop.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ImageSelectionPage(),
    );
  }
}

class ImageSelectionPage extends StatefulWidget {
  const ImageSelectionPage({Key? key}) : super(key: key);

  @override
  State<ImageSelectionPage> createState() => _ImageSelectionPageState();
}

class _ImageSelectionPageState extends State<ImageSelectionPage> {
  File? _imageFile;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageCropPage(File(pickedFile.path)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Image Selection"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: _pickImage,
            child: Text('Select Image'),
          ),
        ],
      ),
    );
  }
}

class ImageCropPage extends StatefulWidget {
  final File imageFile;

  ImageCropPage(this.imageFile);

  @override
  State<ImageCropPage> createState() => _ImageCropPageState();
}

class _ImageCropPageState extends State<ImageCropPage> {
  final cropKey = GlobalKey<CropState>();
  File? _croppedImageFile;

  Future<void> _cropImage() async {
    final area = cropKey.currentState!.area!;
    final croppedFile = await ImageCrop.cropImage(
      file: widget.imageFile,
      area: area,
    );

    if (croppedFile != null) {
      setState(() {
        _croppedImageFile = croppedFile;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DisplayCroppedImagePage(_croppedImageFile!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Image Crop"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Crop(
              key: cropKey,
              image: FileImage(widget.imageFile),
              aspectRatio: 4.0 / 3.0,
            ),
          ),
          SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: _cropImage,
            child: Text('Crop Image'),
          ),
        ],
      ),
    );
  }
}

class DisplayCroppedImagePage extends StatelessWidget {
  final File croppedImageFile;

  DisplayCroppedImagePage(this.croppedImageFile);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cropped Image"),
        centerTitle: true,
      ),
      body: Center(
        child: Image.file(croppedImageFile),
      ),
    );
  }
}
