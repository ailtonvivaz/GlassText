//
//  GlassText.swift
//  GlassText
//
//  Created by Ailton Vieira on 17/08/25.
//

@preconcurrency import CoreText
import SwiftUI

/// A SwiftUI view that renders text with a glass morphism effect
@available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, *)
@available(visionOS, unavailable)
public struct GlassText: View {
    let text: String
    let glass: Glass

    @Environment(\.font) private var font
    @Environment(\.fontResolutionContext) private var fontResolutionContext
    @Environment(\.multilineTextAlignment) private var multilineTextAlignment

    /// Main initializer
    public init(
        _ text: String,
        glass: Glass = .clear
    ) {
        self.text = text
        self.glass = glass
    }

    /// Initializer with LocalizedStringResource
    public init(
        _ text: LocalizedStringResource,
        glass: Glass = .clear
    ) {
        self.text = String(localized: text)
        self.glass = glass
    }

    public var body: some View {
        let resolved = (font ?? .body).resolve(in: fontResolutionContext)
        let ctFont = resolved.ctFont
        let shape = TextOutlineShape(
            text: text,
            ctFont: ctFont,
            fontSize: resolved.pointSize,
            alignment: multilineTextAlignment
        )
        let bounds = textBounds(for: ctFont, fontSize: resolved.pointSize)

        Rectangle()
            .fill(.clear)
            .glassEffect(glass, in: shape)
            .frame(width: bounds.width, height: bounds.height)
    }

    /// Calculates the required size for multi-line text
    private func textBounds(for ctFont: CTFont, fontSize: CGFloat) -> CGSize {
        let lines = text.components(separatedBy: CharacterSet.newlines)
        let ascent = CTFontGetAscent(ctFont)
        let descent = CTFontGetDescent(ctFont)
        let leading = CTFontGetLeading(ctFont)
        let lineHeight = ascent + descent + max(leading, fontSize * 0.2)

        var maxWidth: CGFloat = 0
        let attrKey = kCTFontAttributeName as NSAttributedString.Key
        for l in lines {
            let attr = [attrKey: ctFont]
            let astr = NSAttributedString(string: l, attributes: attr)
            let ctLine = CTLineCreateWithAttributedString(astr)
            let w = CGFloat(CTLineGetTypographicBounds(ctLine, nil, nil, nil))
            maxWidth = max(maxWidth, w)
        }
        let totalHeight = lineHeight * CGFloat(lines.count)
        return CGSize(width: maxWidth, height: totalHeight)
    }
}

@available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, *)
@available(visionOS, unavailable)
#Preview {
    ScrollView {
        LazyVStack(spacing: 20) {
            VStack(spacing: 15) {
                Text("Font Designs")
                    .font(.headline)
                    .padding(8)
                    .glassEffect()

                GlassText("Default")
                    .font(.system(size: 40))
                    .fontDesign(.default)
                GlassText("Serif")
                    .font(.system(size: 40))
                    .fontDesign(.serif)
                GlassText("Monospaced")
                    .font(.system(size: 40))
                    .fontDesign(.monospaced)
                GlassText("Rounded")
                    .font(.system(size: 40))
                    .fontDesign(.rounded)
            }

            VStack(spacing: 15) {
                Text("Font Weights")
                    .font(.headline)
                    .padding(8)
                    .glassEffect()

                GlassText("Light")
                    .font(.system(size: 36).weight(.light))
                    .fontDesign(.rounded)
                GlassText("Bold")
                    .font(.system(size: 36).weight(.bold))
                    .fontDesign(.rounded)
                GlassText("Heavy")
                    .font(.system(size: 36).weight(.heavy))
                    .fontDesign(.rounded)
            }
        }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background {
        AsyncImage(
            url: URL(string: "https://place.abh.ai/s3fs-public/placeholder/DSC_0287_400x400.JPG")!
        ) { image in
            image.resizable()
                .scaledToFill()
                .ignoresSafeArea()

        } placeholder: {
            Color.gray.opacity(0.2)
        }
    }
}
