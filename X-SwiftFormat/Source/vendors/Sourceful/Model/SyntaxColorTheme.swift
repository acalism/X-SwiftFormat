import Foundation
import CoreGraphics

public struct LineNumbersStyle {

	public let font: Font
	public let textColor: Color

	public init(font: Font, textColor: Color) {
		self.font = font
		self.textColor = textColor
	}
}

public struct GutterStyle {

	public let backgroundColor: Color
	public let minimumWidth: CGFloat

	public init(backgroundColor: Color, minimumWidth: CGFloat) {
		self.backgroundColor = backgroundColor
		self.minimumWidth = minimumWidth
	}
}

public protocol SyntaxColorTheme {
	var lineNumbersStyle: LineNumbersStyle? { get }
	var gutterStyle: GutterStyle { get }
	var font: Font { get }
	var backgroundColor: Color { get }
	func globalAttributes() -> [NSAttributedString.Key: Any]
	func attributes(for token: Token) -> [NSAttributedString.Key: Any]
}
