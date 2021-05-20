import 'dart:async';

class Validators {
  

  final validarEmail = StreamTransformer<String, String>.fromHandlers(
    handleData: (String email, EventSink<String> sink){
      // String patron = r'^([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

      RegExp regExp = new RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
      
      if(regExp.hasMatch(email)){
        sink.add(email);
      }else{
        sink.addError('El email no es valido');
      }

      //  if(email.length != 0){
      //   sink.add(email);
      // }else{
      //   sink.addError('El email no es valido');
      // }


    }
  );


  final validarPassword = StreamTransformer<String, String>.fromHandlers(
    handleData: (password, sink){
      if(password.length >= 6){
        sink.add(password);
      }else{
        sink.addError('Mas de sesis caracteres por favor');
      }
    }
  );



}