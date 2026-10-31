import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/common/legal_links.dart';
import '../../../../core/designsystem/component/healthify_checkbox.dart';
import '../../../../core/designsystem/component/healthify_snackbar.dart';
import '../../../../core/designsystem/theme/healthify_theme.dart';
import '../../../../core/l10n/app_localizations.dart';

/// "I accept the terms and conditions" on sign-up. Only "terms and conditions" is a link: it opens
/// [LegalLinks.termsUrl] in the browser; the rest of the row toggles the box.
class TermsAcceptance extends StatefulWidget {
  const TermsAcceptance({
    super.key,
    required this.accepted,
    required this.onAcceptedChange,
    required this.isError,
    this.enabled = true,
  });

  final bool accepted;
  final ValueChanged<bool> onAcceptedChange;
  final bool isError;
  final bool enabled;

  @override
  State<TermsAcceptance> createState() => _TermsAcceptanceState();
}

class _TermsAcceptanceState extends State<TermsAcceptance> {
  late final TapGestureRecognizer _linkRecognizer = TapGestureRecognizer()..onTap = _openTerms;

  Future<void> _openTerms() async {
    bool opened;
    try {
      opened = await launchUrl(Uri.parse(LegalLinks.termsUrl), mode: LaunchMode.externalApplication);
    } on PlatformException {
      // launchUrl reports some failures by throwing, not by returning false.
      opened = false;
    }
    if (!opened && mounted) showHealthifySnackbar(context, message: AppLocalizations.of(context).linkOpenFailed);
  }

  @override
  void dispose() {
    _linkRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = context.colors;
    final linkText = l10n.signUpTermsLink;
    final template = l10n.signUpTermsAccept(linkText);
    final linkStart = template.indexOf(linkText);
    final link = TextSpan(
      text: linkText,
      recognizer: _linkRecognizer,
      style: TextStyle(
        color: scheme.primary,
        fontWeight: FontWeight.w600,
        decoration: TextDecoration.underline,
        decorationColor: scheme.primary,
      ),
    );
    final label = linkStart < 0
        ? TextSpan(text: template)
        : TextSpan(
            children: [
              TextSpan(text: template.substring(0, linkStart)),
              link,
              TextSpan(text: template.substring(linkStart + linkText.length)),
            ],
          );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HealthifyCheckboxRow(
          label: label,
          checked: widget.accepted,
          onChanged: widget.onAcceptedChange,
          enabled: widget.enabled,
          isError: widget.isError,
        ),
        if (widget.isError) ...[
          SizedBox(height: context.dimens.space4),
          Text(l10n.signUpErrorTerms, style: context.textStyles.bodySmall!.copyWith(color: scheme.error)),
        ],
      ],
    );
  }
}
