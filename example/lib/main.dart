import 'package:extended_forms/extended_validation.dart';
import 'package:flutter/material.dart';
import 'package:extended_forms/extended_forms.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: Home());
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Extended Forms'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: Column(
              children: [
                ExtendedTextFormField(
                  // A convinience field to easily add a fixed label above.
                  labelTop: const Text('Username'),
                  // Specify a progress indicator that shows during async validation.
                  suffixActionsProgressIndicator:
                      const LinearProgressIndicator(),
                  // Specify an icon for the "submit" suffix action button.
                  suffixActionSubmitIcon: const Icon(Icons.check),
                  // Specify an icon for the "clear" suffix action button.
                  suffixActionClearIcon: const Icon(Icons.clear),
                  // Whether to clear the field on submit (doesn't work for onFieldSubmitted).
                  suffixActionClearOnSubmit: false,
                  // Whether to validate the value before submitting - Evaluates `ExtendedValidator`'s.
                  validateBeforeSubmitting: true,
                  // The function to call when submit is tapped.
                  suffixActionSubmitOnTap: print,
                  // A `List` of `ExtendedValidator` to validate against.
                  validators: validatorsUsername,
                  // Specify a global debounce time for the specified `ExtendedValidator`'s.
                  validatorDebounceDuration: validatorDebounceDuration,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

const validatorDebounceDuration = Duration(seconds: 2);

final validatorsUsername = [
  ExtendedValidator(
      validator: (String value) => value.length <= 4,
      message: 'Must be longer than 4 characters.',
      isAsync: false),
  ExtendedValidator(
      validator: (String value) => value.isEmpty,
      message: 'Cannot be empty.',
      isAsync: false)
];
