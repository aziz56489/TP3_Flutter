import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tp3/models/reservation.dart';

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
  AutovalidateMode _autoValidation = AutovalidateMode.disabled;
  final _formKey = GlobalKey<FormState>();
  final _nomCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _telCtrl = TextEditingController();
  final _dateCtrl = TextEditingController();
  DateTime? _date;
  String _formule = 'Essentiel';
  bool _conditions = false;
  int get _prixParPersonne => _formule == 'Confort' ? (widget.destination.prix *1.3).round() : widget.destination.prix;
  int get _total => _prixParPersonne * widget.voyageurs;
  Future<void> _choisirDate() async{
    final demain = DateTime.now().add(const Duration(days: 1));
    final choisie = await showDatePicker(
      context : context,
      initialDate: _date ?? demain,
      firstDate: demain,
      lastDate : DateTime.now().add(const Duration(days: 365)),
      helpText : 'Date de depart',
    );
    if(choisie == null){
      return;
    }else{
      setState(() {
        _date = choisie;
        _dateCtrl.text = '${choisie.day.toString().padLeft(2,'0')}/${choisie.month.toString().padLeft(2,'0')}/${choisie.year}';
      });
    }
  }
  @override
  void dispose(){
    _nomCtrl.dispose();
    _emailCtrl.dispose();
    _telCtrl.dispose();
    _dateCtrl.dispose();
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
    if(!_formKey.currentState!.validate()){
      setState(()=>_autoValidation = AutovalidateMode.onUserInteraction);
      return;
    }
    final reservation = Reservation(
      id: null,
      destination: widget.destination,
      nom: _nomCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      telephone: _telCtrl.text.trim(),
      dateDepart: _date!,
      voyageurs: widget.voyageurs,
      formule: _formule,
    );
    Navigator.pop(context, reservation);
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
                const SizedBox(height: 16),
                TextFormField(
                  controller : _dateCtrl,
                  readOnly : true,
                  onTap: _choisirDate,
                  decoration : _deco('Date de depart' , Icons.calendar_month_outlined),
                  validator : (_) => _date == null ? 'choisissez une date' : null,
                ),
                const SizedBox(height: 16),
                SegmentedButton<String>(
                segments : const[
                  ButtonSegment(value: 'Essentiel', label : Text('Essentiel'),icon : Icon(Icons.backpack_outlined)),
                  ButtonSegment(value: 'Confort', label : Text('Confort + 30 %'),icon : Icon(Icons.hotel_outlined)),
                ],
                selected: {_formule},
                onSelectionChanged: (choix){
                  setState(() {
                    _formule = choix.first;
                  });
                },
              ),
              CheckboxListTile(
                value : _conditions,
                onChanged: (v)=> setState(() => _conditions = v ?? false),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                title : const Text("J accept les conditions d annulation"),
                subtitle: const Text("Annulation gratuite jusqu a 48 h avant"),
              )
              ]
            )
        )
        ),
        
        bottomNavigationBar: Padding(
          padding: EdgeInsets.all(16),
          child : Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '$_prixParPersonne DT × ${widget.voyageurs}',
              textAlign: TextAlign.right,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total'),
                Text(
                  '$_total DT',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: _conditions ? _valider : null,
              icon: const Icon(Icons.check),
              label: const Text('Confirmer'),
            ),
          ],
    ),
    
    ),
    );
  }
}
