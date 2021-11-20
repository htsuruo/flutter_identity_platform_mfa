import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class MFAVerificationModal extends ConsumerStatefulWidget {
  const MFAVerificationModal({Key? key}) : super(key: key);

  @override
  ConsumerState<MFAVerificationModal> createState() =>
      _MFAVerificationModalState();
}

class _MFAVerificationModalState extends ConsumerState<MFAVerificationModal> {
  TextEditingController textEditingController = TextEditingController();

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              controller: textEditingController,
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
              onPressed: () =>
                  Navigator.of(context).pop(textEditingController.text),
              child: const Text('Verify'),
            ),
          ),
          const Gap(44),
        ],
      ),
    );
  }
}
