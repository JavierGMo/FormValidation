import 'package:flutter/material.dart';


import 'package:formvalidation/src/bloc/provider.dart';
import 'package:formvalidation/src/providers/productos_provider.dart';

import 'package:formvalidation/src/model/producto_model.dart';

class HomePage extends StatelessWidget {
  
  // final productosProvider = new ProductosProvider();

  @override
  Widget build(BuildContext context) {
    
    final productosBloc = Provider.productosBloc(context);
    
    productosBloc.cargarProductos();
    return Scaffold(
      appBar: AppBar(
        title: Text('Home page'),
      ),
      body: _crearListado(productosBloc),
      floatingActionButton: _crearBoton(context),
    );
  }

  Widget _crearListado(ProductosBloc productosBloc){
    return StreamBuilder(
      stream: productosBloc.produtosStream,
      builder: (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapShot){
        final productos = snapShot.data;

        if(snapShot.hasData){

          return ListView.builder(
            itemCount: productos.length,
            itemBuilder: (context, i){
              return _crearItem(context, productos[i], productosBloc);

            },
          );

        }else{
          return Center(child: CircularProgressIndicator(),);
        }
      },

    );
  }

  Widget _crearItem(BuildContext context, ProductoModel producto, ProductosBloc productosBloc){
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red
      ),
      child: Card(
        child: Column(
          children: <Widget>[
            (producto.fotoUrl == null)
            ?Image(image: AssetImage('assets/no-image.png'))
            :FadeInImage(placeholder: AssetImage('assets/jar-loading.gif'),
              image:NetworkImage(producto.fotoUrl),
              height: 300.0,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            ListTile(
              title: Text('${producto.titulo} - ${producto.valor}'),
              subtitle: Text(producto.id),
              onTap: (){
                Navigator.pushNamed(context, 'producto', arguments: producto);
              },
            ),
          ],
        ),
      ),
      onDismissed: (direccion){
        productosBloc.borrarProducto(producto.id);

      },
    );
  }


  Widget _crearBoton(BuildContext context){

    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: Colors.deepPurple,
      onPressed: (){
        Navigator.pushNamed(context, 'producto');
      }
    );
  }
}