import 'package:flutter/material.dart';
import 'package:pin_lock/pin_lock.dart';

import 'main.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  RegisterFormState createState() => RegisterFormState();
}

// Create a corresponding State class.
// This class holds data related to the form.
class RegisterFormState extends State<RegisterForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    /// [Authenticator] needs to be registered as an app lifecycle observer
    WidgetsBinding.instance.addObserver(globalAuthenticator);
  }

  @override
  void dispose() {
    /// When disposing of the app, remove [Authenticator]'s subscription
    /// to lifecycle events
    WidgetsBinding.instance.removeObserver(globalAuthenticator);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        textTheme: const TextTheme(
          bodyText2: TextStyle(color: Colors.indigo),
        ),
      ),
      home: AuthenticatorWidget(
        /// Pass a reference to your [Authenticator] singleton
        authenticator: globalAuthenticator,

        /// Provide a string that users will see when biometric authentication is triggered
        userFacingBiometricAuthenticationMessage:
            'Your data is locked for privacy reasons. You need to unlock the app to access your data.',

        /// Provide a widget that represents a single pin input field
        inputNodeBuilder: (index, state) =>
            _InputField(state: state, index: index),

        /// Provide a widget that describes what you want your lock screen to look like,
        /// given the state of the lock screen ([LockScreenConfiguration])
        lockScreenBuilder: (configuration) => _LockScreen(configuration),

        /// Optional image to use to prevent from showing app content in the App Switcher.
        iosImageAsset: 'AppIcon',

        /// [child] should be the widget that you'd normally pass in as [home] of your [MaterialApp]
        child: _Register(),
      ),
    );
  }
}

class _Register extends StatelessWidget {
  _Register();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKey.currentState!.validate()) {
                    // If the form is valid, display a snackbar. In the real world,
                    // you'd often call a server or save the information in a database.
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Processing Data')),
                    );
                  }
                },
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LockScreen extends StatelessWidget {
  final LockScreenConfiguration configuration;

  const _LockScreen(this.configuration, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Fill in your pincode to unlock the app'),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// [LockScreenConfiguration] provides [pinInputWidget] drawn based on
              /// your instructions given to [AuthenticatorWidget]. You need to make sure that it is
              /// visible on your lock screen, while PinLock package takes care of its state
              configuration.pinInputWidget,

              /// You can check whether biometric authentication is available, and
              /// adjust your UI accordingly
              if (configuration.availableBiometricMethods.isNotEmpty)
                IconButton(
                  icon: Icon(Icons.fingerprint),
                  onPressed: configuration.onBiometricAuthenticationRequested,
                ),
            ],
          ),

          /// [LockScreenConfiguration] provides the [error] property, based on which you can display
          /// an error message to your user based on the specific [LocalAuthFailure]
          if (configuration.error != null)
            Text(
              configuration.error.toString(),
              style: const TextStyle(color: Colors.red),
            )
        ],
      ),
    );
  }
}

