import 'package:share_plus/share_plus.dart';

class ShareService {
  Future<void> shareImage(String filePath) async {
    await Share.shareXFiles(
      [XFile(filePath)],
      text: 'My Rishta Biodata — created with Rishta Biodata Maker',
    );
  }

  Future<void> shareApp() async {
    await Share.share(
      'Create beautiful rishta biodata cards!\n'
          'Download Rishta Biodata Maker: https://play.google.com/store/apps/details?id=com.example.rishta_biodata_maker',
    );
  }
}