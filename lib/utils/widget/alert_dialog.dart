import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

//UTIL
import '../globals.dart';
import '../settings/my_button.dart';

class MyDialogMessage {
  final String titolo;
  final String? body;
  MyDialogMessage({required this.titolo, this.body});
}

MyDialogMessage _message(dynamic exception) {
  switch (exception) {
    case 'email-already-in-use':
      return MyDialogMessage(titolo: 'Email già registrata');
    case 'operation-not-allowed':
      return MyDialogMessage(
        titolo: 'Operazione non consentita',
        body: 'Contattaci per ulteriori chiarimenti',
      );
    case 'weak-password':
      return MyDialogMessage(
        titolo:
            'La password deve contenere:\n- 6 caratteri\n- Maiuscola\n- Minuscola\n- Numero\n- Carattere speciale',
      );
    case 'invalid-email':
      return MyDialogMessage(titolo: 'Email non valida');
    case 'invalid-credential':
      return MyDialogMessage(
        titolo: 'Credenziali non valide',
        body: 'Controlla la tua email e password',
      );
    case 'wrong-password':
      return MyDialogMessage(titolo: 'Password errata', body: 'Riprova');
    case 'too-many-requests':
      return MyDialogMessage(
        titolo: 'Troppi tentativi',
        body: 'Si è tentato troppe volte.\nRiprova tra poco',
      );
    case 'user-disabled':
      return MyDialogMessage(
        titolo: 'Account disabilitato',
        body: 'Contattaci per ulteriori chiarimenti',
      );
    case 'user-not-found':
      return MyDialogMessage(titolo: 'Email non registrata');
    case 'no-user':
      return MyDialogMessage(titolo: 'Email e/o password\nnon registrati');
    case 'username-already-in-use':
      return MyDialogMessage(
        titolo: 'Username già in uso',
        body: 'Prova a cambiarlo',
      );
    case 'user-no-app':
      return MyDialogMessage(titolo: 'Utente non abilitato ad entrare');
    case 'requires-recent-login':
      return MyDialogMessage(
        titolo:
            'Per motivi di sicurezza, effettua nuovamente il login e riprova.',
      );
    case 'missing-password':
      return MyDialogMessage(titolo: 'Password mancante');
    case 'network-request-failed':
      return MyDialogMessage(
        titolo: 'Problemi di rete',
        body: 'Controlla la tua connessione',
      );
    case 'account-exists-with-different-credential':
      return MyDialogMessage(
        titolo: 'Account esistente con credenziali diverse',
        body: 'Prova a utilizzare un metodo di accesso diverso',
      );
    default:
      return MyDialogMessage(
        titolo: 'Non riesco ad autenticarti',
        body: 'Riprova più tardi',
      );
  }
}

Widget _getImage(AlertType? type, {double size = 70}) {
  Widget response;
  switch (type) {
    case AlertType.success:
      response = Image.asset(
        '$kImagePath/icon_success.png',
        package: 'rflutter_alert',
        height: size,
      );
      break;
    case AlertType.error:
      response = Image.asset(
        '$kImagePath/icon_error.png',
        package: 'rflutter_alert',
        height: size,
      );
      break;
    case AlertType.info:
      response = Image.asset(
        '$kImagePath/icon_info.png',
        package: 'rflutter_alert',
        height: size,
      );
      break;
    case AlertType.warning:
      response = Image.asset(
        '$kImagePath/icon_warning.png',
        package: 'rflutter_alert',
        height: size,
      );
      break;
    default:
      response = Container();
      break;
  }
  return response;
}

Future<bool?> alertDialog(
  BuildContext context, {
  String? titolo,
  String? body,
  dynamic authException,
  bool hasScelta = false,
  VoidCallback? onPressed,
  AlertType? type = AlertType.warning,
}) {
  return Alert(
    padding: EdgeInsets.symmetric(
      horizontal: 40,
      vertical: type != null ? 30 : 0,
    ),
    context: context,
    image: _getImage(type),
    title: titolo ?? _message(authException).titolo,
    style: AlertStyle(
      titleStyle: const TextStyle(
        fontFamily: 'Roboto',
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      isCloseButton: false,
      animationType: AnimationType.grow,
      buttonsDirection: ButtonsDirection.column,
      backgroundColor: Colors.white,
      titlePadding: EdgeInsets.only(top: type == null ? 30 : 20),
      buttonAreaPadding: const EdgeInsets.symmetric(
        horizontal: 60,
        vertical: 20,
      ),
    ),
    content:
        body == null &&
            (authException == null || _message(authException).body == null)
        ? const SizedBox()
        : Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 0),
            child: Text(
              body ?? _message(authException).body!,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 16,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
    buttons: hasScelta
        ? [
            DialogButton(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(vertical: 13),
              radius: BorderRadius.circular(borderRadius),
              height: 50,
              color: MyButtonColor.defaultColor.backgroundColor,
              onPressed: onPressed,
              child: Text(
                "SI",
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: MyButtonColor.defaultColor.fontColor,
                ),
              ),
            ),
            DialogButton(
              margin: const EdgeInsets.only(bottom: 10),
              radius: BorderRadius.circular(borderRadius),
              padding: const EdgeInsets.symmetric(vertical: 13),
              height: 50,
              color: MyButtonColor.secondaryButton.backgroundColor,
              border: Border.all(color: Colors.black),
              child: Text(
                "NO",
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: MyButtonColor.secondaryButton.fontColor,
                ),
              ),
              onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
            ),
          ]
        : [
            DialogButton(
              radius: BorderRadius.circular(borderRadius),
              padding: const EdgeInsets.symmetric(vertical: 13),
              height: 50,
              color: MyButtonColor.defaultColor.backgroundColor,
              onPressed:
                  onPressed ??
                  () => Navigator.of(context, rootNavigator: true).pop(),
              child: Text(
                "OK",
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: MyButtonColor.defaultColor.fontColor,
                ),
              ),
            ),
          ],
  ).show();
}
