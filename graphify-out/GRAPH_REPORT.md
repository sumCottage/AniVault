# Graph Report - AniFlux  (2026-08-09)

## Corpus Check
- 68 files · ~350,850 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 639 nodes · 763 edges · 23 communities detected
- Extraction: 98% EXTRACTED · 2% INFERRED · 0% AMBIGUOUS · INFERRED: 12 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Community Hubs (Navigation)
- [[_COMMUNITY_Community 0|Community 0]]
- [[_COMMUNITY_Community 1|Community 1]]
- [[_COMMUNITY_Community 2|Community 2]]
- [[_COMMUNITY_Community 3|Community 3]]
- [[_COMMUNITY_Community 4|Community 4]]
- [[_COMMUNITY_Community 5|Community 5]]
- [[_COMMUNITY_Community 6|Community 6]]
- [[_COMMUNITY_Community 7|Community 7]]
- [[_COMMUNITY_Community 8|Community 8]]
- [[_COMMUNITY_Community 9|Community 9]]
- [[_COMMUNITY_Community 10|Community 10]]
- [[_COMMUNITY_Community 11|Community 11]]
- [[_COMMUNITY_Community 12|Community 12]]
- [[_COMMUNITY_Community 13|Community 13]]
- [[_COMMUNITY_Community 14|Community 14]]
- [[_COMMUNITY_Community 15|Community 15]]
- [[_COMMUNITY_Community 16|Community 16]]
- [[_COMMUNITY_Community 17|Community 17]]
- [[_COMMUNITY_Community 18|Community 18]]
- [[_COMMUNITY_Community 19|Community 19]]
- [[_COMMUNITY_Community 20|Community 20]]
- [[_COMMUNITY_Community 21|Community 21]]
- [[_COMMUNITY_Community 22|Community 22]]

## God Nodes (most connected - your core abstractions)
1. `package:flutter/material.dart` - 26 edges
2. `package:firebase_auth/firebase_auth.dart` - 17 edges
3. `package:ainme_vault/theme/app_theme.dart` - 16 edges
4. `package:flutter/services.dart` - 15 edges
5. `package:cloud_firestore/cloud_firestore.dart` - 14 edges
6. `package:cached_network_image/cached_network_image.dart` - 10 edges
7. `package:shared_preferences/shared_preferences.dart` - 9 edges
8. `package:url_launcher/url_launcher.dart` - 8 edges
9. `dart:async` - 7 edges
10. `Create()` - 7 edges

## Surprising Connections (you probably didn't know these)
- `my_application_dispose()` --calls--> `dispose`  [INFERRED]
  linux/runner/my_application.cc → lib/widgets/anime_entry_bottom_sheet.dart
- `OnCreate()` --calls--> `RegisterPlugins()`  [INFERRED]
  windows/runner/flutter_window.cpp → windows/flutter/generated_plugin_registrant.cc
- `OnCreate()` --calls--> `Show()`  [INFERRED]
  windows/runner/flutter_window.cpp → windows/runner/win32_window.cpp
- `CreateAndAttachConsole()` --calls--> `wWinMain()`  [INFERRED]
  windows/runner/utils.cpp → windows/runner/main.cpp
- `SetQuitOnClose()` --calls--> `wWinMain()`  [INFERRED]
  windows/runner/win32_window.cpp → windows/runner/main.cpp

## Communities

### Community 0 - "Community 0"
Cohesion: 0.04
Nodes (56): package:ainme_vault/screens/character_detail_screen.dart, package:ainme_vault/screens/search_screen.dart, package:ainme_vault/utils/light_skeleton.dart, package:ainme_vault/widgets/anime_entry_bottom_sheet.dart, AnimeDetailScreen, _AnimeDetailScreenState, build, _buildCharactersTab (+48 more)

### Community 1 - "Community 1"
Cohesion: 0.04
Nodes (51): dart:convert, dart:io, package:flutter_dotenv/flutter_dotenv.dart, package:flutter_secure_storage/flutter_secure_storage.dart, package:http/http.dart, package:in_app_review/in_app_review.dart, package:url_launcher/url_launcher.dart, AboutScreen (+43 more)

### Community 2 - "Community 2"
Cohesion: 0.04
Nodes (51): dart:math, package:ainme_vault/services/app_update_service.dart, package:ainme_vault/widgets/home_list_search_bar.dart, AnimatedContainer, AnimatedSwitcher, _AnimeCard, BoxConstraints, build (+43 more)