/// [AuthenticationSetupWidget] provides several builder properties with appropriate configuration.
/// If you do not want your app to support some of the features (e.g., changing pincode), simply
/// return a `Container` from its builder
class _SetupAuthWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),

      /// Put [AuthenticationSetupWidget] in your settings screen, or wherever you want
      /// your user expects to be able to change pin preferences
      body: AuthenticationSetupWidget(
        /// Pass in a reference to an [Authenticator] singleton
        authenticator: globalAuthenticator,

        /// Pin input widget can be the same as on the lock screen, or you can provide a custom UI
        /// that you want to use when setting it up
        pinInputBuilder: (index, state) =>
            _InputField(state: state, index: index),

        /// Overview refers to the first thing your user sees when getting to settings, before they have made
        /// any action, as well as after they made an action (such as changing pincode)
        /// See [OverviewConfiguration] for all the data available to you
        overviewBuilder: (config) => Center(
          /// [isLoading] indicates that user's preferences are still being fetched
          child: config.isLoading
              ? CircularProgressIndicator()
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          /// [isPinEnabled] is only `null` while [isLoading] is `true`
                          Text('Secure the app with a pin code'),
                          Switch(
                            value: config.isPinEnabled!,

                            /// [onTogglePin] callback is passed to a button (or a switch) that user
                            /// clicks to change their preferences
                            onChanged: (_) => config.onTogglePin(),
                          ),
                        ],
                      ),

                      /// In case of something going wrong, [OverviewConfiguration] provides an [error] property
                      if (config.error != null)
                        Text(config.error!.toString(),
                            style: TextStyle(color: Colors.red)),

                      /// If biometric authentication is available, provide an option to toggle it on or off
                      if (config.isBiometricAuthAvailable == true)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                                'Use fingerprint or face id to unlock the app'),
                            Switch(
                              value: config.isBiometricAuthEnabled!,
                              onChanged: (_) => config.onToggleBiometric(),
                            ),
                          ],
                        ),

                      /// If pin is enabled, you can give your user an option to change it
                      if (config.isPinEnabled == true)
                        OutlinedButton(
                          /// If you do not the pincode to be changable, simply never trigger [config.onPasswordChangeRequested]
                          /// If this callback is never triggered, the [changingWidget] builder is never needed, so it is
                          /// save to have it simply return a `Container` or a `SizedBox`
                          onPressed: config.onPasswordChangeRequested,
                          child: const Text('Change passcode'),
                        ),
                    ],
                  ),
                ),
        ),

        /// EnablingWidget is a builder that describes what [AuthenticationSetupWidget] looks like while pin code is being enabled
        /// See [EnablingPinConfiguration] for more detail
        enablingWidget: (configuration) => Center(
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Text('Select a pin code that you can remember'),

              /// Make sure [configuration.pinInputWidget] and [configuration.pinConfirmationWidget] are visible on the screen, since
              /// they are the main point of interaction between your user and the PinLock package
              configuration.pinInputWidget,
              const SizedBox(height: 24),
              const Text('Repeat the same pin once more'),

              /// [pinInputWidget] and [pinConfirmationWidget] can be presented side by side or one by one
              configuration.pinConfirmationWidget,

              /// [configuration.error] provides details if something goes wrong (e.g., pins don't match)
              if (configuration.error != null)
                Text(configuration.error.toString(),
                    style: TextStyle(color: Colors.red)),

              /// [configuration.canSubmitChange] can optionaly be used to hide or disable submit button
              /// It is also possible to listen for this property and programatically trigger [config.onSubmitChange],
              /// for example if you want to make a call to the library as soon as the fields are filled, without
              /// making the user press a button
              if (configuration.canSubmitChange)
                OutlinedButton(
                  onPressed: configuration.onSubmitChange,
                  child: const Text('Save'),
                )
            ],
          ),
        ),

        /// DisablingWidget is a builder that describes what [AuthenticationSetupWidget] looks like while pin code is being disabled
        /// See [DisablingPinConfiguration] for more detail
        disablingWidget: (configuration) => Center(
          child: Column(
            children: [
              const SizedBox(height: 40),
              Text('Enter your pin to disable pin authentication'),

              /// Make sure [configuration.pinInputWidget] is visible on the screen
              configuration.pinInputWidget,

              /// Display errors if there is any
              if (configuration.error != null)
                Text(
                  configuration.error.toString(),
                  style: TextStyle(color: Colors.red),
                ),
              if (configuration.canSubmitChange)
                OutlinedButton(
                    onPressed: configuration.onChangeSubmitted,
                    child: Text('Save'))
            ],
          ),
        ),

        changingWidget: (configuration) => Column(
          children: [
            const Text('Enter current pin'),
            configuration.oldPinInputWidget,
            if (_isCurrentPinIssue(configuration.error))
              Text(
                configuration.error!.toString(),
                style: const TextStyle(color: Colors.red),
              ),
            const Text('Enter new pin'),
            configuration.newPinInputWidget,
            const Text('Confirm new pin'),
            configuration.confirmNewPinInputWidget,
            if (configuration.error != null &&
                !_isCurrentPinIssue(configuration.error))
              Text(
                configuration.error!.toString(),
                style: const TextStyle(color: Colors.red),
              ),
            if (configuration.canSubmitChange)
              TextButton(
                onPressed: configuration.onSubimtChange,
                child: const Text('Save'),
              )
          ],
        ),
      ),
    );
  }

  bool _isCurrentPinIssue(LocalAuthFailure? error) {
    return error == LocalAuthFailure.wrongPin ||
        error == LocalAuthFailure.tooManyAttempts;
  }
}

class _InputField extends StatelessWidget {
  final InputFieldState state;
  final int index;
  const _InputField({
    Key? key,
    required this.state,
    required this.index,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final borderColor = state == InputFieldState.error
        ? Theme.of(context).errorColor
        : Theme.of(context).primaryColor;
    double borderWidth = 1;
    if (state == InputFieldState.focused ||
        state == InputFieldState.filledAndFocused) {
      borderWidth = 4;
    }
    return Container(
      height: 40,
      width: 46,
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: borderColor,
          width: borderWidth,
        ),
      ),
      child: state == InputFieldState.filled ||
              state == InputFieldState.filledAndFocused
          ? Center(
              child: Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.indigo,
                ),
              ),
            )
          : Container(),
    );
  }
}
