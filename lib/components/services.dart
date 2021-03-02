import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Service {
  String title;
  IconData icon;

  Service(this.title, this.icon);
}

List<Service> services = [
  Service('Hotel', Icons.hotel),
  Service('Restaurant', Icons.restaurant),
  Service('Air Ticket', Icons.airplanemode_active),
  Service('Bus Ticket', Icons.bus_alert),
  Service('Helicopter', Icons.car_rental),
];
