import 'package:flutter/material.dart';

class Formatter {
  static String timeFormatter({
    TimeOfDay? time,
    DateTime? dateTime,
    bool showDate = false,
  }) {
    String rtn = "";

    if (time == null && dateTime != null) {
      time = TimeOfDay.fromDateTime(dateTime);
    }

    if (time == null) {
      return "null";
    }

    if (showDate && dateTime != null) {
      final now = DateTime.now();
      final yesterday = DateTime(now.year, now.month, now.day - 1);

      final dateOnly = DateTime(dateTime.year, dateTime.month, dateTime.day);

      if (dateOnly == yesterday) {
        rtn += "Yesterday at ";
      } else {
        rtn += "${dateTime.day} ${monthName(dateTime.month)} at ";
      }
    }

    rtn += time.hourOfPeriod.toString();
    rtn += ":";
    rtn += time.minute.toString().padLeft(2, "0");
    rtn += " ";
    rtn += time.period == DayPeriod.am ? "AM" : "PM";

    return rtn;
  }

  static String monthName(int month) {
    switch (month) {
      case 1:
        return "January";
      case 2:
        return "February";
      case 3:
        return "March";
      case 4:
        return "April";
      case 5:
        return "May";
      case 6:
        return "June";
      case 7:
        return "July";
      case 8:
        return "August";
      case 9:
        return "September";
      case 10:
        return "October";
      case 11:
        return "November";
      case 12:
        return "December";
    }

    return "Invalid Month";
  }

  static String countdown(Duration duration) {
    String rtn = "";

    rtn += duration.inMinutes.toString();
    rtn += ":";
    rtn += (duration.inSeconds - (duration.inMinutes * 60)).toString().padLeft(
      2,
      "0",
    );

    return rtn;
  }

  static String dateFormatter(DateTime date) {
    String rtn = "";

    rtn += date.year.toString();
    rtn += "-";

    rtn += date.month.toString();
    rtn += "-";

    rtn += date.day.toString();

    return rtn;
  }

  static String durationFormatter(
    Duration duration, {
    bool showSeconds = false,
  }) {
    String rtn = "";

    if (duration.inDays != 0) {
      rtn += duration.inDays.toString();
      rtn += "d ";
      duration -= Duration(days: duration.inDays);
    }

    if (!rtn.contains("d")) {
      if (duration.inHours != 0) {
        rtn += duration.inHours.toString();
        rtn += "h ";
        duration -= Duration(hours: duration.inHours);
      }

      if (!rtn.contains("h")) {
        if (duration.inMinutes >= 0) {
          rtn += duration.inMinutes.toString();
          rtn += "m";
          duration -= Duration(hours: duration.inMinutes);
        }
      }
    }

    if (showSeconds) {
      rtn += " ";
      rtn += duration.inSeconds.toString();
      rtn += "s";
    }

    if(rtn == "0m"){
      return "Just now";
    }

    return rtn;
  }

  static String toPascelCase(String text) {
    if (text.isEmpty) return text;

    return text
        .split(' ')
        .map((word) {
          if (word.isEmpty) return word;
          return word[0].toUpperCase() + word.substring(1);
        })
        .join(' ');
  }

  static String numberFormatter(dynamic value) {
    num? number;

    if (value is num) {
      number = value;
    } else if (value is String) {
      number = num.tryParse(value.trim());
    } else {
      number = num.tryParse(value.toString());
    }

    if (number == null) return "0";

    final rounded = (number * 100).round() / 100;
    String result = rounded.toStringAsFixed(2);

    if (result.endsWith("00")) {
      return result.substring(0, result.length - 3);
    }
    if (result.endsWith("0")) {
      return result.substring(0, result.length - 1);
    }

    return result;
  }
}
