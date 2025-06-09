# MewNotch - Make the Mac Notch Useful!

[![GitHub License](https://img.shields.io/github/license/monuk7735/mew-notch)](LICENSE)
[![Downloads](https://img.shields.io/github/downloads/monuk7735/mew-notch/total.svg)](https://github.com/monuk7735/mew-notch/releases)

MewNotch is a macOS app that enhances the functionality of the notch on new MacBooks by displaying volume and brightness changes, replacing the default system HUD with a modern and seamless experience.

You can see preview for a few part of the app in this [Drive Folder](https://drive.google.com/drive/folders/1jvvbnisDR5aG5jBaiGUu_bR7RKrWCiMa)
A github page for the same is work in progress.


## Features

- **Brightness Display** - Displays brightness adjustments in real-time.
- **Sound level Display** - Shows input/output volume changes directly on the notch.
- **Sound Device** - Shows current input/output device on notch, when changed.
- **Power State** - Show current power source as well as left time on battery when available.
- ~~**Now Playing** -  Control now playing media directly from notch. Expand notch for additional controls.~~ <br> _Not Working on macOS 15.4 and above_
- **Mirror** - Get a quick peek on how you're looking by using the mirror in expanded notch.
- **Minimal & Non-Intrusive** - A clean, lightweight alternative to the default system HUD.
- **Fully Custom Notch Experience** - Choose the displays you want to see the notch on.
- **Heavily Customizable** - Each HUD can be customised to have different styling.
- **SwiftUI-based UI** - Smooth animations and modern macOS styling.

## Installation

1. Download the latest release from [GitHub Releases](https://github.com/monuk7735/mew-notch/releases).
2. Move the app to the Applications folder.
3. Run the app and grant necessary permissions if prompted.

> ### <span style="color: yellow">Note!</span>
> I don't have an Apple Developer account yet, so the application will display a popup on the first launch. 
>
> Click Okay, then navigate to **Settings > Privacy & Security**, scroll down, and click **Open Anyway**. 
> 
> This only needs to be done once.

## Usage

1. Launch **MewNotch**.
2. Re-launch to open settings, if required. Notch won't appear at first launch on non-notched devices.
3. Adjust the volume or brightness using Keyboard or Touch Bar.
4. Customise the settings to have notch on different or all monitors.
5. Enjoy the sleek visual feedback right on the notch!

## Roadmap

- [x] ~~Add support for different types of HUD UIs.~~
- [x] ~~Allow users to toggle usage of each HUD variant.~~
- [x] ~~Icon in Menu bar to show app's running status.~~
- [x] ~~Add Touch bar support.~~
- [x] ~~Now playing music HUD.~~
- [x] ~~Actions on Now Playing HUD. Hover to see magic.~~
- [x] ~~Now Playing Detail on Expanded Notch View.~~
- [x] ~~Expand notch on hover.~~
- [x] ~~Mirror View~~
- [x] ~~Complete Control over which monitor shows the notch~~
- [ ] Explore different options for Now Playing media support on macOS 15.4 and above.
- [ ] Explore additional notch-based utilities.

## Dependency
- [Lottie](https://github.com/airbnb/lottie-ios)
- [LaunchAtLogin-Modern](https://github.com/sindresorhus/LaunchAtLogin-Modern)

## Contributing

Contributions are welcome! Feel free to open issues or submit pull requests.

## License

This project is licensed under the [GPLv3 License](LICENSE).

## Acknowledgments

- Inspired by the idea of making the Mac notch actually useful!
- Built with ♥️ using Swift and SwiftUI.
- Special thanks to the following GitHub repositories for their code and inspiration:
  - [SlimHUD](https://github.com/AlexPerathoner/SlimHUD)
  - [boring.notch](https://github.com/TheBoredTeam/boring.notch)

