import Foundation
import AppKit

private let kFont: NSFont? = NSFont(name: "Menlo", size: 12)

public struct SwiftSourceCodeTheme: SourceCodeTheme {

	public init() {
	}

	private static var lineNumbersColor: Color {
		return NSColor(named: "texteditor-line-numbers-color")!
	}

	public let lineNumbersStyle: LineNumbersStyle? = LineNumbersStyle(font: kFont!, textColor: lineNumbersColor)
	public let gutterStyle: GutterStyle = GutterStyle(backgroundColor: NSColor.clear, minimumWidth: 32)
	public let font = kFont!
	public let backgroundColor = NSColor(named: "texteditor-backround-color")!

	public func color(for syntaxColorType: SourceCodeTokenType) -> Color {
		switch syntaxColorType {
		case .plain:
			return NSColor(named: "texteditor-plain-color")!
		case .number:
			return NSColor(named: "texteditor-number-color")!
		case .string:
			return NSColor(named: "texteditor-string-color")!
		case .identifier:
			return NSColor(named: "texteditor-identifier-color")!
		case .keyword:
			return NSColor(named: "texteditor-keyword-color")!
		case .comment:
			return NSColor(named: "texteditor-comment-color")!
		case .editorPlaceholder:
			return NSColor(named: "texteditor-editor-placeholder-color")!
		}
	}
}
