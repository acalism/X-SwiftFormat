import Foundation
import CoreGraphics
import AppKit

struct Paragraph {

	var rect: CGRect
	let number: Int

	var string: String {
		return "\(number)"
	}

	func attributedString(for style: LineNumbersStyle) -> NSAttributedString {

		let attr = NSMutableAttributedString(string: string)
		let range = NSRange(location: 0, length: attr.length)
		let attributes: [NSAttributedString.Key: Any] = [.font: style.font, .foregroundColor: style.textColor]
		attr.addAttributes(attributes, range: range)
		return attr
	}

	func drawSize(for style: LineNumbersStyle) -> CGSize {
		return attributedString(for: style).size()
	}
}
