late AppUser appUser;

String testId =
    'AJOnW4QP2jbCvZmY5eOJYUjutiYMSixKCT7OOWzW-Nc9ikENQRyZxkbZtUTS1OBrpNqKI2N2roGMR9bvLLu28DDxE7-ViH0or0KolPv-K50_ssRoN8azooUBnSZozB_nL5_xPohUp5rTGgJIXYBR3YOhFTP2hvrp9UlZ9AmopvP6-wbUSG3EGMd3UvCdWI1ojODmcbLhUNjGPQeE0gNWFPCCYAvqNH0log';

class AppUser {
  String id;
  List<String> savedTickerSymbols;

  AppUser({
    required this.id,
    this.savedTickerSymbols = const [],
  });
}
