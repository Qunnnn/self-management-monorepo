# api_client.api.DefaultApi

## Load the API package
```dart
import 'package:api_client/api.dart';
```

All URIs are relative to *http://localhost:8080*

| Method                                                         | HTTP request                   | Description                               |
|----------------------------------------------------------------|--------------------------------|-------------------------------------------|
| [**authLoginPost**](DefaultApi.md#authloginpost)               | **POST** /auth/login           | Authenticate a user                       |
| [**authRegisterPost**](DefaultApi.md#authregisterpost)         | **POST** /auth/register        | Register a new user                       |
| [**healthGet**](DefaultApi.md#healthget)                       | **GET** /health                | Health check                              |
| [**tasksGet**](DefaultApi.md#tasksget)                         | **GET** /tasks                 | Get all tasks across all users            |
| [**tasksIdCompletePatch**](DefaultApi.md#tasksidcompletepatch) | **PATCH** /tasks/{id}/complete | Mark a task as completed (alias for POST) |
| [**tasksIdCompletePost**](DefaultApi.md#tasksidcompletepost)   | **POST** /tasks/{id}/complete  | Mark a task as completed                  |
| [**tasksIdDelete**](DefaultApi.md#tasksiddelete)               | **DELETE** /tasks/{id}         | Delete a task                             |
| [**tasksIdGet**](DefaultApi.md#tasksidget)                     | **GET** /tasks/{id}            | Get a task by ID                          |
| [**tasksPost**](DefaultApi.md#taskspost)                       | **POST** /tasks                | Create a new task                         |
| [**usersGet**](DefaultApi.md#usersget)                         | **GET** /users                 | Get all users                             |
| [**usersIdDelete**](DefaultApi.md#usersiddelete)               | **DELETE** /users/{id}         | Delete a user                             |
| [**usersIdGet**](DefaultApi.md#usersidget)                     | **GET** /users/{id}            | Get a user by ID                          |
| [**usersIdPut**](DefaultApi.md#usersidput)                     | **PUT** /users/{id}            | Update a user completely                  |
| [**usersIdTasksGet**](DefaultApi.md#usersidtasksget)           | **GET** /users/{id}/tasks      | Get all tasks for a specific user         |
| [**usersStatsGet**](DefaultApi.md#usersstatsget)               | **GET** /users/stats           | Get user and task statistics              |

# **authLoginPost**
> AuthResponse authLoginPost(loginRequest)

Authenticate a user

Returns a JWT token if credentials are valid.

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getDefaultApi();
final LoginRequest loginRequest = ; // LoginRequest | 

try {
    final response = api.authLoginPost(loginRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DefaultApi->authLoginPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **loginRequest** | [**LoginRequest**](LoginRequest.md)|  | 

### Return type

[**AuthResponse**](AuthResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authRegisterPost**
> User authRegisterPost(createUserRequest)

Register a new user

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getDefaultApi();
final CreateUserRequest createUserRequest = ; // CreateUserRequest | 

try {
    final response = api.authRegisterPost(createUserRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DefaultApi->authRegisterPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createUserRequest** | [**CreateUserRequest**](CreateUserRequest.md)|  | 

### Return type

[**User**](User.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **healthGet**
> String healthGet()

Health check

Returns OK if the server is running.

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getDefaultApi();

try {
    final response = api.healthGet();
    print(response);
} on DioException catch (e) {
    print('Exception when calling DefaultApi->healthGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

**String**

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **tasksGet**
> List<Task> tasksGet()

Get all tasks across all users

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getDefaultApi();

try {
    final response = api.tasksGet();
    print(response);
} on DioException catch (e) {
    print('Exception when calling DefaultApi->tasksGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List&lt;Task&gt;**](Task.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **tasksIdCompletePatch**
> Task tasksIdCompletePatch(id)

Mark a task as completed (alias for POST)

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getDefaultApi();
final String id = id_example; // String | 

try {
    final response = api.tasksIdCompletePatch(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DefaultApi->tasksIdCompletePatch: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**Task**](Task.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **tasksIdCompletePost**
> Task tasksIdCompletePost(id)

Mark a task as completed

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getDefaultApi();
final String id = id_example; // String | The task ID

try {
    final response = api.tasksIdCompletePost(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DefaultApi->tasksIdCompletePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| The task ID | 

### Return type

[**Task**](Task.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **tasksIdDelete**
> tasksIdDelete(id)

Delete a task

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getDefaultApi();
final String id = id_example; // String | The task ID

try {
    api.tasksIdDelete(id);
} on DioException catch (e) {
    print('Exception when calling DefaultApi->tasksIdDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| The task ID | 

### Return type

void (empty response body)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **tasksIdGet**
> Task tasksIdGet(id)

Get a task by ID

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getDefaultApi();
final String id = id_example; // String | The task ID

try {
    final response = api.tasksIdGet(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DefaultApi->tasksIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| The task ID | 

### Return type

[**Task**](Task.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **tasksPost**
> Task tasksPost(createTaskRequest)

Create a new task

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getDefaultApi();
final CreateTaskRequest createTaskRequest = ; // CreateTaskRequest | 

try {
    final response = api.tasksPost(createTaskRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DefaultApi->tasksPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createTaskRequest** | [**CreateTaskRequest**](CreateTaskRequest.md)|  | 

### Return type

[**Task**](Task.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **usersGet**
> List<User> usersGet()

Get all users

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getDefaultApi();

try {
    final response = api.usersGet();
    print(response);
} on DioException catch (e) {
    print('Exception when calling DefaultApi->usersGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List&lt;User&gt;**](User.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **usersIdDelete**
> usersIdDelete(id)

Delete a user

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getDefaultApi();
final String id = id_example; // String | The user ID

try {
    api.usersIdDelete(id);
} on DioException catch (e) {
    print('Exception when calling DefaultApi->usersIdDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| The user ID | 

### Return type

void (empty response body)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **usersIdGet**
> User usersIdGet(id)

Get a user by ID

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getDefaultApi();
final String id = id_example; // String | The user ID

try {
    final response = api.usersIdGet(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DefaultApi->usersIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| The user ID | 

### Return type

[**User**](User.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **usersIdPut**
> User usersIdPut(id, modifyUserRequest)

Update a user completely

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getDefaultApi();
final String id = id_example; // String | The user ID
final ModifyUserRequest modifyUserRequest = ; // ModifyUserRequest | 

try {
    final response = api.usersIdPut(id, modifyUserRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DefaultApi->usersIdPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| The user ID | 
 **modifyUserRequest** | [**ModifyUserRequest**](ModifyUserRequest.md)|  | 

### Return type

[**User**](User.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **usersIdTasksGet**
> List<Task> usersIdTasksGet(id)

Get all tasks for a specific user

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getDefaultApi();
final String id = id_example; // String | The user ID

try {
    final response = api.usersIdTasksGet(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DefaultApi->usersIdTasksGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| The user ID | 

### Return type

[**List&lt;Task&gt;**](Task.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **usersStatsGet**
> UserStats usersStatsGet()

Get user and task statistics

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getDefaultApi();

try {
    final response = api.usersStatsGet();
    print(response);
} on DioException catch (e) {
    print('Exception when calling DefaultApi->usersStatsGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**UserStats**](UserStats.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

