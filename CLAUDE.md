# CLAUDE.md - MewNotch

## Project Overview

MewNotch is a free, open-source macOS app (GPLv3) that transforms the Mac notch into a customizable HUD for brightness, volume, power, media, and more. Built with Swift 5 + SwiftUI, targeting macOS 14.0+.

## Build & Run

```bash
# Resolve dependencies (Swift Package Manager)
xcodebuild -resolvePackageDependencies -project MewNotch.xcodeproj

# Build
xcodebuild -project MewNotch.xcodeproj -scheme MewNotch -destination "platform=macOS" build

# Archive for release
xcodebuild clean archive \
  -project MewNotch.xcodeproj \
  -scheme MewNotch \
  -archivePath MewNotch \
  -destination "generic/platform=macOS" \
  ONLY_ACTIVE_ARCH=NO \
  -allowProvisioningUpdates
```

No test suite currently exists. No linter/formatter is configured.

## Architecture

**MVVM** with clear separation:
- `DB/` - Persistence layer (UserDefaults with custom property wrappers)
- `Models/` - Data models and enums
- `View/` - SwiftUI views (Notch, Settings, Common components)
- `ViewModel/` - Observable view models
- `Utils/` - Managers, helpers, extensions

**Key patterns:**
- Singletons via `.shared` (AppDefaults, NotchDefaults, NotchManager, WindowManager)
- Custom `@PrimitiveUserDefault` and `@CodableUserDefault` property wrappers for persistence
- `ObservableObject` + `@Published` for reactive state
- Objective-C bridging for system APIs (audio, brightness, power)

## Key Dependencies

- **Lottie** - JSON animations for HUD elements
- **LaunchAtLogin-Modern** - Login item support
- **SwiftyJSON** - JSON parsing
- **Sparkle** - Auto-updates
- **MacroVisionKit** - Fullscreen monitoring
- Private frameworks: SkyLight, MediaRemote, DisplayServices

## Code Conventions

- **Naming**: PascalCase for types, camelCase for functions/variables
- **File naming**: Match the primary type name
- **SwiftUI**: Use view modifiers, `@Namespace` for geometry transitions, `ViewBuilder` for conditional views
- **macOS version checks**: Use `@available` / `#available` for macOS 26.0+ features (glass effect)
- Follow Apple Human Interface Guidelines

## Commit Messages

Format: `type: scope: description`
- Types: `fix`, `add`, `improve`
- Examples: `fix: notch: media: overflow`, `add: settings: separator control`

## Project Structure (Key Paths)

```
MewNotch/
  MewNotchApp.swift          # App entry point
  MewAppDelegate.swift       # App delegate
  DB/UserDefaults/           # Defaults/persistence
  Models/Enums/              # ExpandedNotchItem, HUDEnums, NotchEnums
  Utils/Managers/            # AirDrop, App, Haptics, MediaKey, Power, Volume, Window
  Utils/Helpers/             # ObjC helpers (Audio, Brightness, Power)
  View/Notch/Collapsed/      # Collapsed notch + HUD views
  View/Notch/Expanded/       # Expanded notch views + controls
  View/Settings/Pages/       # Settings UI pages
  Resources/                 # Assets, Lottie animations
```
