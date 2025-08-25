import 'package:flutter/material.dart';

// Custom Loading Widget
class CustomLoadingWidget extends StatelessWidget {
  final Color? color;
  final double? size;
  final String? message;

  const CustomLoadingWidget({
    Key? key,
    this.color,
    this.size,
    this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: color ?? const Color(0xFF22C55E),
            strokeWidth: size != null ? size! * 0.1 : 4.0,
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

// Custom Error Widget
class CustomErrorWidget extends StatelessWidget {
  final String error;
  final VoidCallback? onRetry;
  final String? retryButtonText;
  final IconData? icon;
  final Color? iconColor;

  const CustomErrorWidget({
    Key? key,
    required this.error,
    this.onRetry,
    this.retryButtonText,
    this.icon,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon ?? Icons.error_outline,
              size: 60,
              color: iconColor ?? Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Oops! Something went wrong',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF22C55E),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                onPressed: onRetry,
                child: Text(retryButtonText ?? 'Try Again'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Custom Empty State Widget
class CustomEmptyWidget extends StatelessWidget {
  final String message;
  final String? subtitle;
  final IconData? icon;
  final Color? iconColor;
  final VoidCallback? onAction;
  final String? actionButtonText;

  const CustomEmptyWidget({
    Key? key,
    required this.message,
    this.subtitle,
    this.icon,
    this.iconColor,
    this.onAction,
    this.actionButtonText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon ?? Icons.inbox_outlined,
              size: 80,
              color: iconColor ?? Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
            if (onAction != null) ...[
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF22C55E),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                onPressed: onAction,
                child: Text(actionButtonText ?? 'Get Started'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Generic State Builder Widget
class StateBuilder<T> extends StatelessWidget {
  final bool isLoading;
  final String? error;
  final List<T>? data;
  final Widget Function(List<T> data) builder;
  final VoidCallback? onRetry;
  final String? loadingMessage;
  final String? emptyMessage;
  final String? emptySubtitle;
  final IconData? emptyIcon;

  const StateBuilder({
    Key? key,
    required this.isLoading,
    required this.error,
    required this.data,
    required this.builder,
    this.onRetry,
    this.loadingMessage,
    this.emptyMessage,
    this.emptySubtitle,
    this.emptyIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return CustomLoadingWidget(message: loadingMessage);
    }

    if (error != null) {
      return CustomErrorWidget(
        error: error!,
        onRetry: onRetry,
      );
    }

    if (data == null || data!.isEmpty) {
      return CustomEmptyWidget(
        message: emptyMessage ?? 'No data found',
        subtitle: emptySubtitle,
        icon: emptyIcon,
      );
    }

    return builder(data!);
  }
}

// Search-specific Empty Widget
class SearchEmptyWidget extends StatelessWidget {
  final String searchQuery;
  final String itemType; // e.g., "users", "posts", etc.

  const SearchEmptyWidget({
    Key? key,
    required this.searchQuery,
    this.itemType = 'results',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomEmptyWidget(
      message: searchQuery.isNotEmpty 
          ? 'No $itemType found' 
          : 'Start searching to find $itemType',
      subtitle: searchQuery.isNotEmpty 
          ? 'No $itemType match "$searchQuery"'
          : 'Type in the search box above',
      icon: searchQuery.isNotEmpty 
          ? Icons.search_off 
          : Icons.search,
      iconColor: Colors.grey[400],
    );
  }
}