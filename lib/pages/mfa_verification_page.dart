import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class MFAVerificationModal extends ConsumerWidget {
  const MFAVerificationModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    const padding = EdgeInsets.all(16);
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            color: colorScheme.primary,
            child: Padding(
              padding: padding,
              child: Text(
                'Please input your SMS code',
                style: theme.textTheme.bodyText2!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.surface,
                ),
              ),
            ),
          ),
          Padding(
            padding: padding.copyWith(bottom: 0),
            child: TextFormField(
              autofocus: true,
              decoration: const InputDecoration(
                label: Text('SMS code'),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              enableSuggestions: false,
              maxLength: 6,
            ),
          ),
          Padding(
            padding: padding,
            child: OutlinedButton(
              onPressed: () async {
                // TODO(tsuruoka): finalizeMFAEnrollment
                // await ref.read(gcloudApiClient).finalizeMFAEnrollment(
                //       sessionInfo: sessionInfo,
                //       code: code,
                //       phoneNumber: phoneNumber,
                //     );
              },
              child: const Text('Send'),
            ),
          ),
          const Gap(44),
        ],
      ),
    );
  }
}
