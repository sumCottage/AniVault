---
description: How to implement error handling across screens
---

# Error Handling Implementation Guide

This workflow documents the error handling changes made to AnimeVault, allowing you to replicate them on any branch.

---

## 1. Create Reusable Error Widgets

**File:** `lib/widgets/error_widgets.dart`

Create this file with the following widgets:

### Widgets Included:

- **`ErrorCard`** - Full card with icon, title, message, and retry button
- **`InlineError`** - Compact inline error for sections
- **`NoConnectionWidget`** - Specific "no internet" error
- **`EmptyStateWidget`** - Friendly "no data" display
- **`showErrorSnackBar()`** - Helper function for floating error toasts
- **`showSuccessSnackBar()`** - Helper function for success messages

---

## 2. Update Screen State Classes

For each screen, add these state variables:

```dart
// Error handling states
bool hasError = false;
String? errorMessage;
```

---

## 3. Update Fetch Methods Pattern

Wrap API calls with try-catch and update error state:

```dart
Future<void> _fetchData() async {
  setState(() {
    isLoading = true;
    hasError = false;
    errorMessage = null;
  });

  try {
    final data = await ApiService.getData();
    if (!mounted) return;

    if (data != null) {
      setState(() {
        // Update data here
        isLoading = false;
        hasError = false;
      });
    } else {
      setState(() {
        isLoading = false;
        hasError = true;
        errorMessage = "Failed to load data";
      });
    }
  } catch (e) {
    if (!mounted) return;
    setState(() {
      isLoading = false;
      hasError = true;
      errorMessage = "Network error. Please try again.";
    });
  }
}
```

---

## 4. Update Build Methods Pattern

Add error state check in the widget tree:

```dart
child: isLoading
    ? const LoadingShimmer()
    : hasError
        ? ErrorCard(
            title: "Failed to Load",
            message: errorMessage,
            onRetry: _fetchData,
          )
        : dataList.isEmpty
            ? const EmptyStateWidget(
                title: "No Results Found",
                message: "Try a different search",
              )
            : ListView.builder(...)
```

---

## 5. Files Modified

| File                                       | Changes                                                             |
| ------------------------------------------ | ------------------------------------------------------------------- |
| `lib/widgets/error_widgets.dart`           | **CREATED** - Reusable error widgets                                |
| `lib/screens/anime_detail_screen.dart`     | Added error state, try-catch, ErrorCard in build                    |
| `lib/screens/character_detail_screen.dart` | Added error state, try-catch, ErrorCard in build                    |
| `lib/screens/search_screen.dart`           | Added error state, try-catch, ErrorCard, EmptyStateWidget, snackbar |

---

## 6. Imports Required

Add to each screen file:

```dart
import 'package:ainme_vault/widgets/error_widgets.dart';
```

---

## 7. Optional: Auto-Reload on Network Restore

Not yet implemented. Would require:

1. Add `connectivity_plus` package
2. Create network listener
3. Auto-retry on connection restore

---

## Usage

To apply these changes to another branch:

1. Copy `lib/widgets/error_widgets.dart` to the branch
2. Add imports to each screen
3. Add `hasError` and `errorMessage` state variables
4. Wrap fetch methods with try-catch
5. Update build methods to show ErrorCard when `hasError` is true
