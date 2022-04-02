<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

## Flutter extended forms
[Imgur](https://imgur.com/Ofo8LgW)

Extends functionality on standard flutter form Widgets:
Currently only adds extended functionality to `TextFormField`.

NOTE: This project is still very much work in progress.

## Global Features
- Advanced Async/sync validation.
- Firestore set/update/get integration (WIP).
- Debounce timers.
- Convinient static field titles.

## Firestore integration features (WIP)
- Use firestore value as initial value
- Automatically set value in firestore with Debounce timer.
- Trigger set value in firestore with on submit.

## TextFormField extended features
- Suffix actions - Show multiple suffix icons (with callbacks) based on validation status.
- Progress indicator - Optionally provide a custom progress widget to display when async validation is in progress.
- Submit suffix action - Optionally provide a custom 'submit' icon/widget when validation qualifies.
- Clear suffix action - Optionally provide a custom 'clear' icon/widget when validation does not qualify.

## Vaidation Features
- Easily create and use Async/sync validators.
- Debounce timers.
- Acccounts for both external and internal validation prior to form submission.
- Easily specify custom validator message; per validator.

## Getting started
Import the package.
```dart
import 'package:extended_forms/extended_forms.dart';
```

Create some validators with a debounce time.
```dart
const validatorDebounceDuration = Duration(seconds: 2);

final validatorsUsername = [
  ExtendedValidator(
      validator: (String value) => value.length <= 4,
      message: 'Must be longer than 4 characters.',
      isAsync: false),
  ExtendedValidator(
      validator: (String value) => value.isEmpty,
      message: 'Cannot be empty.',
      isAsync: false),
  ExtendedValidator(
      validator: asyncValidator,
      message: 'Cannot contiain whitespace.',
      // Specify if is an async valdiator.
      isAsync: true),
];

// Some long running task simulation.
Future<bool> asyncValidator(String value) async {
  await Future.delayed(const Duration(seconds:3));
  return value.contains(' ');
}
```

## Usage
```dart
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
```

## Additional information
Direct contributions, issues and suggestions => [here](https://github.com/p4-k4/flutter_extended_forms).

*Author:* Paurini Wiringi
