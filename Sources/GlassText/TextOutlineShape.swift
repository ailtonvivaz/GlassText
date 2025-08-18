//
//  TextOutlineShape.swift
//  GlassText
//
//  Created by Ailton Vieira on 17/08/25.
//

import CoreGraphics
@preconcurrency import CoreText
import SwiftUI

/// A SwiftUI Shape that creates text outline paths for glass morphism effects
struct TextOutlineShape: Shape {
    var text: String
    var ctFont: CTFont
    var fontSize: CGFloat
    var alignment: TextAlignment = .center

    func path(in rect: CGRect) -> Path {
        // Split into explicit lines (no wrapping here)
        let rawLines = text.components(separatedBy: CharacterSet.newlines)

        // Pre-create CTLine objects to leverage CoreText shaping for complex scripts
        var ctLines: [CTLine] = []
        ctLines.reserveCapacity(rawLines.count)

        let attrKey = kCTFontAttributeName as NSAttributedString.Key
        for l in rawLines {
            let attr = [attrKey: ctFont]
            let astr = NSAttributedString(string: l, attributes: attr)
            let line = CTLineCreateWithAttributedString(astr)
            ctLines.append(line)
        }

        // Metrics (we still stack lines with a uniform height derived from base font)
        let ascent = CTFontGetAscent(ctFont)
        let descent = CTFontGetDescent(ctFont)
        let leading = CTFontGetLeading(ctFont)
        let lineHeight = ascent + descent + max(leading, CTFontGetSize(ctFont) * 0.2)

        // Determine widths using typographic bounds for each CTLine (better for scripts & ligatures)
        var lineWidths: [CGFloat] = []
        var maxWidth: CGFloat = 0
        for line in ctLines {
            let w = CGFloat(CTLineGetTypographicBounds(line, nil, nil, nil))
            lineWidths.append(w)
            maxWidth = max(maxWidth, w)
        }

        // Build combined path aggregating each run's glyphs & positions
        let combined = CGMutablePath()
        for (idx, line) in ctLines.enumerated() {
            // Position baseline for this line (stack downward later flipped)
            let penY = -CGFloat(idx) * lineHeight
            let lineWidth = lineWidths[idx]

            // Alignment offset
            let startX: CGFloat
            switch alignment {
                case .leading: startX = 0
                case .center: startX = (maxWidth - lineWidth) / 2
                case .trailing: startX = maxWidth - lineWidth
            }

            // Iterate glyph runs (handles complex scripts, clusters & ligatures)
            let runs = CTLineGetGlyphRuns(line) as NSArray
            for runObj in runs {
                let run = runObj as! CTRun // Safe cast (CoreFoundation bridging)
                let glyphCount = CTRunGetGlyphCount(run)
                if glyphCount == 0 { continue }

                // Extract glyphs & positions
                var glyphs = Array(repeating: CGGlyph(), count: glyphCount)
                var positions = Array(repeating: CGPoint.zero, count: glyphCount)
                CTRunGetGlyphs(run, CFRange(location: 0, length: 0), &glyphs)
                CTRunGetPositions(run, CFRange(location: 0, length: 0), &positions)

                // Run font (may differ due to fallback)
                let attrs = CTRunGetAttributes(run) as NSDictionary
                let runFont = (attrs[kCTFontAttributeName] as! CTFont)

                for i in 0 ..< glyphCount {
                    let g = glyphs[i]
                    guard let gPath = CTFontCreatePathForGlyph(runFont, g, nil) else { continue }
                    var t = CGAffineTransform(
                        translationX: startX + positions[i].x,
                        y: penY + positions[i].y
                    )
                    if let shifted = gPath.copy(using: &t) {
                        combined.addPath(shifted)
                    }
                }
            }
        }

        if combined.isEmpty { return Path() }

        // Normalize & center similar to previous approach
        let bbox = combined.boundingBoxOfPath
        var toOrigin = CGAffineTransform(translationX: -bbox.minX, y: -bbox.minY)
        let norm = combined.copy(using: &toOrigin) ?? combined
        var flip = CGAffineTransform(scaleX: 1, y: -1)
        let flipped = norm.copy(using: &flip) ?? norm
        let finalBBox = flipped.boundingBoxOfPath
        var centerT = CGAffineTransform(
            translationX: rect.midX - finalBBox.midX,
            y: rect.midY - finalBBox.midY
        )
        let finalCG = flipped.copy(using: &centerT) ?? flipped
        return Path(finalCG)
    }
}
