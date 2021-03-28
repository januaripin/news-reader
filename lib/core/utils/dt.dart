import 'package:intl/date_symbol_data_file.dart';
import 'package:intl/intl.dart';

class DT {
  static String toHuman(int milliseconds, {String pattern = 'y/MM/d'}) {
    DateTime dt = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    DateFormat df = DateFormat(pattern);
    return df.format(dt);
  }

  static Future<String> toHumanLocale(int milliseconds,
      {String pattern = 'dd MMM y'}) async {
    return initializeDateFormatting('id', '')
        .then((_) => toHuman(milliseconds, pattern: pattern));
  }

  static String endsIn(int milliseconds) {
    int diff = DateTime.fromMillisecondsSinceEpoch(milliseconds)
        .difference(DateTime.now())
        .inSeconds;

    String diffText = "";
    if (diff > 31449600) {
      diffText = "dalam ${diff ~/ 31449600} tahun";
    } else if (diff > (86400 * 30)) {
      diffText = "dalam ${diff ~/ (86400 * 30)} bulan";
    } else if (diff > 604800) {
      diffText = "dalam ${diff ~/ 604800} minggu";
    } else if (diff > 86400) {
      diffText = "dalam ${diff ~/ 86400} hari";
    } else if (diff > 3600) {
      diffText = "dalam ${diff ~/ 3600} jam";
    } else if (diff > 60) {
      diffText = "dalam ${diff ~/ 60} menit";
    } else if (diff > 1) {
      diffText = "dalam $diff detik";
    } else if (diff == 0) {
      diffText = "sekarang";
    }

    if (isExpired(milliseconds)) {
      return "Sudah berakhir";
    } else {
      return "Berakhir $diffText";
    }
  }

  static bool isExpired(int milliseconds) {
    return DateTime.now()
        .isAfter(DateTime.fromMillisecondsSinceEpoch(milliseconds));
  }
}
