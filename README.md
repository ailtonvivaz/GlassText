# GlassText

SwiftUI library that creates glass morphism text effects using the latest SwiftUI glass effect API.

## Features

- Glass morphism text rendering via the SwiftUI glass effect
- Font customization (designs: default, serif, monospaced, rounded)
- Font weights from ultraLight to black
- Cross-platform: iOS, macOS, tvOS, watchOS (visionOS not supported)
- Text alignment (leading, center, trailing)
- Localization with LocalizedStringResource
- Easy integration with a simple, modern API
- Performance optimized with Core Text for precise metrics

## Requirements

- iOS 26.0+ / macOS 26.0+ / tvOS 26.0+ / watchOS 26.0+
- Swift 6.2+
- Xcode 26.0+

## Installation

### Swift Package Manager

Add GlassText to your project through Xcode:

1. In Xcode, go to `File` → `Add Package Dependencies`
2. Enter the repository URL: `https://github.com/yourusername/GlassText`
3. Select the version you want to use
4. Add to your target

Or add it to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/yourusername/GlassText", from: "0.1.0")
]
```

## Usage

### Basic Example

```swift
import SwiftUI
import GlassText

struct ContentView: View {
    var body: some View {
        GlassText("Hello, World!", glass: .regular)
            .font(.largeTitle)
            .fontWeight(.bold)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                AsyncImage(url: URL(string: "your-image-url")) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    LinearGradient(
                        gradient: Gradient(colors: [.blue, .purple]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                }
            )
    }
}
```

### Advanced Customization

```swift
GlassText("Custom Glass Text", glass: .regular.tint(.cyan))
    .font(.system(size: 48, weight: .bold, design: .rounded))
    .multilineTextAlignment(.center)
```

### With Glass Effects

```swift
GlassText("Clear Glass", glass: .clear)
    .font(.system(size: 36, weight: .semibold))
    .fontDesign(.serif)

GlassText("Regular Glass", glass: .regular)
    .font(.system(size: 36, weight: .semibold))
    .fontDesign(.serif)

GlassText("Tinted Glass", glass: .regular.tint(.red))
    .font(.system(size: 36, weight: .semibold))
    .fontDesign(.serif)
```

### Localized Text

```swift
GlassText("localized.text.key", glass: .regular) // Uses LocalizedStringResource
    .font(.title)
    .fontWeight(.medium)
```

## API Reference

### Initializers

```swift
// String initializer
public init(
    _ text: String,
    glass: Glass = .clear
)

// LocalizedStringResource initializer
public init(
    _ text: LocalizedStringResource,
    glass: Glass = .clear
)
```

### Parameters

- `text`: The text to display (String or LocalizedStringResource)
- `glass`: The glass effect to apply (default: `.clear`)
  - `.clear` - Clear glass effect
  - `.regular` - Regular glass effect
  - `.regular.tint(.color)` - Regular glass with custom tint color

### Glass Effect Options

```swift
// Clear glass (default)
GlassText("Clear Glass")

// Regular glass
GlassText("Regular Glass", glass: .regular)

// Tinted glass
GlassText("Red Tinted", glass: .regular.tint(.red))
GlassText("Blue Tinted", glass: .regular.tint(.blue))
GlassText("Custom Tinted", glass: .regular.tint(.purple))
```

### Font Customization

GlassText uses SwiftUI's font system. You can customize fonts using standard SwiftUI modifiers:

```swift
GlassText("Your Text")
    .font(.system(size: 32, weight: .bold, design: .rounded))
    .fontDesign(.serif)
    .fontWeight(.heavy)
```

### Text Alignment

```swift
GlassText("Left Aligned", glass: .regular)
    .multilineTextAlignment(.leading)

GlassText("Center Aligned", glass: .regular)
    .multilineTextAlignment(.center)

GlassText("Right Aligned", glass: .regular)
    .multilineTextAlignment(.trailing)
