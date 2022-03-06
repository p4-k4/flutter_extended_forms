library extended_forms;

import 'dart:async';
import 'package:flutter/services.dart';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'extended_validation.dart';
import 'utils/merge_input_decoration.dart';
import 'utils/debounce.dart';

class ExtendedTextFormField extends StatefulWidget {
  const ExtendedTextFormField({
    Key? key,
    this.validators,
    this.validatorDebounceDuration = const Duration(seconds: 0),
    this.validatorOutputHidden = false,
    this.validateBeforeSubmitting = true,
    this.suffixActionSubmitIcon,
    this.suffixActionSubmitOnTap,
    this.suffixActionClearIcon,
    this.suffixActions,
    this.suffixActionClearOnInvalid = true,
    this.suffixActionClearOnSubmit = true,
    this.suffixActionUnFocusOnSubmit = true,
    this.suffixActionsProgressIndicator,
    this.suffixActionSpacing = 18,
    this.suffixActionsContentPadding = const EdgeInsets.fromLTRB(6, 12, 0, 12),
    this.labelTop,
    this.initialValue,
    this.decoration,
    this.onChanged,
    this.onFieldSubmitted,
    this.controller,
    this.maxLines,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction,
    this.style,
    this.strutStyle,
    this.textDirection,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.autofocus = false,
    this.readOnly = false,
    this.toolbarOptions,
    this.showCursor,
    this.obscuringCharacter = '•',
    this.obscureText = false,
    this.autocorrect = true,
    this.smartDashesType,
    this.smartQuotesType,
    this.enableSuggestions = true,
    this.maxLengthEnforced = true,
    this.minLines,
    this.expands = false,
    this.maxLength,
    this.focusNode,
    this.onTap,
    this.onEditingComplete,
    this.onSaved,
    this.validator,
    this.inputFormatters,
    this.enabled,
    this.cursorWidth = 2.0,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorColor,
    this.keyboardAppearance,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.enableInteractiveSelection,
    this.selectionControls,
    this.buildCounter,
    this.scrollPhysics,
    this.autofillHints,
    this.autovalidateMode,
    this.scrollController,
    this.restorationId,
    this.enableIMEPersonalizedLearning = true,
  })  : assert(initialValue == null || controller == null),
        assert(textAlign != null),
        assert(autofocus != null),
        assert(readOnly != null),
        assert(obscuringCharacter != null && obscuringCharacter.length == 1,
            'Must be only 1 character in lenth.'),
        assert(obscureText != null),
        assert(autocorrect != null),
        assert(enableSuggestions != null),
        assert(maxLengthEnforced != null),
        assert(scrollPadding != null),
        assert(maxLines == null || maxLines > 0),
        assert(minLines == null || minLines > 0),
        assert(
          (maxLines == null) || (minLines == null) || (maxLines >= minLines),
          "minLines can't be greater than maxLines",
        ),
        assert(expands != null),
        assert(
          expands != null || (maxLines == null && minLines == null),
          'minLines and maxLines must be null when expands is true.',
        ),
        assert(obscureText != null || maxLines == 1,
            'Obscured fields cannot be multiline.'),
        assert(maxLength == null ||
            maxLength == TextField.noMaxLength ||
            maxLength > 0),
        assert(enableIMEPersonalizedLearning != null),
        super(key: key);

  /// Takes a `List` of `ExtendedValidator` to be used to validate against.
  final List<ExtendedValidator>? validators;

  /// The debounce duration before the validator runs.
  /// Defaults to 0 seconds.
  final Duration validatorDebounceDuration;

  /// Not yet implemented! Toggle whether the valdiator output is hidden or not.
  final bool validatorOutputHidden;

  /// When a `Function` is provided to [onFieldSubmitted], toggle whether or not the value should be validated.
  final bool validateBeforeSubmitting;
  final Widget? suffixActionSubmitIcon;
  final Function? suffixActionSubmitOnTap;
  final Widget? suffixActionClearIcon;
  final bool? suffixActionClearOnSubmit;
  final bool? suffixActionUnFocusOnSubmit;
  final List<SuffixAction>? suffixActions;
  final bool suffixActionClearOnInvalid;
  final Widget? suffixActionsProgressIndicator;
  final double suffixActionSpacing;
  final EdgeInsets? suffixActionsContentPadding;

