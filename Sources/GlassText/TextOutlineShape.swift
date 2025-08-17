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
        let combined = CGMutablePath()
        let lines = text.components(separatedBy: CharacterSet.newlines)
        let ascent = CTFontGetAscent(ctFont)
        let descent = CTFontGetDescent(ctFont)
        let leading = CTFontGetLeading(ctFont)
        let lineHeight = ascent + descent + max(leading, CTFontGetSize(ctFont) * 0.2)  // Ensure minimum spacing
        
        // First step: calculate width of each line
        var lineWidths: [CGFloat] = []
        var maxWidth: CGFloat = 0
        
        for line in lines {
            var lineWidth: CGFloat = 0
            for scalar in line.unicodeScalars {
                var glyph = CGGlyph()
                var u = UniChar(scalar.value)
                let ok = CTFontGetGlyphsForCharacters(ctFont, &u, &glyph, 1)
                guard ok else { continue }
                
                var adv = CGSize.zero
                CTFontGetAdvancesForGlyphs(ctFont, .horizontal, [glyph], &adv, 1)
                lineWidth += adv.width
            }
            lineWidths.append(lineWidth)
            maxWidth = max(maxWidth, lineWidth)
        }
        
        // Second step: position each line based on alignment
        for (lineIndex, line) in lines.enumerated() {
            guard !line.isEmpty else { continue }
            
            let lineWidth = lineWidths[lineIndex]
            let penY = -CGFloat(lineIndex) * lineHeight
            
            // Calculate X offset based on alignment
            var startX: CGFloat = 0
            switch alignment {
            case .leading:
                startX = 0
            case .center:
                startX = (maxWidth - lineWidth) / 2
            case .trailing:
                startX = maxWidth - lineWidth
            }
            
            var penX: CGFloat = startX
            
            for scalar in line.unicodeScalars {
                var glyph = CGGlyph()
                var u = UniChar(scalar.value)
                let ok = CTFontGetGlyphsForCharacters(ctFont, &u, &glyph, 1)
                guard ok, let g = CTFontCreatePathForGlyph(ctFont, glyph, nil) else { continue }
                
                var adv = CGSize.zero
                CTFontGetAdvancesForGlyphs(ctFont, .horizontal, [glyph], &adv, 1)
                
                var t = CGAffineTransform(translationX: penX, y: penY)
                if let shifted = g.copy(using: &t) {
                    combined.addPath(shifted)
                }
                penX += adv.width
            }
        }
        
        if combined.isEmpty { return Path() }
        
        // Bounding box of the actual path
        let bbox = combined.boundingBoxOfPath
        
        // Normalize to origin (without scaling)
        var toOrigin = CGAffineTransform(translationX: -bbox.minX, y: -bbox.minY)
        let norm = combined.copy(using: &toOrigin) ?? combined
        
        // Flip Y axis for SwiftUI coordinate system
        var flip = CGAffineTransform(scaleX: 1, y: -1)
        let flipped = norm.copy(using: &flip) ?? norm
        
        // Now center based on already flipped bbox
        let finalBBox = flipped.boundingBoxOfPath
        var centerT = CGAffineTransform(
            translationX: rect.midX - finalBBox.midX,
            y: rect.midY - finalBBox.midY
        )
        let finalCG = flipped.copy(using: &centerT) ?? flipped
        
        // Return the basic text outline path
        return Path(finalCG)
    }
}
