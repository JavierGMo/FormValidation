import 'dart:io';

import 'package:flutter/material.dart';
import 'package:formvalidation/src/bloc/provider.dart';
import 'package:formvalidation/src/model/producto_model.dart';

import 'package:formvalidation/src/utils/utils.dart' as utils;
import 'package:image_picker/image_picker.dart';


class ProductoPage extends StatefulWidget {
  @override
  _ProductoPageState createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {
  
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  // final productoProvider = new ProductosProvider();

  ProductosBloc productosBloc;



  ProductoModel producto = new ProductoModel();
  bool _guardando = false;
  File photo;



  @override
  Widget build(BuildContext context) {

    final ProductoModel prodArg = ModalRoute.of(context).settings.arguments;
    productosBloc = Provider.productosBloc(context);

    if(prodArg!=null){
      producto = prodArg;
    }


    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Producto'),
        actions: [
          IconButton(
            icon: Icon(Icons.photo_size_select_actual),
            onPressed: _seleccionarFoto,
          ),
          IconButton(
            icon: Icon(Icons.camera),
            onPressed: _tomarfoto,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                _mostrarFoto(),
                _crearNombre(),
                _crearPrecio(),
                _crearDisponible(),
                _crearBoton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _crearNombre(){
    return TextFormField(
      initialValue: producto.titulo,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Producto',
      ),
      onSaved: (String value) => producto.titulo = value,
      validator: (value) => value.length<3?'Ingrese el nombre del producto':null,
    );
  }

  Widget _crearPrecio(){
    return TextFormField(
      initialValue: producto.valor.toString(),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: 'Precio',
      ),
      onSaved: (String value) => producto.valor = double.parse(value),
      validator: (value){

        if(utils.isNumeric(value)){
          return null;
        }else{
          return 'Solor números';
        }

      },
    );
  }

  Widget _crearDisponible(){
    return SwitchListTile(
      title: Text('Disponible'),
      value: producto.disponible,
      activeColor: Colors.deepPurple,
      onChanged: (value){
        setState(() {
          producto.disponible = value;
        });
      }
    );
  }

  Widget _crearBoton(){
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0)
      ),
      color: Colors.deepPurple,
      textColor: Colors.white,
      icon: Icon(Icons.save),
      label: Text('Guardar'),
      onPressed: (_guardando)?null:_submit,
    );
  }

  void _submit() async{
    if(!formKey.currentState.validate()) return;
    formKey.currentState.save();

    

    setState((){
      _guardando = true;
    });

    if(photo != null){
      producto.fotoUrl = await productosBloc.subirFoto(photo);
      print('si subo la imagen xd ${producto.fotoUrl}');
    }
    
    if(producto.id == null){
      productosBloc.agregarProducto(producto);  
    }else{
      productosBloc.editarProducto(producto);

    }

    // setState((){
    //   _guardando = false;
    // });

    mostrarSnackBar('Registro guardado');

    Navigator.pop(context);
  }

  void mostrarSnackBar(String mensaje){

    final snackBar = SnackBar(
      content: Text('Mensaje'),
      duration: Duration(milliseconds: 500),
    );

    scaffoldKey.currentState.showSnackBar(snackBar);

  }


  void _seleccionarFoto() async {
    _procesarImagen(ImageSource.gallery);
  }


  void _tomarfoto() async{
    _procesarImagen(ImageSource.camera);
  }
  

  Widget _mostrarFoto(){
    if(producto.fotoUrl != null){
      return FadeInImage(
        placeholder: AssetImage('assets/jar-loading.gif'),
        image: NetworkImage(producto.fotoUrl),
        height: 300.0,
        fit: BoxFit.cover,
      );
    }else{
      if( photo != null ){
        return Image.file(
          photo,
          fit: BoxFit.cover,
          height: 300.0,
        );
      }
      return Image.asset('assets/no-image.png');
    }


  }

  _procesarImagen(ImageSource source) async{
    final _picker = ImagePicker();
 
    final pickedFile = await _picker.getImage(
      source: source,
    );
    
    photo = File(pickedFile.path);
 
    if (photo != null) {
      producto.fotoUrl = null;
    }
    print('imagen ${photo.path}');
 
    setState(() {});
  }

}