### Community 3 - "Community 3"
Cohesion: 0.05
Nodes (44): package:ainme_vault/screens/anime_detail_screen.dart, package:ainme_vault/services/anilist_auth_service.dart, package:cached_network_image/cached_network_image.dart, package:cloud_firestore/cloud_firestore.dart, package:firebase_auth/firebase_auth.dart, package:firebase_messaging/firebase_messaging.dart, package:google_sign_in/google_sign_in.dart, package:shimmer/shimmer.dart (+36 more)

### Community 4 - "Community 4"
Cohesion: 0.05
Nodes (42): package:flutter/rendering.dart, ../screens/anime_detail_screen.dart, ../services/anilist_service.dart, build, _buildAnimeCard, _buildSkeletonCard, CalendarView, _CalendarViewState (+34 more)

### Community 5 - "Community 5"
Cohesion: 0.05
Nodes (38): package:ainme_vault/theme/app_theme.dart, package:flutter/gestures.dart, package:flutter/services.dart, build, _buildLabel, _buildTextField, dispose, Scaffold (+30 more)

### Community 6 - "Community 6"
Cohesion: 0.05
Nodes (39): anime_detail_screen.dart, _addToHistory, AnimatedContainer, AnimeListCard, AnimeListShimmer, build, buildAnimatedSearchBar, _buildErrorWidget (+31 more)

### Community 7 - "Community 7"
Cohesion: 0.09
Nodes (25): FlutterWindow(), OnCreate(), RegisterPlugins(), wWinMain(), CreateAndAttachConsole(), GetCommandLineArguments(), Utf8FromUtf16(), Create() (+17 more)

### Community 8 - "Community 8"
Cohesion: 0.06
Nodes (31): firebase_options.dart, package:ainme_vault/providers/theme_provider.dart, package:ainme_vault/screens/profile_screen.dart, package:ainme_vault/services/auth_service.dart, package:firebase_core/firebase_core.dart, package:flutter_displaymode/flutter_displaymode.dart, package:flutter/foundation.dart, screens/home_screen.dart (+23 more)

### Community 9 - "Community 9"
Cohesion: 0.07
Nodes (28): ../main.dart, package:ainme_vault/screens/about_screen.dart, package:ainme_vault/utils/transitions.dart, package:ainme_vault/widgets/account_settings_bottom_sheet.dart, package:ainme_vault/widgets/avatar_picker_bottom_sheet.dart, package:ainme_vault/widgets/edit_profile_bottom_sheet.dart, package:ainme_vault/widgets/notifications_bottom_sheet.dart, build (+20 more)

### Community 10 - "Community 10"
Cohesion: 0.07
Nodes (26): package:ainme_vault/main.dart, package:ainme_vault/screens/forgot_password_screen.dart, package:ainme_vault/screens/login_screen.dart, package:ainme_vault/screens/signup_screen.dart, package:ainme_vault/services/notification_service.dart, AuthWrapper, build, LoginScreen (+18 more)

### Community 11 - "Community 11"
Cohesion: 0.07
Nodes (27): package:ainme_vault/services/anilist_import_service.dart, package:app_links/app_links.dart, AccountSettingsBottomSheet, _AccountSettingsBottomSheetState, _actionTile, _aniListProfileTile, build, Color (+19 more)

### Community 12 - "Community 12"
Cohesion: 0.08
Nodes (22): package:flutter/material.dart, package:graphql_flutter/graphql_flutter.dart, package:shared_preferences/shared_preferences.dart, isDark, _loadFromPrefs, setThemeMode, ThemeProvider, AniListService (+14 more)

### Community 13 - "Community 13"
Cohesion: 0.09
Nodes (22): package:connectivity_plus/connectivity_plus.dart, package:flutter_markdown_plus/flutter_markdown_plus.dart, build, _buildInfoItem, CharacterDetailScreen, _CharacterDetailScreenState, ClipRRect, Container (+14 more)

### Community 14 - "Community 14"
Cohesion: 0.09
Nodes (21): package:ainme_vault/services/anilist_service.dart, package:ainme_vault/services/review_service.dart, AnimeEntryBottomSheet, _AnimeEntryBottomSheetState, build, _buildDateSelector, _buildSectionTitle, Container (+13 more)

