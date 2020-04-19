import Foundation
import AppKit

extension SyntaxTextView: InnerTextViewDelegate {

	func didUpdateCursorFloatingState() {
		selectionDidChange()
	}
}

extension SyntaxTextView {

	func isEditorPlaceholderSelected(selectedRange: NSRange, tokenRange: NSRange) -> Bool {
		var intersectionRange = tokenRange
		intersectionRange.location += 1
		intersectionRange.length -= 1
		return selectedRange.intersection(intersectionRange) != nil
	}

	func updateSelectedRange(_ range: NSRange) {
		textView.selectedRange = range
		self.textView.scrollRangeToVisible(range)
		self.delegate?.didChangeSelectedRange(self, selectedRange: range)
	}

	func selectionDidChange() {

		guard let delegate = delegate else {
			return
		}

		if let cachedTokens = cachedTokens {
			updateEditorPlaceholders(cachedTokens: cachedTokens)
		}

		colorTextView(lexerForSource: { (source) -> Lexer in
			return delegate.lexerForSource(source)
		})

		previousSelectedRange = textView.selectedRange
	}

	func updateEditorPlaceholders(cachedTokens: [CachedToken]) {

		for cachedToken in cachedTokens {
			let range = cachedToken.nsRange
			if cachedToken.token.isEditorPlaceholder {
				var forceInsideEditorPlaceholder = true
				let currentSelectedRange = textView.selectedRange
				if let previousSelectedRange = previousSelectedRange {
					if isEditorPlaceholderSelected(selectedRange: currentSelectedRange, tokenRange: range) {
						if previousSelectedRange.location + 1 == currentSelectedRange.location {
							if isEditorPlaceholderSelected(selectedRange: previousSelectedRange, tokenRange: range) {
								updateSelectedRange(NSRange(location: range.location + range.length, length: 0))
							} else {
								updateSelectedRange(NSRange(location: range.location + 1, length: 0))
							}
							forceInsideEditorPlaceholder = false
							break
						}
						if previousSelectedRange.location - 1 == currentSelectedRange.location {
							if isEditorPlaceholderSelected(selectedRange: previousSelectedRange, tokenRange: range) {
								updateSelectedRange(NSRange(location: range.location, length: 0))
							} else {
								updateSelectedRange(NSRange(location: range.location + 1, length: 0))
							}
							forceInsideEditorPlaceholder = false
							break
						}
					}
				}

				if forceInsideEditorPlaceholder {
					if isEditorPlaceholderSelected(selectedRange: currentSelectedRange, tokenRange: range) {
						if currentSelectedRange.location <= range.location || currentSelectedRange.upperBound >= range.upperBound {
							break
						}
						updateSelectedRange(NSRange(location: range.location + 1, length: 0))
						break
					}
				}
			}
		}
	}
}

extension SyntaxTextView: NSTextViewDelegate {

	open func textView(_ textView: NSTextView, shouldChangeTextIn affectedCharRange: NSRange, replacementString: String?) -> Bool {
		let text = replacementString ?? ""
		return self.shouldChangeText(insertingText: text)
	}

	open func textDidChange(_ notification: Notification) {
		guard let textView = notification.object as? NSTextView, textView == self.textView else {
			return
		}
		didUpdateText()
	}

	func didUpdateText() {
		self.invalidateCachedTokens()
		self.textView.invalidateCachedParagraphs()
		if let delegate = delegate {
			colorTextView(lexerForSource: { (source) -> Lexer in
				return delegate.lexerForSource(source)
			})
		}

		wrapperView.setNeedsDisplay(wrapperView.bounds)
		self.delegate?.didChangeText(self)
	}

	open func textViewDidChangeSelection(_ notification: Notification) {
		contentDidChangeSelection()
	}
}

extension SyntaxTextView {

	func shouldChangeText(insertingText: String) -> Bool {
		let selectedRange = textView.selectedRange
		let origInsertingText = insertingText
		var insertingText = insertingText
		if insertingText == "\n" {
			let nsText = textView.text as NSString
			var currentLine = nsText.substring(with: nsText.lineRange(for: textView.selectedRange))

			if currentLine.hasSuffix("\n") {
				currentLine.removeLast()
			}

			var newLinePrefix = ""

			for char in currentLine {
				let tempSet = CharacterSet(charactersIn: "\(char)")
				if tempSet.isSubset(of: .whitespacesAndNewlines) {
					newLinePrefix += "\(char)"
				} else {
					break
				}
			}
			insertingText += newLinePrefix
		}

		let textStorage: NSTextStorage

		guard let _textStorage = textView.textStorage else {
			return true
		}

		textStorage = _textStorage

		guard let cachedTokens = cachedTokens else {
			return true
		}

		for token in cachedTokens {

			let range = token.nsRange

			if token.token.isEditorPlaceholder {
				if insertingText == "", selectedRange.lowerBound == range.upperBound {
					textStorage.replaceCharacters(in: range, with: insertingText)
					didUpdateText()
					updateSelectedRange(NSRange(location: range.lowerBound, length: 0))
					return false
				}

				if isEditorPlaceholderSelected(selectedRange: selectedRange, tokenRange: range) {
					if insertingText == "\t" {
						let placeholderTokens = cachedTokens.filter({
							$0.token.isEditorPlaceholder
						})

						guard placeholderTokens.count > 1 else {
							return false
						}

						let nextPlaceholderToken = placeholderTokens.first(where: {
							let nsRange = $0.nsRange
							return nsRange.lowerBound > range.lowerBound
						})

						if let tokenToSelect = nextPlaceholderToken ?? placeholderTokens.first {
							updateSelectedRange(NSRange(location: tokenToSelect.nsRange.lowerBound + 1, length: 0))
							return false
						}
						return false
					}

					if selectedRange.location <= range.location || selectedRange.upperBound >= range.upperBound {
						return true
					}

					textStorage.replaceCharacters(in: range, with: insertingText)
					didUpdateText()
					updateSelectedRange(NSRange(location: range.lowerBound + insertingText.count, length: 0))
					return false
				}
			}
		}

		if origInsertingText == "\n" {
			textStorage.replaceCharacters(in: selectedRange, with: insertingText)
			didUpdateText()
			updateSelectedRange(NSRange(location: selectedRange.lowerBound + insertingText.count, length: 0))
			return false
		}
		return true
	}

	func contentDidChangeSelection() {

		if ignoreSelectionChange {
			return
		}

		ignoreSelectionChange = true
		selectionDidChange()
		ignoreSelectionChange = false
	}
}
