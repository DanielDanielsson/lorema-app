# Lorema

A macOS menu bar app that generates Lorem Ipsum text via keyboard shortcuts. Type a trigger word followed by a number and hit space to instantly insert placeholder text into any text field.

## Why Lorem Ipsum?

Lorem Ipsum is the standard placeholder text used by designers and developers when building layouts. Instead of switching to a website to copy/paste dummy text, Lorema lets you generate it inline, wherever you're typing.

## Installation

### Homebrew (recommended)

```bash
brew tap DanielDanielsson/lorema
brew install --cask lorema
```

### From source

```bash
git clone https://github.com/DanielDanielsson/lorema-app.git
cd lorema-app
xcodebuild -project Lorema.xcodeproj -scheme Lorema -configuration Release build
```

The built app will be in `DerivedData/`. Move `Lorema.app` to `/Applications/`.

## Usage

Lorema lives in your menu bar. Once running, type a trigger prefix followed by a word count and press **space** to generate text.

### Lorem mode (starts with "Lorem ipsum dolor sit amet,")

```
lorem50⎵  →  Generates 50 words starting with "Lorem ipsum dolor sit amet,"
lorem10⎵  →  Generates 10 words starting with "Lorem ipsum dolor sit amet,"
```

### Random mode (random Latin words, no fixed start)

```
lora50⎵   →  Generates 50 random Latin words
lora10⎵   →  Generates 10 random Latin words
```

The prefixes (`lorem` and `lora`) are configurable in the Preferences window. Open it from the menu bar icon.

### Word limits

You can generate between 1 and 1000 words at a time.

## Permissions

### Accessibility access

Lorema needs Accessibility permission to detect your keystrokes and insert generated text.

1. Open **System Settings > Privacy & Security > Accessibility**
2. Click the **+** button and add **Lorema**
3. Make sure the toggle is enabled

### Allowing an unsigned app

Since Lorema is not signed with an Apple Developer certificate, macOS will block it on first launch.

**To open it:**

1. Right-click (or Control-click) on Lorema.app
2. Select **Open** from the context menu
3. Click **Open** in the dialog that appears

Alternatively, go to **System Settings > Privacy & Security**, scroll down, and click **Open Anyway** next to the Lorema warning.

You only need to do this once.

## Launch at Login

You can enable "Start Lorema at login" in the Preferences window.

## License

[MIT](LICENSE)
