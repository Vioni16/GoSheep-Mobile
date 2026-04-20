import 'package:flutter/material.dart';

class AsyncStateSliver<T> extends StatelessWidget {
  final bool isLoading;
  final String? error;
  final List<T> data;
  final bool showErrorWhenHasData;

  final Widget Function() onLoading;
  final Widget Function(String err) onError;
  final Widget Function() onEmpty;
  final Widget Function(List<T> data) onSuccess;

  const AsyncStateSliver({
    super.key,
    required this.isLoading,
    required this.error,
    required this.data,
    required this.onLoading,
    required this.onError,
    required this.onEmpty,
    required this.onSuccess,
    this.showErrorWhenHasData = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading && data.isEmpty) {
      return onLoading();
    }

    if (error != null && data.isEmpty) {
      return onError(error!);
    }

    if (error != null && showErrorWhenHasData) {
      return onError(error!);
    }

    if (data.isEmpty) {
      return onEmpty();
    }

    return onSuccess(data);
  }
}