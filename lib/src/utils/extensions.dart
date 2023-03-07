import 'dart:math';
import 'dart:math' as math;

extension ExtendNumber on num {
  /// 100,000 becomes 100K
  /// works up to trillions
  String kformat() {
    num n = this;
    String u = '';
    String text = '';

    if (n < 1000) {
      text = n.toString();
    } else if (n >= pow(10, 3) && n < pow(10, 6)) {
      u = 'K';
      n = n / pow(10, 3);
      text = n.toStringAsFixed(1);
    } else if (n >= pow(10, 6) && n < pow(10, 9)) {
      u = 'M';
      n = n / pow(10, 6);
      text = n.toStringAsFixed(1);
    } else if (n >= pow(10, 9)) {
      u = 'B';
      n = n / pow(10, 9);
      text = n.toStringAsFixed(1);
    } else if (n >= pow(10, 12)) {
      u = 'T';
      n = n / pow(10, 12);
      text = n.toStringAsFixed(1);
    }
    return text + u;
  }
}

extension ExtendDouble on double {
  double radian() => this * math.pi / 180;
}

extension ExtendString on String {
  /// to use monthes short formate, so 'January' becomes 'Jan.'
  String shortMonth() => replaceAll('January', 'Jan.')
      .replaceAll('February', 'Feb.')
      .replaceAll('March', 'Mar.')
      .replaceAll('April', 'Apr.')
      .replaceAll('May', 'May.')
      .replaceAll('June', 'Jun.')
      .replaceAll('July', 'Jul.')
      .replaceAll('August', 'Aug.')
      .replaceAll('September', 'Sep.')
      .replaceAll('October', 'Oct.')
      .replaceAll('November', 'Nov.')
      .replaceAll('December', 'Dec.');
}