  /// Acts as a static label that appears at the top of the field.
  final Widget? labelTop;
  final String? initialValue;
  final InputDecoration? decoration;
  final Function? onChanged;
  final Function? onFieldSubmitted;
  final TextEditingController? controller;
  final int? maxLines;
  final TextInputType? keyboardType;
  final TextCapitalization? textCapitalization;
  final TextInputAction? textInputAction;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextDirection? textDirection;
  final TextAlign? textAlign;
  final TextAlignVertical? textAlignVertical;
  final bool? autofocus;
  final bool? readOnly;
  final ToolbarOptions? toolbarOptions;
  final bool? showCursor;
  final String? obscuringCharacter;
  final bool? obscureText;
  final bool? autocorrect;
  final SmartDashesType? smartDashesType;
  final SmartQuotesType? smartQuotesType;
  final bool? enableSuggestions;
  final bool? maxLengthEnforced;
  final int? minLines;
  final bool? expands;
  final int? maxLength;
  final Function? onTap;
  final Function? onEditingComplete;
  final Function? onSaved;
  final Function(String)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final bool? enabled;
  final double? cursorWidth;
  final double? cursorHeight;
  final Radius? cursorRadius;
  final Color? cursorColor;
  final Brightness? keyboardAppearance;
  final EdgeInsets? scrollPadding;
  final bool? enableInteractiveSelection;
  final TextSelectionControls? selectionControls;
  final InputCounterWidgetBuilder? buildCounter;
  final ScrollPhysics? scrollPhysics;
  final bool? autofillHints;
  final AutovalidateMode? autovalidateMode;
  final ScrollController? scrollController;
  final String? restorationId;
  final bool? enableIMEPersonalizedLearning;
  final FocusNode? focusNode;

  @override
  State<ExtendedTextFormField> createState() => _ExtendedTextFormFieldState();
}

class _ExtendedTextFormFieldState extends State<ExtendedTextFormField> {
  late bool _isFocused;
  late TextEditingController _controller;
  ExtendedValidatorResult? _validatorResult;
  late ExtendedValidatorStatus _validatorStatus;
  CancelableOperation<ExtendedValidatorResult?>? _validatorTask;
  late String? _initialValue;
  bool _validatorInProgress = false;

