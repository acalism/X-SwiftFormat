import Foundation
import CoreGraphics
import AppKit

protocol InnerTextViewDelegate: class {
	func didUpdateCursorFloatingState()
}

class InnerTextView: TextView {

	weak var innerDelegate: InnerTextViewDelegate?
	var theme: SyntaxColorTheme?
	var cachedParagraphs: [Paragraph]?

	func invalidateCachedParagraphs() {
		cachedParagraphs = nil
	}

	func hideGutter() {
		gutterWidth = theme?.gutterStyle.minimumWidth ?? 0.0
	}

	func updateGutterWidth(for numberOfCharacters: Int) {
		let leftInset: CGFloat = 4.0
		let rightInset: CGFloat = 4.0
		let charWidth: CGFloat = 10.0
		gutterWidth = max(theme?.gutterStyle.minimumWidth ?? 0.0, CGFloat(numberOfCharacters) * charWidth + leftInset + rightInset)
	}

	var gutterWidth: CGFloat {
		set {
			textContainerInset = NSSize(width: newValue, height: 0)
		}
		get {
			return textContainerInset.width
		}
	}
}
