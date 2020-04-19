import Foundation

public protocol Token {
	var isEditorPlaceholder: Bool { get }
	var isPlain: Bool { get }
	var range: Range<String.Index> { get }
}

struct CachedToken {
	let token: Token
	let nsRange: NSRange
}
