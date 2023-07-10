// ignore_for_file: file_names
import 'package:ati/models/user.dart';
import 'package:ati/utils/authClient.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:shared_preferences/shared_preferences.dart';

class Utils {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId:
          '429719789896-dncmk9r0o0ml6ff6oror6f4ogku1vaae.apps.googleusercontent.com',
      scopes: [
        drive.DriveApi.driveScope,
        drive.DriveApi.driveReadonlyScope,
        drive.DriveApi.driveAppdataScope,
        drive.DriveApi.driveFileScope,
      ]);
  final List<drive.File> _documents = [];

  // This function signInGoogle return user of firebase
  Future<DataUser?> signInWhithGoogle() async {
    try {
      GoogleSignInAccount? account = await googleSignIn.signIn();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Map<String, String> authHeaders = await account!.authHeaders;
      authHeaders.forEach((key, value) {
        prefs.setString(key, value);
      });
      GoogleSignInAuthentication? accountAuth = await account.authentication;
      UserData().registraToken(accountAuth.accessToken);
      AuthCredential credential =
          GoogleAuthProvider.credential(accessToken: accountAuth.accessToken!);
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      User user = userCredential.user!;
      UserData().registraDisplayName(user.displayName.toString());
      UserData().registraDisplayEmail(user.email.toString());

      return DataUser(user: user);
    } catch (e) {
      return null;
    }
  }

  // function to log out
  void signInOut() {
    googleSignIn.disconnect();
  }

  Future<List<drive.File>?> getDocuments(String q) async {
    try {
      // get headers to access drive
      final Map<String, String> account = {};
      SharedPreferences prefs = await SharedPreferences.getInstance();
      account['Authorization'] = prefs.getString('Authorization')!;
      account['X-Goog-AuthUser'] = prefs.getString('X-Goog-AuthUser')!;

      GoogleAuthClient authenticateClient = GoogleAuthClient(account);
      var driveApi = drive.DriveApi(authenticateClient);
      // Get the list of all files in shared folder
      _documents.clear();
      drive.FileList listDocuments;
      if (q == '' || q.isEmpty) {
        listDocuments = await driveApi.files.list(
            q: "parents in '1rKVB6PyxkBAYoewUMwiOJi7pI2AXgDv8' and trashed=false",
            $fields: '*',
            includeItemsFromAllDrives: true,
            supportsAllDrives: true,
            corpora: 'allDrives');
        _documents.addAll(listDocuments.files!);
      } else {
        listDocuments = await driveApi.files.list(
          q: "parents in '1rKVB6PyxkBAYoewUMwiOJi7pI2AXgDv8' and trashed=false and name contains '$q'",
          $fields: '*',
          corpora: 'allDrives',
          includeItemsFromAllDrives: true,
          supportsAllDrives: true,
        );
        _documents.addAll(listDocuments.files!);
      }

      return _documents;
    } catch (e) {
      return [];
    }
  }

  // Function to upload file
  Future upload(List<int> dato, String title) async {
    try {
      // get headers to access drive
      final Map<String, String> account = {};
      SharedPreferences prefs = await SharedPreferences.getInstance();
      account['Authorization'] = prefs.getString('Authorization')!;
      account['X-Goog-AuthUser'] = prefs.getString('X-Goog-AuthUser')!;
      GoogleAuthClient authenticateClient = GoogleAuthClient(account);
      var driveApi = drive.DriveApi(authenticateClient);

      // we create the file in bits format
      final Stream<List<int>> mediaStream =
          Future.value(dato).asStream().asBroadcastStream();
      var media = drive.Media(mediaStream, dato.length);
      var driveFile = drive.File();
      driveFile.name = title;
      driveFile.parents = ['1rKVB6PyxkBAYoewUMwiOJi7pI2AXgDv8'];

      await driveApi.files.create(driveFile,
          uploadMedia: media,
          supportsAllDrives: true,
          supportsTeamDrives: true);
      return 'OK';
    } catch (e) {
      return e;
    }
  }

  deletePDF(String titulo) {}
}
