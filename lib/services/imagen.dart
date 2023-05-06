import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

Future<String> uploadImage() async {
  final cloudinaryUrl =
      Uri.parse('https://api.cloudinary.com/v1_1/da28duicw/image/upload');

  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.camera);

  if (pickedFile != null) {
    final file = File(pickedFile.path);
    final request = http.MultipartRequest('POST', cloudinaryUrl);
    final fileStream = http.ByteStream(file.openRead());
    final fileSize = await file.length();

    request.files.add(http.MultipartFile(
      'file',
      fileStream,
      fileSize,
      filename: file.path.split('/').last,
    ));

    request.fields.addAll({
      'upload_preset': 'productos_imagen',
    });

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      // handle success
      final json = jsonDecode(responseBody);
      final secureUrl = json['secure_url'];

      return (secureUrl);
    } else {
      // handle error

      throw Exception('Error al cargar la imagen');
    }
  } else {
    // handle error

    throw Exception('No se seleccionó ninguna imagen.');
  }
}
