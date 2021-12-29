import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const domainUrl = "https://warehouse-system-api.herokuapp.com";

const secureStorageAndroidOptions = AndroidOptions(
  encryptedSharedPreferences: true,
  resetOnError: true,
);

const checkConnectionSnackbar = SnackBar(
  content: Text(
    "Check your internet connection",
  ),
);

const notSuccessSnackbar = SnackBar(
  content: Text(
    "Task could not done successfully!",
  ),
);
