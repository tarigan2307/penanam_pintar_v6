import 'dart:io';
import 'package:googleapis/drive/v3.dart' as ga;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;

class GoogleHttpClient extends http.BaseClient {
  final Map<String, String> _headers;
  final http.Client _client = http.Client();
  GoogleHttpClient(this._headers);
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(_headers);
    return _client.send(request);
  }
}

class DriveService {
  final GoogleSignIn _gSignIn = GoogleSignIn(scopes: [ga.DriveApi.driveFileScope]);

  Future<GoogleSignInAccount?> signIn() async {
    return await _gSignIn.signIn();
  }

  Future<GoogleSignInAccount?> signInSilently() async {
    return await _gSignIn.signInSilently();
  }

  Future<void> uploadFile(File file) async {
    try {
      final account = await _gSignIn.signInSilently() ?? await _gSignIn.signIn();
      if (account == null) return;
      final headers = await account.authHeaders;
      final client = GoogleHttpClient(headers);
      final drive = ga.DriveApi(client);
      final ga.File toCreate = ga.File();
      toCreate.name = file.uri.pathSegments.last;
      toCreate.parents = ['appDataFolder']; // hidden app folder
      final stream = http.ByteStream(DelegatingStream.typed(file.openRead()));
      final media = ga.Media(stream, await file.length());
      await drive.files.create(toCreate, uploadMedia: media);
    } catch (e) {
      print('Drive upload failed: $e');
    }
  }
}
