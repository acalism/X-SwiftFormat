//
//  SourcePreviewWindow.swift
//  X-SwiftFormat
//
//  Created by Rui Aureliano on 27/03/2020.
//  Copyright © 2020 Rui Aureliano. All rights reserved.
//

import Cocoa
import SwiftFormat
import SwiftFormatConfiguration

class SourcePreviewWindow: NSWindow {

	private var code: String = ""
	private var configuration: [String: Any] = ["version": 1]

	@IBOutlet weak var sourcePreviewView: SyntaxTextView!

	override func awakeFromNib() {
		super.awakeFromNib()
		if let filepath = Bundle.main.path(forResource: "sample", ofType: "txt") {
			do {
				self.code = try String(contentsOfFile: filepath)
			} catch {
			}
		}
		sourcePreviewView.theme = SwiftSourceCodeTheme()
		sourcePreviewView.delegate = self
	}

	func loadConfiguration(configuration: [String: Any]) {
		self.configuration = configuration
		sourcePreviewView.insertText(code)
	}

	func formatCode() {
		let configuration = Configuration.buildConfiguration(with: self.configuration)
		let swiftFormatter = SwiftFormatter(configuration: configuration)
		var swiftOutputStream = SwiftOutputStream()
		do {
			try swiftFormatter.format(source: sourcePreviewView.text, assumingFileURL: nil, to: &swiftOutputStream)
			if let outputString = swiftOutputStream.outputString {
				sourcePreviewView.insertText(outputString)
			}
		} catch {
			let alert = NSAlert()
			alert.messageText = "Error"
			alert.informativeText = error.localizedDescription
			alert.alertStyle = .critical
			alert.addButton(withTitle: "OK")
			alert.beginSheetModal(for: self) { (_) in
			}
		}
	}

	override func close() {
		sourcePreviewView.insertText("")
		super.close()
	}

	func showInvisibles(invisibles: Bool) {
		if let layoutManager = sourcePreviewView.textView.layoutManager as? SyntaxTextViewLayoutManager {
			layoutManager.drawInvisibles = invisibles
			sourcePreviewView.textView.needsDisplay = true
		}
	}
}

extension SourcePreviewWindow: SyntaxTextViewDelegate {
	func lexerForSource(_ source: String) -> Lexer {
		return SwiftLexer()
	}
}
