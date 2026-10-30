import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Reference to one Figma icon (24×24, filled, black base fill that [HealthifyIcon] tints).
@immutable
class HealthifyIconData {
  const HealthifyIconData(this.name);

  /// File name under `assets/icons`, without extension.
  final String name;

  String get asset => 'assets/icons/$name.svg';
}

/// Figma icons (the icons frame of the Healthify M3 design system file). Painted with [HealthifyIcon]:
/// the color always comes from the theme.
abstract final class HealthifyIcons {
  static const add = HealthifyIconData('add');
  static const agenda = HealthifyIconData('agenda');
  static const ai = HealthifyIconData('ai');
  static const arrowBack = HealthifyIconData('arrow_back');
  static const bell = HealthifyIconData('bell');
  static const bowl = HealthifyIconData('bowl');
  static const calendar = HealthifyIconData('calendar');
  static const camera = HealthifyIconData('camera');
  static const check = HealthifyIconData('check');
  static const checkCircle = HealthifyIconData('check_circle');
  static const chevronLeft = HealthifyIconData('chevron_left');
  static const chevronRight = HealthifyIconData('chevron_right');
  static const clear = HealthifyIconData('clear');
  static const clock = HealthifyIconData('clock');
  static const close = HealthifyIconData('close');
  static const cutlery = HealthifyIconData('cutlery');
  static const delete = HealthifyIconData('delete');
  static const diary = HealthifyIconData('diary');
  static const download = HealthifyIconData('download');
  static const edit = HealthifyIconData('edit');
  static const error = HealthifyIconData('error');
  static const evaluation = HealthifyIconData('evaluation');
  static const folder = HealthifyIconData('folder');
  static const forward = HealthifyIconData('forward');
  static const heart = HealthifyIconData('heart');
  static const help = HealthifyIconData('help');
  static const history = HealthifyIconData('history');
  static const home = HealthifyIconData('home');
  static const inbox = HealthifyIconData('inbox');
  static const info = HealthifyIconData('info');
  static const language = HealthifyIconData('language');
  static const lock = HealthifyIconData('lock');
  static const logout = HealthifyIconData('logout');
  static const menu = HealthifyIconData('menu');
  static const next = HealthifyIconData('next');
  static const patients = HealthifyIconData('patients');
  static const person = HealthifyIconData('person');
  static const previous = HealthifyIconData('previous');
  static const progress = HealthifyIconData('progress');
  static const qr = HealthifyIconData('qr');
  static const record = HealthifyIconData('record');
  static const search = HealthifyIconData('search');
  static const settings = HealthifyIconData('settings');
  static const shield = HealthifyIconData('shield');
  static const sync = HealthifyIconData('sync');
  static const trend = HealthifyIconData('trend');
  static const unlock = HealthifyIconData('unlock');
  static const visibility = HealthifyIconData('visibility');
  static const visibilityOff = HealthifyIconData('visibility_off');
  static const warning = HealthifyIconData('warning');
  static const wifiOff = HealthifyIconData('wifi_off');

  /// Every icon with its asset name (design system catalog).
  static const all = <HealthifyIconData>[
    add,
    agenda,
    ai,
    arrowBack,
    bell,
    bowl,
    calendar,
    camera,
    check,
    checkCircle,
    chevronLeft,
    chevronRight,
    clear,
    clock,
    close,
    cutlery,
    delete,
    diary,
    download,
    edit,
    error,
    evaluation,
    folder,
    forward,
    heart,
    help,
    history,
    home,
    inbox,
    info,
    language,
    lock,
    logout,
    menu,
    next,
    patients,
    person,
    previous,
    progress,
    qr,
    record,
    search,
    settings,
    shield,
    sync,
    trend,
    unlock,
    visibility,
    visibilityOff,
    warning,
    wifiOff,
  ];
}

/// Tinted Figma icon. Defaults to the ambient [IconTheme] color and 24 dp.
class HealthifyIcon extends StatelessWidget {
  const HealthifyIcon(this.icon, {super.key, this.size, this.color, this.semanticLabel});

  final HealthifyIconData icon;
  final double? size;
  final Color? color;

  /// `null` = decorative icon, hidden from screen readers.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final iconTheme = IconTheme.of(context);
    final side = size ?? iconTheme.size ?? 24;
    final tint = color ?? iconTheme.color ?? Theme.of(context).colorScheme.onSurface;
    return SvgPicture.asset(
      icon.asset,
      width: side,
      height: side,
      colorFilter: ColorFilter.mode(tint, BlendMode.srcIn),
      semanticsLabel: semanticLabel,
      excludeFromSemantics: semanticLabel == null,
    );
  }
}
