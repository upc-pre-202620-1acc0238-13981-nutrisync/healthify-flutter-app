import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../core/designsystem/theme/healthify_theme.dart';

// QR size from the invite screen design.
const _qrSize = 163.0;

/// Invitation QR code, generated on the phone from the token. It holds **only the token**: the patient's app reads it
/// and redeems it. `onSurface` modules on `surfaceContainerLowest`, with the quiet zone as padding.
class InvitationQrCode extends StatelessWidget {
  const InvitationQrCode({super.key, required this.content, required this.contentDescription, this.size = _qrSize});

  final String content;
  final String contentDescription;
  final double size;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;
    final dimens = context.dimens;
    return Semantics(
      image: true,
      label: contentDescription,
      excludeSemantics: true,
      child: ClipRRect(
        borderRadius: dimens.shapeMedium,
        child: QrImageView(
          data: content,
          size: size,
          padding: EdgeInsets.all(dimens.space8),
          backgroundColor: scheme.surfaceContainerLowest,
          errorCorrectionLevel: QrErrorCorrectLevel.M,
          eyeStyle: QrEyeStyle(eyeShape: QrEyeShape.square, color: scheme.onSurface),
          dataModuleStyle: QrDataModuleStyle(dataModuleShape: QrDataModuleShape.square, color: scheme.onSurface),
        ),
      ),
    );
  }
}
