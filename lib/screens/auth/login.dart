import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

//PROVIDER
import '../../providers/auth.dart';

//FUNCTION

//WIDGET
import '../../utils/form/my_text_formfield.dart';
import '../../utils/settings/my_button.dart';
import '../../utils/settings/my_scaffold_auth.dart';
import '../../utils/widget/alert_dialog.dart';
import '../../utils/functions/esapce_char_special.dart';

//SCREEN

class LoginPage extends StatefulWidget {
  final bool isSignin;
  const LoginPage({this.isSignin = false, super.key});
  static const routeName = '/admin/login';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode emailFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();
  final TextEditingController emailTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();

  @override
  void dispose() {
    emailTextController.dispose();
    passwordTextController.dispose();

    emailFocus.dispose();
    passwordFocus.dispose();
    super.dispose();
  }

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return MyScaffoldAuth(
      child: Container(
        width: 350,
        margin: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: AutofillGroup(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 256.0, bottom: 48),
                  child: Text(
                    "ACCEDI",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                // email
                MyTextFormField(
                  hintText: 'Email',
                  helperText: '',
                  keyboardType: TextInputType.emailAddress,
                  controller: emailTextController,
                  focusNode: emailFocus,
                  autofillHints: const [AutofillHints.email],
                  onFieldSubmitted: (value) => _validateForm(),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Inserisci email';
                    }

                    if (!RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                    ).hasMatch(value)) {
                      return 'Email non valida!';
                    }

                    return null;
                  },
                ),

                // password
                MyTextFormField(
                  hintText: 'Password',
                  helperText: '',
                  isPassword: true,
                  controller: passwordTextController,
                  focusNode: passwordFocus,
                  autofillHints: const [AutofillHints.password],
                  onFieldSubmitted: (value) => _validateForm(),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Inserisci password';
                    }
                    return null;
                  },
                ),

                // Bottone Accedi
                MyButton(
                  onPressed: _validateForm,
                  text: 'Accedi',
                  isLoading: _isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _validateForm() async {
    emailFocus.unfocus();
    passwordFocus.unfocus();
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        await Provider.of<Auth>(context, listen: false).loginEmailPassword(
          emailTextController.text.trim(),
          escapeForRegex(passwordTextController.text.trim()),
        );

        setState(() {
          TextInput.finishAutofillContext();
          _isLoading = false;
        });
      } catch (e) {
        // print(e);
        if (mounted) {
          alertDialog(context, authException: e);
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }
}
