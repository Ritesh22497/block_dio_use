import 'dart:convert';

import 'package:http/http.dart'as http;

class ApiCall{

Future <dynamic>  getmtted() async {
try{
  var url="http/logi";
      Map<String, String>? header={};
      Object? body={"text":"tect",};
   var responce= await  http.post(Uri.parse(url,),headers:header,body: jsonEncode(body)  );
   if(responce.statusCode==200){
    var res=responce.body; 
    return res;                          
   }
}catch(e){

}


}

}
      