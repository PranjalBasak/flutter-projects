import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';

const String baseUrl = 'https://labs.anontech.info/cse489/t3/api.php';

class BaseClient {
  Future <String> get(String api) async {
    var client = http.Client();
    try {
      var url = Uri.parse(baseUrl + api);
      debugPrint('🌐 BaseClient.get() - URL: $url');
      
      var response = await client.get(url);
      
      debugPrint('📥 BaseClient.get() - Response status: ${response.statusCode}');
      debugPrint('📄 BaseClient.get() - Response body: ${response.body}');
      debugPrint('📋 BaseClient.get() - Response headers: ${response.headers}');
      
      if(response.statusCode == 200){
        return response.body;
      } else{
        return "No Data Found";
        //throw exception and catch it in UI
      }
    } catch (e) {
      debugPrint('💥 BaseClient.get() - Exception: $e');
      return "Error: $e";
    } finally {
      client.close();
    }
  }


  Future <String> post(String api, Map<String, dynamic> data) async {
    var client = http.Client();
    try {
      var url = Uri.parse(baseUrl + api);
      var jsonBody = jsonEncode(data);
      debugPrint('🌐 BaseClient.post() - URL: $url');
      debugPrint('📤 BaseClient.post() - Request body: $jsonBody');
      debugPrint('📋 BaseClient.post() - Headers: Content-Type: application/json');
      
      var response = await client.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonBody,
      );
      
      debugPrint('📥 BaseClient.post() - Response status: ${response.statusCode}');
      debugPrint('📄 BaseClient.post() - Response body: ${response.body}');
      debugPrint('📋 BaseClient.post() - Response headers: ${response.headers}');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.body;
      } else {
        return "Error: ${response.statusCode} - ${response.reasonPhrase}";
      }
    } catch (e) {
      debugPrint('💥 BaseClient.post() - Exception: $e');
      return "Error: $e";
    } finally {
      client.close();
    }
  }

  Future <String> put(String api, Map<String, dynamic> data) async {
    var client = http.Client();
    try {
      var url = Uri.parse(baseUrl + api);
      var jsonBody = jsonEncode(data);
      debugPrint('🌐 BaseClient.put() - URL: $url');
      debugPrint('📤 BaseClient.put() - Request body: $jsonBody');
      debugPrint('📋 BaseClient.put() - Headers: Content-Type: application/json');
      
      var response = await client.put(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonBody,
      );
      
      debugPrint('📥 BaseClient.put() - Response status: ${response.statusCode}');
      debugPrint('📄 BaseClient.put() - Response body: ${response.body}');
      debugPrint('📋 BaseClient.put() - Response headers: ${response.headers}');
      
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return "Error: ${response.statusCode} - ${response.reasonPhrase}";
      }
    } catch (e) {
      debugPrint('💥 BaseClient.put() - Exception: $e');
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