```

### Available Font Weights

- `.ultraLight`
- `.thin`
- `.light`
- `.regular`
- `.medium`
- `.semibold`
- `.bold`
- `.heavy`
- `.black`

### Available Font Designs

- `.default` - System default font
- `.serif` - Serif font family
- `.monospaced` - Monospaced font family
- `.rounded` - Rounded font family

## Examples

### Different Font Designs

```swift
VStack(spacing: 20) {
    GlassText("Default Design", glass: .regular)
        .fontDesign(.default)
    
    GlassText("Serif Design", glass: .regular)
        .fontDesign(.serif)
    
    GlassText("Monospaced Design", glass: .regular)
        .fontDesign(.monospaced)
    
    GlassText("Rounded Design", glass: .regular)
        .fontDesign(.rounded)
}
```

### Different Font Weights

```swift
VStack(spacing: 15) {
    GlassText("Light Weight", glass: .regular)
        .fontWeight(.light)
    
    GlassText("Regular Weight", glass: .regular)
        .fontWeight(.regular)
    
    GlassText("Bold Weight", glass: .regular)
        .fontWeight(.bold)
    
    GlassText("Heavy Weight", glass: .regular)
        .fontWeight(.heavy)
}
```

### Glass Effect Variations

```swift
VStack(spacing: 15) {
    GlassText("Clear Glass")
        .font(.title)
    
    GlassText("Regular Glass", glass: .regular)
        .font(.title)
    
    GlassText("Red Tinted", glass: .regular.tint(.red))
        .font(.title)
    
    GlassText("Blue Tinted", glass: .regular.tint(.blue))
        .font(.title)
    
    GlassText("Purple Tinted", glass: .regular.tint(.purple))
        .font(.title)
}
```

### Multi-line Text

```swift
GlassText("""
Multi-line
Glass Text
Effect
""", glass: .regular)
.font(.system(size: 36, weight: .semibold))
.fontDesign(.serif)
.multilineTextAlignment(.center)
```

### With Background Images

For best results, use GlassText over colorful or textured backgrounds:

```swift
ZStack {
    // Background
    AsyncImage(url: URL(string: "your-background-image-url")) { image in
        image
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
    } placeholder: {
        LinearGradient(
            gradient: Gradient(colors: [.blue, .purple]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    // Glass text
    GlassText("Glass Effect", glass: .regular.tint(.white))
        .font(.system(size: 64, weight: .bold, design: .rounded))
}
```

### Complete Example

```swift
import SwiftUI
import GlassText

struct GlassTextDemo: View {
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                GlassText("Glass 2048", glass: .regular)
                    .font(.system(size: 44))
                    .fontWeight(.heavy)
                    .fontDesign(.rounded)
                
                VStack(spacing: 15) {
                    GlassText("Light", glass: .regular.tint(.cyan))
                        .font(.system(size: 36).weight(.light))
                        .fontDesign(.rounded)
                    
                    GlassText("Bold", glass: .regular.tint(.orange))
                        .font(.system(size: 36).weight(.bold))
                        .fontDesign(.rounded)
                    
                    GlassText("Heavy", glass: .regular.tint(.purple))
                        .font(.system(size: 36).weight(.heavy))
                        .fontDesign(.rounded)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            AsyncImage(url: URL(string: "your-image-url")) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            } placeholder: {
                Color.gray.opacity(0.2)
            }
        }
    }
}
```

## Platform Support

- iOS 26.0+
- macOS 26.0+
- tvOS 26.0+
- watchOS 26.0+
- visionOS (not supported)

## Technical Details

GlassText uses:
- SwiftUI's built-in glass effect API for optimal performance
- Core Text for precise text rendering and measurements
- Swift 6.2 features including `@preconcurrency` for safe concurrency
- Modern SwiftUI font system with full customization support

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Author

Created by Ailton Vieira

## Acknowledgments

- Built with SwiftUI and Core Text
- Uses SwiftUI's native glass effect API (iOS 26.0+)
- Inspired by modern glass morphism design trends
- Optimized for Swift 6.2 and modern concurrency
