import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/destination.dart';
class ReservationScreen extends StatefulWidget{
  final Destination destination;
  final int voyageurs;
  const ReservationScreen({
    super.key,
    required this.destination,
    required this.voyageurs,
  });
  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}
class _ReservationScreenState extends State<ReservationScreen>{
  final _formKey = GlobalKey<FormState>();
  final _nomCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _telCtrl = TextEditingController();
  @override
  void dispose(){
    _nomCtrl.dispose();
    _emailCtrl.dispose();
    _telCtrl.dispose();
    super.dispose();
  }
  InputDecoration _deco(String label , IconData icone , {String? aide}){
    return InputDecoration( 
      labelText: label,
      helperText : aide,
      prefixIcon : Icon(icone),
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }
  String? _validerNom(String? v){
    if(v == null || v.trim().isEmpty)return 'Indiquez votre Nom';
    if(v.trim().length < 3)return 'Au moins 3 caractéres';
    return null;
  }
  String? _validerEmail(String? v){
    if(v == null || v.trim().isEmpty)return "l email est obligatoire";
    if(!RegExp(r'^[\w.+-]+@[\w-]+\.[\w.]+$').hasMatch(v.trim()))return "l email est invalide";
    return null;
  }
  String? _validerTel(String? v){
    if(v == null || v.trim().isEmpty)return "le numero est obligatoire";
    if(v.trim().length != 8)return "8 chiffres attendus";
    return null;
  }
  void _valider(){
    if(!_formKey.currentState!.validate())return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Formulaire valide")),
    );
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar : AppBar(title : const Text('Reserver')),
      body : Form(
        key : _formKey,
        child : SingleChildScrollView(
          padding : const EdgeInsets.all(20),
          child:Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(
                  widget.destination.image,
                  height: 64,
                  width: 64,
                ),
                Text(
                  widget.destination.nom,
                ),
                Text(
                  '${widget.voyageurs} voyageurs',
                ),
                Text(
                  widget.destination.duree,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller : _nomCtrl,
                  decoration : _deco('Nom complet', Icons.person_outline),
                  textCapitalization : TextCapitalization.words,
                  textInputAction : TextInputAction.next,
                  validator : _validerNom,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller : _emailCtrl,
                  decoration : _deco('Email', Icons.email_outlined),
                  keyboardType : TextInputType.emailAddress,
                  textInputAction : TextInputAction.next,
                  validator : _validerEmail,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller : _telCtrl,
                  decoration : _deco('Téléphone', Icons.phone , aide : '8 chiffres sans indicatif'),
                  keyboardType : TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(8)],
                  textInputAction : TextInputAction.done,
                  validator : _validerTel,
                ),
              ]
            )
        )
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.all(16),
          child : SizedBox(
            width: double.infinity,
            child : FilledButton.icon(
              onPressed : _valider,
              icon : Icon(Icons.check),
              label : Text("Confirmer"),
            ),
          ),
    ),
    );
  }
}