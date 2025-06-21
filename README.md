<div style="display: flex; align-items: center; justify-content: center; flex-direction: column; gap: 10px; padding-bottom: 10px;">

  <div
    style="display: flex; align-items: center;"
  >
    <img src=".github/res/MewNotch-Logo.png" width="180" alt="MewNotch Logo"/>
    <div
    style="display: flex; flex-direction: column;"
  >
  <h3 style="font-size: 2.5rem; letter-spacing: 1px;">MewNotch</h3>
  <p style="font-size: 1.15rem; max-width: 600px; font-weight: 500;">
    <strong>Make the Mac Notch Actually Useful!</strong><br>
    MewNotch is a free, open-source macOS app that transforms the notch into a customizable HUD for brightness, volume, power, and more. Minimal, beautiful, and privacy-friendly.
  </p>


  </div>
  </div>
  <br>
  
  [![GitHub License](https://img.shields.io/github/license/monuk7735/mew-notch)](LICENSE)
  [![Downloads](https://img.shields.io/github/downloads/monuk7735/mew-notch/total.svg)](https://github.com/monuk7735/mew-notch/releases)
  [![Issues](https://img.shields.io/github/issues/monuk7735/mew-notch.svg)](https://github.com/monuk7735/mew-notch/issues)
  [![Pull Requests](https://img.shields.io/github/issues-pr/monuk7735/mew-notch.svg)](https://github.com/monuk7735/mew-notch/pulls)
  [![macOS Version](https://img.shields.io/badge/macOS-14.0%2B-blue.svg)](https://www.apple.com/macos/)
  <!-- [![Subreddit subscribers](https://img.shields.io/reddit/subreddit-subscribers/MewNotch?style=flat&label=Join%20r%2FMewNotch)](https://www.reddit.com/r/MewNotch/) -->

  <a href="https://github.com/monuk7735/mew-notch/releases"><img src=".github/res/macOS-Download.png" width="160" alt="Download for macOS"/></a>

</div>

<img src=".github/res/Screenshot.png" width="100%" alt="MewNotch Preview" style="border-radius: 12px;"/>

## Features

- **Brightness Display** - Displays brightness adjustments in real-time, including optional auto-brightness changes.
- **Sound Level Display** - Shows input/output volume changes directly on the notch.
- **Sound Device** - Shows current input/output device on notch, when changed.
- **Power State** - Show current power source as well as left time on battery when available.
- **Notch on Lock Screen** - The notch HUD is now visible even on the macOS lock screen.
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
- [ ] HUD for displaying keyboard backlight changes.
- [ ] Shelf for files in expanded notch view.
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
- Some parts built with 😭 using Objective-C for system integration.
- Special thanks to the following GitHub repositories for their code and inspiration:
  - [SlimHUD](https://github.com/AlexPerathoner/SlimHUD)
  - [SkyLightWindow](https://github.com/Lakr233/SkyLightWindow)
  - [EnergyBar](https://github.com/billziss-gh/EnergyBar)
  - [boring.notch](https://github.com/TheBoredTeam/boring.notch)