### Community 15 - "Community 15"
Cohesion: 0.13
Nodes (6): fl_register_plugins(), main(), my_application_activate(), my_application_dispose(), my_application_new(), dispose

### Community 16 - "Community 16"
Cohesion: 0.14
Nodes (13): dart:async, dart:ui, package:flutter/cupertino.dart, package:intl/intl.dart, package:package_info_plus/package_info_plus.dart, AppUpdateService, BackdropFilter, _isUpdateAvailable (+5 more)

### Community 17 - "Community 17"
Cohesion: 0.29
Nodes (2): AppDelegate, FlutterAppDelegate

### Community 18 - "Community 18"
Cohesion: 0.33
Nodes (3): RegisterGeneratedPlugins(), MainFlutterWindow, NSWindow

### Community 19 - "Community 19"
Cohesion: 0.4
Nodes (2): RunnerTests, XCTestCase

### Community 20 - "Community 20"
Cohesion: 0.4
Nodes (2): GeneratedPluginRegistrant, -registerWithRegistry

### Community 21 - "Community 21"
Cohesion: 0.5
Nodes (2): handle_new_rx_page(), Intercept NOTIFY_DEBUGGER_ABOUT_RX_PAGES and touch the pages.

### Community 22 - "Community 22"
Cohesion: 1.0
Nodes (1): MainActivity

## Knowledge Gaps
- **479 isolated node(s):** `-registerWithRegistry`, `Intercept NOTIFY_DEBUGGER_ABOUT_RX_PAGES and touch the pages.`, `MainActivity`, `DefaultFirebaseOptions`, `UnsupportedError` (+474 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **Thin community `Community 17`** (7 nodes): `AppDelegate`, `.application()`, `.applicationShouldTerminateAfterLastWindowClosed()`, `.applicationSupportsSecureRestorableState()`, `FlutterAppDelegate`, `AppDelegate.swift`, `AppDelegate.swift`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 19`** (5 nodes): `RunnerTests.swift`, `RunnerTests.swift`, `RunnerTests`, `.testExample()`, `XCTestCase`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 20`** (5 nodes): `GeneratedPluginRegistrant.java`, `GeneratedPluginRegistrant`, `.registerWith()`, `-registerWithRegistry`, `GeneratedPluginRegistrant.m`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 21`** (4 nodes): `handle_new_rx_page()`, `__lldb_init_module()`, `Intercept NOTIFY_DEBUGGER_ABOUT_RX_PAGES and touch the pages.`, `flutter_lldb_helper.py`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 22`** (2 nodes): `MainActivity.kt`, `MainActivity`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `package:flutter/material.dart` connect `Community 12` to `Community 0`, `Community 1`, `Community 2`, `Community 3`, `Community 4`, `Community 5`, `Community 6`, `Community 8`, `Community 9`, `Community 10`, `Community 11`, `Community 13`, `Community 14`, `Community 16`?**
  _High betweenness centrality (0.234) - this node is a cross-community bridge._
- **Why does `package:ainme_vault/theme/app_theme.dart` connect `Community 5` to `Community 0`, `Community 1`, `Community 2`, `Community 3`, `Community 4`, `Community 8`, `Community 9`, `Community 10`, `Community 11`, `Community 13`, `Community 14`?**
  _High betweenness centrality (0.089) - this node is a cross-community bridge._
- **Why does `package:flutter/services.dart` connect `Community 5` to `Community 0`, `Community 1`, `Community 2`, `Community 3`, `Community 4`, `Community 6`, `Community 8`, `Community 10`, `Community 13`, `Community 14`?**
  _High betweenness centrality (0.088) - this node is a cross-community bridge._
- **What connects `-registerWithRegistry`, `Intercept NOTIFY_DEBUGGER_ABOUT_RX_PAGES and touch the pages.`, `MainActivity` to the rest of the system?**
  _479 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Community 0` be split into smaller, more focused modules?**
  _Cohesion score 0.04 - nodes in this community are weakly interconnected._
- **Should `Community 1` be split into smaller, more focused modules?**
  _Cohesion score 0.04 - nodes in this community are weakly interconnected._
- **Should `Community 2` be split into smaller, more focused modules?**
  _Cohesion score 0.04 - nodes in this community are weakly interconnected._