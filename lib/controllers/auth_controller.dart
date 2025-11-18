import 'dart:convert';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jurnee/models/user.dart';
import 'package:jurnee/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  Rxn<User> user = Rxn();
  RxBool isLoading = RxBool(false);

  final api = ApiService();
  late SharedPreferences prefs;

  @override
  void onInit() async {
    super.onInit();
    prefs = await SharedPreferences.getInstance();
  }

  Future<String> login(String email, String password) async {
    isLoading(true);
    try {
      final response = await api.post("/auth/login", {
        "email": email,
        "password": password,
      });
      final body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final data = body['data'];

        user.value = User.fromJson(data['user']);
        api.setToken(data['accessToken']);

        return "success";
      } else {
        return body['message'] ?? "Unexpected error occured!";
      }
    } catch (e) {
      return e.toString();
    } finally {
      isLoading(false);
    }
  }

  Future<String> register(
    String email,
    String password,
    String name,
    String address,
    LatLng location,
  ) async {
    isLoading(true);
    try {
      final response = await api.post("/user/create-user", {
        "email": email,
        "password": password,
        "name": name,
        "address": address,
        "location": {
          "type": "Point",
          "coordinates": [location.longitude, location.latitude],
        },
      });
      final body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return "success";
      } else {
        return body['message'] ?? "Unexpected error occured!";
      }
    } catch (e) {
      return e.toString();
    } finally {
      isLoading(false);
    }
  }

  Future<String> resendOtp(String email) async {
    try {
      final response = await api.post("/auth/resend-otp", {"email": email});
      final body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return "success";
      } else {
        return body['message'] ?? "Unexpected error occured!";
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> verifyOtp(String email, String otp) async {
    isLoading(true);
    try {
      final response = await api.post("/auth/verify-email", {
        "email": email,
        "oneTimeCode": int.parse(otp),
      });
      final body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final data = body['data'];

        user.value = User.fromJson(data['user']);
        api.setToken(data['accessToken']);

        return "success";
      } else {
        return body['message'] ?? "Unexpected error occured!";
      }
    } catch (e) {
      return e.toString();
    } finally {
      isLoading(false);
    }
  }

  Future<String> forgetPassword(String email) async {
    isLoading(true);
    try {
      final response = await api.post("/auth/forgot-password", {
        "email": email,
      });
      final body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return "success";
      } else {
        return body['message'] ?? "Unexpected error occured!";
      }
    } catch (e) {
      return e.toString();
    } finally {
      isLoading(false);
    }
  }

  Future<String> resetPassword(String pass, String conPass) async {
    isLoading(true);
    try {
      final response = await api.post("/auth/reset-password", {
        "newPassword": pass,
        "confirmPassword": conPass,
      }, authReq: true);
      final body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return "success";
      } else {
        return body['message'] ?? "Unexpected error occured!";
      }
    } catch (e) {
      return e.toString();
    } finally {
      isLoading(false);
    }
  }

  void logout() {
    prefs.clear();
  }

  Future<bool> previouslyLoggedIn() async {
    final accessToken = prefs.getString("accessToken");
    final refreshToken = prefs.getString("refreshToken");
    if (accessToken != null && refreshToken != null) {
      return true;
    }

    return false;
  }
}
