import 'destination.dart';

class Reservation {
  final String? id;
  final Destination destination;
  final String nom;
  final String email;
  final String telephone;
  final DateTime dateDepart;
  final int voyageurs;
  final String formule;

  const Reservation({
    required this.id,
    required this.destination,
    required this.nom,
    required this.email,
    required this.telephone,
    required this.dateDepart,
    required this.voyageurs,
    required this.formule,
  });
  Map<String,dynamic> toJson(){
    return{
      'destinationId' : destination.id,
      'nom' : nom,
      'email' : email,
      'telephone' : telephone,
      'voyageurs' : voyageurs,
      'formule' : formule,
      'total' : total,
      'dateDepart' : dateDepart.toIso8601String()
    };
  }
  int get prixParPersonne {
    final normalized = formule.trim().toLowerCase();

    switch (normalized) {
      case 'confort':
        return (destination.prix * 1.3).round();
      case 'premium':
        return (destination.prix * 1.5).round();
      default:
        return destination.prix;
    }
  }

  int get total => prixParPersonne * voyageurs;
  factory Reservation.fromJson(Map<String,dynamic> json){
    return Reservation(
      id: json['id'].toString(),
      destination: Destination.fromJson(json['destination']), 
      nom: json['nom'] as String, 
      email: json['email'] as String, 
      telephone: json['telephone'] as String,
      dateDepart: DateTime.parse(json['dateDepart']), 
      voyageurs: json['voyageurs'] as int,
      formule: json['formule'] as String,
    );
  }
}
