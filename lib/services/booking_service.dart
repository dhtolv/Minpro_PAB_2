import 'package:supabase_flutter/supabase_flutter.dart';
import '../models.dart';

class BookingService {
  final supabase = Supabase.instance.client;

  Future<List<Booking>> getBookings() async {
    final data = await supabase
        .from('bookings')
        .select()
        .order('id', ascending: false);

    return (data as List).map((e) => Booking.fromMap(e)).toList();
  }

  Future<void> addBooking(Booking booking) async {
    await supabase.from('bookings').insert(booking.toMap());
  }

  Future<void> updateBooking(Booking booking) async {
    await supabase
        .from('bookings')
        .update(booking.toMap())
        .eq('id', booking.id!);
  }

  Future<void> deleteBooking(int id) async {
    await supabase.from('bookings').delete().eq('id', id);
  }
}
