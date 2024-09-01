class JsonResponse {
  int id;
  int busId;
  String name;
  String departure;
  String destination;
  String dateToday;
  String departureTime;
  String arrivalTime;
  String status;

  JsonResponse({
    required this.id,
    required this.busId,
    required this.name,
    required this.departure,
    required this.destination,
    required this.dateToday,
    required this.departureTime,
    required this.arrivalTime,
    required this.status,
  });
}

class JsonModel {
  static Map<String, dynamic> busTimeList = {};

  static void addBusTime(
    int id,
    String busNumber,
    String name,
    String departure,
    String destination,
    String dateToday,
    String departureTime,
    String arrivalTime,
  ) {
    busTimeList = {
      'id': id,
      'busNumber': busNumber,
      'name': name,
      'departureFrom': departure,
      'destination': destination,
      'date': dateToday,
      'departureTime': departureTime,
      'arrivalTime': arrivalTime,
    };
  }

  static Map<String, dynamic> getBusTimeList() {
    return busTimeList;
  }
}
