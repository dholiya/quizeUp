import 'dart:ui';

class ColorUtil {
  static int color_Primary = 0xdd3f4661;
  static int color_PrimaryLite = 0xff515875;
  static int btn_White = 0xFFFFFFFF;
  static int btn_Black = 0xFF000000;
  static int btn_Green = 0xFF32CD32;
  static int btn_Red = 0xFFDC143C;

  static Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }
}
