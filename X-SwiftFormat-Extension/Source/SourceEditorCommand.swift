//
//  SourceEditorCommand.swift
//  X-SwiftFormat-Extension
//
//  Created by Rui Aureliano on 28/03/2020.
//  Copyright © 2020 Rui Aureliano. All rights reserved.
//

import Foundation
import XcodeKit
import SwiftFormat
import SwiftFormatConfiguration

private let kErrorNotSwift = NSError(domain: "Not a Swift file", code: -1001, userInfo: nil)

class SourceEditorCommand: NSObject, XCSourceEditorCommand {

	private var configuration: [String: Any] = ["version": 1]

	let supportedUTIs = [
		"public.swift-source",
		"com.apple.dt.playground",
		"com.apple.dt.playgroundpage",
		"com.apple.dt.swiftpm-package-manifest"
	]

    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) {
		if let configuration = UserDefaults.loadConfiguration() {
			self.configuration = configuration
		}
		let uti = invocation.buffer.contentUTI
		let lines = invocation.buffer.lines

		if supportedUTIs.contains(uti) {
			DispatchQueue.main.async {
				let configuration = Configuration.buildConfiguration(with: self.configuration)
				let swiftFormatter = SwiftFormatter(configuration: configuration)
				var swiftOutputStream = SwiftOutputStream()
				do {
					try swiftFormatter.format(source: invocation.buffer.completeBuffer, assumingFileURL: nil, to: &swiftOutputStream)
					if let outputString = swiftOutputStream.outputString {
						lines.removeAllObjects()
						lines.add(outputString)
					}
				} catch {
					completionHandler(error)
				}
				completionHandler(nil)
			}
		} else {
			completionHandler(kErrorNotSwift as Error)
		}
    }
}
