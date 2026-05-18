import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  Future<Map<String, String>?> getCurrentAddress() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 1. Verifica se o serviço de localização está ativado.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Serviço de localização está desativado.');
    }

    // 2. Verifica as permissões de localização.
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Permissão de localização negada.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Permissões de localização estão permanentemente negadas.');
    }

    // 3. Obtém a posição atual (Lat e Long)
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // 4. Converte as coordenadas em um endereço (Placemark)
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (placemarks.isNotEmpty) {
      Placemark place = placemarks.first;

      // 5. Retorna o mapeamento exato solicitado:
      return {
        'bairro': place.subLocality ?? '',       // Retorna o Bairro
        'cidade': place.locality ?? '',          // Retorna a Cidade
        'estado': place.administrativeArea ?? '' // Retorna o Estado (ex: São Paulo)
      };
    }
    
    return null;
  }
}
