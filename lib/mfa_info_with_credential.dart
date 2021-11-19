class MFAInfoWithCredential {
  MFAInfoWithCredential({
    required this.mfaPendingCredential,
    required this.mfaInfo,
    this.sessionInfo,
  });
  final String mfaPendingCredential;
  final Map<String, dynamic> mfaInfo;
  final String? sessionInfo;
  late final phoneInfo = mfaInfo['phoneInfo'].toString();
  late final mfaEnrollmentId = mfaInfo['mfaEnrollmentId'].toString();

  MFAInfoWithCredential sessionInfoCopyWith({required String sessionInfo}) {
    return MFAInfoWithCredential(
      mfaPendingCredential: mfaPendingCredential,
      mfaInfo: mfaInfo,
      sessionInfo: sessionInfo,
    );
  }
}
