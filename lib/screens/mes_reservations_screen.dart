import 'package:flutter/material.dart';
import 'package:tp3/models/reservation.dart';

import '../services/api_service.dart';

class MesReservationsScreen extends StatefulWidget {
  const MesReservationsScreen({super.key});

  @override
  State<MesReservationsScreen> createState() => _MesReservationsScreenState();
}

class ErreurReseau extends StatelessWidget {
  const ErreurReseau({
    super.key,
    required this.message,
    required this.onReessayer,
  });

  final String message;
  final VoidCallback onReessayer;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off, color: Theme.of(context).colorScheme.error, size: 60),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            const Text('Vérifiez que json-server est lancé', textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton.tonalIcon(
              onPressed: onReessayer,
              icon: const Icon(Icons.refresh),
              label: const Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }
}

class _MesReservationsScreenState extends State<MesReservationsScreen> {
  late Future<List<Reservation>> _reservations;

  @override
  void initState() {
    super.initState();
    _reservations = ApiService.getReservations();
  }

  Future<void> _recharger() async {
    final future = ApiService.getReservations();
    setState(() => _reservations = future);
    try {
      await future;
    } catch (_) {
      // L'erreur est affichée par le FutureBuilder.
    }
  }

  String _dateFormatee(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mes voyages')),
      body: FutureBuilder<List<Reservation>>(
        future: _reservations,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return ErreurReseau(
              message: 'Impossible de charger vos réservations.',
              onReessayer: _recharger,
            );
          }

          final reservations = snapshot.data ?? const <Reservation>[];
          if (reservations.isEmpty) {
            return RefreshIndicator(
              onRefresh: _recharger,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 180),
                  Icon(Icons.luggage_outlined, size: 56),
                  SizedBox(height: 16),
                  Center(child: Text('Aucune réservation pour le moment')),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _recharger,
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: reservations.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final reservation = reservations[index];
                final destination = reservation.destination;
                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        destination.image,
                        height: 170,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          height: 170,
                          color: Theme.of(context).colorScheme.surfaceContainerHighest,
                          alignment: Alignment.center,
                          child: const Icon(Icons.image_not_supported_outlined, size: 40),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(destination.nom, style: Theme.of(context).textTheme.titleLarge),
                            const SizedBox(height: 12),
                            _DetailReservation(
                              icon: Icons.calendar_month_outlined,
                              text: 'Départ le ${_dateFormatee(reservation.dateDepart)}',
                            ),
                            _DetailReservation(
                              icon: Icons.people_outline,
                              text: '${reservation.voyageurs} voyageurs',
                            ),
                            _DetailReservation(
                              icon: Icons.hotel_outlined,
                              text: 'Formule ${reservation.formule}',
                            ),
                            const Divider(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Total'),
                                Text(
                                  '${reservation.total} DT',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _DetailReservation extends StatelessWidget {
  const _DetailReservation({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 10),
            Text(text),
          ],
        ),
      );
}
