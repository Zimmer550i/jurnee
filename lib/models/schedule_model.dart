/* 
##############################################################
#                                                            #
#  WARNING: THIS MODEL IS UNUSUAL - HANDLE WITH CARE!       #
#  It has nullable fields, optional lists, and commented    #
#  fields in toJson. Make sure to review before use.        #
#                                                            #
##############################################################
*/

class Schedule {
  String day;
  String? id; // ID will not be used in toJson
  String? startTime;
  String? endTime;
  List<TimeSlot> timeSlots;
  bool availability; // New field added

  Schedule({
    required this.day,
    this.id,
    this.startTime,
    this.endTime,
    List<TimeSlot>? timeSlots, // nullable
    this.availability = true,
  }) : timeSlots = timeSlots ?? []; // initialize here

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      day: json['day'],
      id: json['_id'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      timeSlots: json['timeSlots'] != null
          ? (json['timeSlots'] as List)
                .map((e) => TimeSlot.fromJson(e))
                .toList()
          : [],
      availability: json['availability'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      // '_id': id, // Commented out: ID not returned
      if (startTime != null) 'startTime': startTime,
      if (endTime != null) 'endTime': endTime,
      'timeSlots': timeSlots.map((e) => e.toJson()).toList(),
      // 'availability': availability, // Commented out: Add later if needed
    };
  }

  Schedule copyWith({
    String? day,
    String? id,
    String? startTime,
    String? endTime,
    List<TimeSlot>? timeSlots,
    bool? availability,
  }) {
    return Schedule(
      day: day ?? this.day,
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      timeSlots:
          timeSlots ?? this.timeSlots.map((slot) => slot.copyWith()).toList(),
      availability: availability ?? this.availability,
    );
  }
}

class TimeSlot {
  String? id; // ID will not be used in toJson
  String? start;
  String? end;
  bool? available;

  TimeSlot({this.id, this.start, this.end, this.available});

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
      id: json['_id'],
      start: json['start'],
      end: json['end'],
      available: json['available'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // '_id': id, // Commented out: ID not returned
      if (start != null) 'start': start,
      if (end != null) 'end': end,
      if (available != null) 'available': available,
    };
  }

  TimeSlot copyWith({String? id, String? start, String? end, bool? available}) {
    return TimeSlot(
      id: id ?? this.id,
      start: start ?? this.start,
      end: end ?? this.end,
      available: available ?? this.available,
    );
  }
}
