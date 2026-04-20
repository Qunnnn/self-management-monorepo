enum APIEndpoint {
  login('/auth/login'),
  register('/auth/register'),
  refresh('/auth/refresh'),
  logout('/auth/logout'),
  profile('/users/me'),
  tasks('/tasks');

  const APIEndpoint(this.path);
  final String path;

  bool get isPublic {
    return switch (this) {
      APIEndpoint.login || APIEndpoint.register || APIEndpoint.refresh => true,
      _ => false,
    };
  }
}