  @override
  void initState() {
    super.initState();
    _isFocused = false;
    _validatorStatus = ExtendedValidatorStatus.stopped;

    if (widget.initialValue != null) {
      _initialValue = widget.initialValue;
    } else {
      _initialValue = '';
    }

    _controller =
        widget.controller ?? TextEditingController(text: _initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.labelTop ?? const SizedBox.shrink(),
        Focus(
          onFocusChange: (value) => setState(() => _isFocused = value),
          child: TextFormField(
            controller: _controller,
            decoration: _validatorInProgress == true
                ? inputDecorationProgress([])
                : inputDecoration(),
            onChanged: (value) async => onChanged(value),
            maxLines: widget.maxLines,
            onFieldSubmitted: (String value) => onFieldSubmitted(value),
            keyboardType: widget.keyboardType,
          ),
        ),
      ],
    );
  }

  onFieldSubmitted(String value) async {
    if (widget.onFieldSubmitted != null) {
      if (widget.validateBeforeSubmitting) {
        await validation(value);
        if (_validatorResult != null && _validatorResult!.result == false) {
          return;
        } else {
          widget.onFieldSubmitted!(value);
        }
      }
    }
  }

  Future<void> onChanged(String value) async {
    if (widget.onChanged != null) widget.onChanged!(value);

    // Execute validation
    Debounce.debounce('2', widget.validatorDebounceDuration,
        () async => await validation(value));
  }

  Future<void> validation(String value) async {
    if (widget.validators == null || (widget.validators?.isEmpty == false)) {
      setState(() => _validatorStatus = ExtendedValidatorStatus.stopped);
      setState(() => _validatorInProgress = false);

      return;
    } else {
      // Cancel previously called tasks
      if (_validatorStatus == ExtendedValidatorStatus.running) {
        if (_validatorTask != null) {
          _validatorTask!.cancel();
          setState(() => _validatorStatus = ExtendedValidatorStatus.stopped);
          setState(() => _validatorInProgress = false);
        }
      }

      if (_validatorStatus == ExtendedValidatorStatus.stopped) {
        setState(() => _validatorStatus = ExtendedValidatorStatus.running);

        // Create a new cancelable validator task if `validators` have been supplied.
        if (widget.validators?.isNotEmpty ?? false) {
          setState(() => _validatorInProgress = true);
          setState(() => _validatorTask =
              ExtendedValidation.createTask(value, widget.validators!));
          final validationResult = await _validatorTask!.value;
          setState(() => _validatorResult = validationResult);
          setState(() => _validatorInProgress = false);
          setState(() => _validatorStatus = ExtendedValidatorStatus.stopped);
        }
      }
    }
  }

  InputDecoration? inputDecoration() {
    var suffixActions = <SuffixAction>[];

    // Suffix actions
    List<SuffixAction>? showOnValid =
        widget.suffixActions?.where((element) => element.showOnValid).toList();
    List<SuffixAction>? showOnInvalid = widget.suffixActions
        ?.where((element) => element.showOnInvalid)
        .toList();

    // Whether to show suffix actions on invalid and valid.
    if (_validatorStatus == ExtendedValidatorStatus.stopped &&
        widget.suffixActions != null &&
        _isFocused) {
      if (_validatorResult?.result == null) {
        if (showOnValid != null && showOnValid.isNotEmpty) {
          for (var sa in showOnValid) {
            suffixActions.add(
              SuffixAction(
                  icon: sa.icon,
                  onTap: sa.onTap(_controller.value.text),
                  showOnValid: sa.showOnValid,
                  showOnInvalid: sa.showOnInvalid),
            );
          }
        }
        if (showOnInvalid != null && showOnInvalid.isNotEmpty) {
          for (var sa in showOnInvalid) {
            suffixActions.add(
              SuffixAction(
                  icon: sa.icon,
                  onTap: sa.onTap(_controller.value.text),
                  showOnValid: sa.showOnValid,
                  showOnInvalid: sa.showOnInvalid),
            );
          }
        }
        // suffixActions.addAll(
        //     showOnValid!.where((element) => element.showOnValid == true));
      }
      if (_validatorResult?.result == true &&
          showOnInvalid != null &&
          showOnInvalid.isNotEmpty) {
        suffixActions.addAll(
            showOnInvalid.where((element) => element.showOnInvalid == true));
      }
    }
    // Submit
    if (widget.suffixActionSubmitIcon != null &&
        widget.suffixActionSubmitOnTap != null &&
        _validatorResult?.result == null) {
      suffixActions.add(suffixActionSubmit());
    }

    // Clear
    if (widget.suffixActionClearIcon != null &&
        widget.suffixActionClearOnInvalid &&
        (_validatorResult?.result ?? false)) {
      suffixActions.add(suffixActionClear());
    }

    return MergeInputDecoration(
            input1: widget.decoration ??
                InputDecoration(errorText: _validatorResult?.message),
            input2: inputDecorationSuffixGenerator(suffixActions))
        .merge();
  }

  InputDecoration inputDecorationProgress(List<SuffixAction> suffixActions) {
    suffixActions.clear();
    final base = InputDecoration(errorText: _validatorResult?.message);
    return MergeInputDecoration(
            input1: MergeInputDecoration(
                    input1: base,
                    input2: widget.decoration ?? const InputDecoration())
                .merge(),
            input2: inputDecorationSuffixGenerator([suffixActionProgress()]))
        .merge();
  }

  SuffixAction suffixActionClear() => SuffixAction(
      icon: widget.suffixActionClearIcon!,
      onTap: () {
        _controller.clear();
        onChanged(_controller.value.text);
        // Skip validation, just set the result to null and status to stopped.
        setState(() => _validatorResult = ExtendedValidatorResult(
            result: null, value: _controller.value.text));
        setState(() => _validatorStatus = ExtendedValidatorStatus.stopped);
      });

  SuffixAction suffixActionSubmit() => SuffixAction(
      showOnValid: true,
      showOnInvalid: false,
      icon: widget.suffixActionSubmitIcon!,
      onTap: () async {
        final value = _controller.value.text;
        if (widget.suffixActionSubmitOnTap != null) {
          if (widget.suffixActionUnFocusOnSubmit ?? false) {
            FocusScope.of(context).unfocus();
          }
          if (widget.suffixActionClearOnSubmit ?? false) {
            _controller.clear();
          }
          await widget.suffixActionSubmitOnTap!(value);
        }
      });

  SuffixAction suffixActionProgress() {
    return SuffixAction(
        showOnInvalid: false,
        showOnValid: false,
        icon: SizedBox(
            height: 12,
            width: 12,
            child: widget.suffixActionsProgressIndicator ??
                const CircularProgressIndicator.adaptive(strokeWidth: 2)),
        onTap: () {
          if (_validatorTask != null) _validatorTask!.cancel();
          setState(() => _validatorStatus = ExtendedValidatorStatus.stopped);
        });
  }

  InputDecoration inputDecorationSuffixGenerator(List<SuffixAction>? children) {
    if (!_validatorInProgress) {
      return InputDecoration(
          isDense: true,
          errorText: _validatorResult?.message,
          contentPadding: widget.suffixActionsContentPadding,
          suffix: children == null || children.isEmpty
              ? null
              : children.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsetsDirectional.only(end: 12),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.end,
                          spacing: widget.suffixActionSpacing,
                          children: children,
                        ),
                      ),
                    )
                  : null);
    } else {
      return MergeInputDecoration(
              input1: InputDecoration(
                errorText: _validatorResult?.message,
              ),
              input2: InputDecoration(
                  contentPadding: widget.suffixActionsContentPadding,
                  suffix: children != null && children.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsetsDirectional.only(end: 12),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
                            child: Wrap(
                              alignment: WrapAlignment.end,
                              crossAxisAlignment: WrapCrossAlignment.end,
                              spacing: widget.suffixActionSpacing,
                              children: children,
                            ),
                          ),
                        )
                      : null))
          .merge();
    }
  }
}

class SuffixAction extends StatelessWidget {
  const SuffixAction({
    Key? key,
    required this.icon,
    required this.onTap,
    this.showOnValid = true,
    this.showOnInvalid = false,
  }) : super(key: key);
  final Widget icon;
  final Function onTap;
  final bool showOnValid;
  final bool showOnInvalid;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: () => onTap(), child: icon);
  }
}
