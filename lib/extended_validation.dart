import 'dart:async';
import 'package:async/async.dart';

class ExtendedValidator {
  ExtendedValidator(
      {required this.validator, required this.message, required this.isAsync});

  /// The validator to call.
  final Function validator;

  /// The message to return if invalid.
  final String message;

  /// Whether or not the validator is asynchronous.
  final bool isAsync;
}

class ExtendedValidatorResult {
  ExtendedValidatorResult(
      {required this.result, required this.value, this.message});

  /// Returns a bool for the last validation result.
  /// `true` being that the validator qualified and `false` if not.
  /// Otherwise, if no validators were supplied, returns null.
  final bool? result;

  /// The invalid message tied to the validator.
  /// This will return null if no validators were supplied.
  final String? message;

  /// The value that was passed to the validator.
  final String value;
}

class ExtendedValidation {

  /// Creates a cancelable future.
  static createTask(String value, List<ExtendedValidator> validators) {
    return CancelableOperation.fromFuture(
        valdiator(value: value, validators: validators));
  }

  /// Will return null if the validators passed are empty or
  /// if the validators check out as valid.
  /// Otherwise, if a validator does not qualify, will return a `ExtendedValidatorResult`.
  static Future<ExtendedValidatorResult> valdiator({
    required String value,
    required List<ExtendedValidator>? validators,
  }) async {
    List<ExtendedValidatorResult> result = [];

    if (validators != null && validators.isNotEmpty) {
      // Append the async validator results.
      for (var v in validators.where((element) => element.isAsync)) {
        if (await v.validator(value)) {
          result.add(ExtendedValidatorResult(
              result: true, value: value, message: v.message));
        }
      }
      // Append the sync validator results.
      for (var v in validators.where((element) => !element.isAsync)) {
        if (v.validator(value)) {
          result.add(ExtendedValidatorResult(
              result: true, value: value, message: v.message));
        }
      }
    }
    // Return the last `ExtendedValidatorResult` if the reuslt was invalid.
    // Otherwise return an `ExtendedValidatorResult` with a null result.
    return result.isNotEmpty
        ? result.last
        : ExtendedValidatorResult(result: null, value: value);
  }
}

enum ExtendedValidatorStatus {
  stopped,
  running,
}
