import Foundation
import AppKit

class LineNumberLayoutManager: NSLayoutManager {

	var lastParaLocation = 0
	var lastParaNumber = 0

	func _paraNumber(for charRange: NSRange) -> Int {
		if charRange.location == lastParaLocation {
			return lastParaNumber
		} else if charRange.location < lastParaLocation {
			let s = textStorage?.string
			var paraNumber: Int = lastParaNumber
			(s as NSString?)?.enumerateSubstrings(
				in: NSRange(location: Int(charRange.location),
					length: Int(lastParaLocation - charRange.location)),
				options: [.byParagraphs, .substringNotRequired, .reverse],
				using: { (_ substring: String?, _ substringRange: NSRange, _ enclosingRange: NSRange, _ stop: UnsafeMutablePointer<ObjCBool>?) -> Void in
					if enclosingRange.location <= charRange.location {
						stop?.pointee = true
					}
					paraNumber -= 1
				})
			lastParaLocation = charRange.location
			lastParaNumber = paraNumber
			return paraNumber
		} else {
			let s = textStorage?.string
			var paraNumber: Int = lastParaNumber
			(s as NSString?)?.enumerateSubstrings(
				in: NSRange(location: lastParaLocation,
					length: Int(charRange.location - lastParaLocation)),
				options: [.byParagraphs, .substringNotRequired],
				using: { (_ substring: String?, _ substringRange: NSRange, _ enclosingRange: NSRange, _ stop: UnsafeMutablePointer<ObjCBool>?) -> Void in
					if enclosingRange.location >= charRange.location {
						stop?.pointee = true
					}
					paraNumber += 1
				})
			lastParaLocation = charRange.location
			lastParaNumber = paraNumber
			return paraNumber
		}
	}

	override func processEditing(
		for textStorage: NSTextStorage,
		edited editMask: NSTextStorageEditActions,
		range newCharRange: NSRange,
		changeInLength delta: Int,
		invalidatedRange invalidatedCharRange: NSRange) {
		super.processEditing(for: textStorage, edited: editMask, range: newCharRange, changeInLength: delta, invalidatedRange: invalidatedCharRange)
		if invalidatedCharRange.location < lastParaLocation {
			lastParaLocation = 0
			lastParaNumber = 0
		}
	}

	var gutterWidth: CGFloat = 0.0

	override func drawBackground(forGlyphRange glyphsToShow: NSRange, at origin: CGPoint) {
		super.drawBackground(forGlyphRange: glyphsToShow, at: origin)
		let atts: [NSAttributedString.Key: Any] = [:
				//.font: style.font,
			//.foregroundColor : style.textColor
		]

		var gutterRect: CGRect = .zero
		var paraNumber: Int = 0

		enumerateLineFragments(
			forGlyphRange: glyphsToShow,
			using: { (_ rect: CGRect, _ usedRect: CGRect, _ textContainer: NSTextContainer?, _ glyphRange: NSRange, _ stop: UnsafeMutablePointer<ObjCBool>?) -> Void in

				let charRange: NSRange = self.characterRange(forGlyphRange: glyphRange, actualGlyphRange: nil)
				let paraRange: NSRange? = (self.textStorage?.string as NSString?)?.paragraphRange(for: charRange)

				if charRange.location == paraRange?.location {
					gutterRect = CGRect(x: 0, y: rect.origin.y, width: self.gutterWidth, height: rect.size.height).offsetBy(dx: origin.x, dy: origin.y)
					paraNumber = self._paraNumber(for: charRange)
					let ln = "\(Int(UInt(paraNumber)) + 1)"
					let size: CGSize = ln.size(withAttributes: atts)
					ln.draw(in: gutterRect.offsetBy(dx: gutterRect.width - 4 - size.width, dy: 0), withAttributes: atts)
				}
			})
		if self.textStorage!.string.isEmpty || self.textStorage!.string.hasSuffix("\n") {
			let ln = "\(Int(UInt(paraNumber)) + 2)"
			let size: CGSize = ln.size(withAttributes: atts)
			gutterRect = gutterRect.offsetBy(dx: 0.0, dy: gutterRect.height)
			ln.draw(in: gutterRect.offsetBy(dx: gutterRect.width - 4 - size.width, dy: 0), withAttributes: atts)
		}

		let rect = BezierPath(rect: CGRect(x: 0, y: 0, width: 200, height: 500))
		Color.red.withAlphaComponent(0.5).setFill()
		rect.fill()
	}
}
