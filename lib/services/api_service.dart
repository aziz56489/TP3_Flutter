import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/reservation.dart';
import '../config/api_config.dart';
import '../models/destination.dart';
class ApiService{
  static Uri _url(String chemin) => Uri.parse('${ApiConfig.baseUrl}$chemin');
  static Future<List<Destination>> getDestinations() async{
    final reponse = await http
        .get(_url('/destinations'))
        .timeout(ApiConfig.timeout);
    if(reponse.statusCode != 200){
      throw Exception('Erreur lors de la récupération des destinations ${reponse.statusCode}');
    }
    final List<dynamic> liste = jsonDecode(utf8.decode(reponse.bodyBytes));

    return liste.map((json) => Destination.fromJson(json)).toList();
  }
  static Future<List<Reservation>> getReservations() async{
    final reponse = await http
        .get(_url('/reservations?_embed=destination'))
        .timeout(ApiConfig.timeout);
    if(reponse.statusCode != 200){
      throw Exception('Erreur lors de la récupération des reservations ${reponse.statusCode}');
    }
    final List<dynamic> liste = jsonDecode(utf8.decode(reponse.bodyBytes));

    return liste.map((json) => Reservation.fromJson(json)).toList();
  }
  static Future<String> creerReservation(Reservation reservation) async{
    final reponse = await http
            .post(
              _url('/reservations'),
              headers: {'Content-Type' : 'application/json'},
              body : jsonEncode(reservation.toJson())
            );
    if(reponse.statusCode != 201){
      throw Exception("Erreur de l envoi de la requete");
    }
    final Map<String,dynamic> creee = jsonDecode(utf8.decode(reponse.bodyBytes));
    return creee['id'].toString();
  }
}