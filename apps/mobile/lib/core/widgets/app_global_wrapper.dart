import 'package:mobile/core/import/app_imports.dart';

class AppGlobalWrapper extends StatelessWidget {
  final Widget child;
  const AppGlobalWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ReactiveFormConfig(
      validationMessages: context.formValidationMessages,
      child: child,
    );
  }
}
