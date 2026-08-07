// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, unused_element
enum Enum$TargetCategory {
  TOURIST_SPOT,
  CULTURAL_FACILITY,
  FESTIVAL_EVENT,
  TRAVEL_COURSE,
  LEISURE_SPORTS,
  LODGING,
  SHOPPING,
  RESTAURANT,
  TRANSPORT,
  $unknown;

  factory Enum$TargetCategory.fromJson(String value) =>
      fromJson$Enum$TargetCategory(value);

  String toJson() => toJson$Enum$TargetCategory(this);
}

String toJson$Enum$TargetCategory(Enum$TargetCategory e) {
  switch (e) {
    case Enum$TargetCategory.TOURIST_SPOT:
      return r'TOURIST_SPOT';
    case Enum$TargetCategory.CULTURAL_FACILITY:
      return r'CULTURAL_FACILITY';
    case Enum$TargetCategory.FESTIVAL_EVENT:
      return r'FESTIVAL_EVENT';
    case Enum$TargetCategory.TRAVEL_COURSE:
      return r'TRAVEL_COURSE';
    case Enum$TargetCategory.LEISURE_SPORTS:
      return r'LEISURE_SPORTS';
    case Enum$TargetCategory.LODGING:
      return r'LODGING';
    case Enum$TargetCategory.SHOPPING:
      return r'SHOPPING';
    case Enum$TargetCategory.RESTAURANT:
      return r'RESTAURANT';
    case Enum$TargetCategory.TRANSPORT:
      return r'TRANSPORT';
    case Enum$TargetCategory.$unknown:
      return r'$unknown';
  }
}

Enum$TargetCategory fromJson$Enum$TargetCategory(String value) {
  switch (value) {
    case r'TOURIST_SPOT':
      return Enum$TargetCategory.TOURIST_SPOT;
    case r'CULTURAL_FACILITY':
      return Enum$TargetCategory.CULTURAL_FACILITY;
    case r'FESTIVAL_EVENT':
      return Enum$TargetCategory.FESTIVAL_EVENT;
    case r'TRAVEL_COURSE':
      return Enum$TargetCategory.TRAVEL_COURSE;
    case r'LEISURE_SPORTS':
      return Enum$TargetCategory.LEISURE_SPORTS;
    case r'LODGING':
      return Enum$TargetCategory.LODGING;
    case r'SHOPPING':
      return Enum$TargetCategory.SHOPPING;
    case r'RESTAURANT':
      return Enum$TargetCategory.RESTAURANT;
    case r'TRANSPORT':
      return Enum$TargetCategory.TRANSPORT;
    default:
      return Enum$TargetCategory.$unknown;
  }
}
