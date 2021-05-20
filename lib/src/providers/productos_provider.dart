// https://flutter-varios-d9906.firebaseio.com/productos

import 'dart:convert';
import 'dart:io';

import 'package:formvalidation/src/model/producto_model.dart';
import 'package:formvalidation/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';

class ProductosProvider {

  final String _url = 'https://flutter-varios-d9906.firebaseio.com';
  final _prefs = new PreferenciasUsuario();

  Future<bool> crearProducto(ProductoModel producto) async {
    final url = '$_url/productos.json?auth=${_prefs.token}';

    final response = await http.post(url, body: productoModelToJson(producto));

    final decodedData = json.decode(response.body);


    return true;
  }

  Future<bool> editarProducto(ProductoModel producto) async {
    final url = '$_url/productos/${producto.id}.json?auth=${_prefs.token}';

    final response = await http.put(url, body: productoModelToJson(producto));

    final decodedData = json.decode(response.body);


    return true;
  }

  Future<List<ProductoModel>> cargarProductos() async{
    final url = '$_url/productos.json?auth=${_prefs.token}';
    final respuesta = await http.get(url);

    final Map<String, dynamic> decodedData = json.decode(respuesta.body);
    final List<ProductoModel>productos = new List();
    if(decodedData == null){
      return [];
    }

    if(decodedData['error'] != null) return [];


    decodedData.forEach((id, producto) {
      final productoTemp = ProductoModel.fromJson(producto);
      productoTemp.id = id;
      productos.add(productoTemp);
    });

    return productos;



  }

  Future<int> borrarProducto(String id) async{

    final url = '$_url/productos/$id.json?auth=${_prefs.token}';

    final resp = await http.delete(url);


    return 1;

  }

  Future<String> subirImagen(File imagen) async{

    final url = Uri.parse('https://api.cloudinary.com/v1_1/dtm5g2obd/image/upload?upload_preset=udhohmmb');

    final mimeType = mime(imagen.path).split('/');

    final imageUploadRequest = http.MultipartRequest(
      'POST',
      url
    );

    final file = await http.MultipartFile.fromPath(
      'file',
      imagen.path,
      contentType: MediaType(mimeType[0], mimeType[1])
    );

    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();

    final resp = await http.Response.fromStream(streamResponse);
    print('Estatus code : ${resp.statusCode}');
    if(resp.statusCode != 200 && resp.statusCode != 201){
      return null;
    }


    final respData = json.decode(resp.body);
    print(respData);
    return respData['secure_url'];






  }



}