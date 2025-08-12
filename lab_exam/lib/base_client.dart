import 'package:http/http.dart' as http;
import 'dart:convert';

const String baseUrl = 'https://labs.anontech.info/cse489/t3/api.php';

class BaseClient {
  Future <String> get(String api) async {
    var client = http.Client();
    try {
      var url = Uri.parse(baseUrl + api);
      var response = await client.get(url);
      if(response.statusCode == 200){
        return response.body;
      } else{
        return "No Data Found";
        //throw exception and catch it in UI
      }
    } finally {
      client.close();
    }
  }


  Future <String> post(String api, Map<String, dynamic> data) async {
    var client = http.Client();
    try {
      var url = Uri.parse(baseUrl + api);
      var response = await client.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.body;
      } else {
        return "Error: ${response.statusCode} - ${response.reasonPhrase}";
      }
    } catch (e) {
      return "Error: $e";
    } finally {
      client.close();
    }
  }

  Future <String> put(String api, Map<String, dynamic> data) async {
    var client = http.Client();
    try {
      var url = Uri.parse(baseUrl + api);
      var response = await client.put(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return "Error: ${response.statusCode} - ${response.reasonPhrase}";
      }
    } catch (e) {
      return "Error: $e";
    } finally {
      client.close();
    }
  }

  Future <String> delete(String api) async {
    var client = http.Client();
    try {
      var url = Uri.parse(baseUrl + api);
      var response = await client.delete(url);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return "Error: ${response.statusCode} - ${response.reasonPhrase}";
      }
    } catch (e) {
      return "Error: $e";
    } finally {
      client.close();
    }
  }

}
