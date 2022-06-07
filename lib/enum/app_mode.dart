enum AppMode {
  local(serverUrl: 'http://192.168.0.2:3010/');

  final String serverUrl;

  const AppMode({required this.serverUrl});
}
