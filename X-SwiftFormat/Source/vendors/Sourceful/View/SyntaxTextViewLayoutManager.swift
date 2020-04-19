import Foundation
import CoreGraphics
import AppKit

public enum EditorPlaceholderState {
	case active
	case inactive
}

public extension NSAttributedString.Key {
	static let editorPlaceholder = NSAttributedString.Key("editorPlaceholder")
}

class SyntaxTextViewLayoutManager: NSLayoutManager {

	var drawInvisibles: Bool = false

	override func drawGlyphs(forGlyphRange glyphsToShow: NSRange, at origin: CGPoint) {
		guard let context = NSGraphicsContext.current else {
			return
		}
		let range = characterRange(forGlyphRange: glyphsToShow, actualGlyphRange: nil)
		var placeholders = [(CGRect, EditorPlaceholderState)]()
		if let textStorage = textStorage {
			textStorage.enumerateAttribute(.editorPlaceholder, in: range, options: [], using: { (value, range, _) in
					if let state = value as? EditorPlaceholderState {
						let glyphRange = self.glyphRange(forCharacterRange: range, actualCharacterRange: nil)
						let container = self.textContainer(forGlyphAt: glyphRange.location, effectiveRange: nil)
						let rect = self.boundingRect(forGlyphRange: glyphRange, in: container ?? NSTextContainer())
						placeholders.append((rect, state))
					}
				})
			context.saveGraphicsState()
			context.cgContext.translateBy(x: origin.x, y: origin.y)

			for (rect, state) in placeholders {
				let color: Color
				switch state {
				case .active:
					color = Color.white.withAlphaComponent(0.8)
				case .inactive:
					color = .darkGray
				}

				color.setFill()
				let radius: CGFloat = 4.0
				let path = BezierPath(roundedRect: rect, xRadius: radius, yRadius: radius)
				path.fill()
			}

			if drawInvisibles {
				let completeString = textStorage.string
				let lengthToRedraw = NSMaxRange(glyphsToShow)
				let textFontAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: NSColor(named: "texteditor-invisibles-color") as Any]

				for index in glyphsToShow.location..<lengthToRedraw {
					let characterToCheck = completeString[completeString.index(completeString.startIndex, offsetBy: index)]
					if characterToCheck == "\t" {
						var pointToDrawAt = self.location(forGlyphAt: index)
						let glyphFragment = self.lineFragmentRect(forGlyphAt: index, effectiveRange: nil)
						pointToDrawAt.x += glyphFragment.origin.x
						pointToDrawAt.y = glyphFragment.origin.y
						"≫".draw(at: pointToDrawAt, withAttributes: textFontAttributes)
					} else if characterToCheck == "\n" {
						var pointToDrawAt = self.location(forGlyphAt: index)
						let glyphFragment = self.lineFragmentRect(forGlyphAt: index, effectiveRange: nil)
						pointToDrawAt.x += glyphFragment.origin.x
						pointToDrawAt.y = glyphFragment.origin.y
						"¬".draw(at: pointToDrawAt, withAttributes: textFontAttributes)
					} else if characterToCheck == " " {
						var pointToDrawAt = self.location(forGlyphAt: index)
						let glyphFragment = self.lineFragmentRect(forGlyphAt: index, effectiveRange: nil)
						pointToDrawAt.x += glyphFragment.origin.x
						pointToDrawAt.y = glyphFragment.origin.y
						"∙".draw(at: pointToDrawAt, withAttributes: textFontAttributes)
					}
				}
			}
			context.restoreGraphicsState()
		}
		super.drawGlyphs(forGlyphRange: glyphsToShow, at: origin)
	}
}
