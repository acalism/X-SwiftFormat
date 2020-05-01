//
//  SourceEditorCommand.swift
//  X-SwiftFormat-Extension
//
//  Created by Rui Aureliano on 01/04/2020.
//  Copyright © 2020 Rui Aureliano. All rights reserved.
//

import Foundation
import SwiftFormat
import SwiftFormatConfiguration
import XcodeKit

private let kErrorNotSwift = NSError(domain: "Not a Swift file", code: -1001, userInfo: nil)

class SourceEditorCommand: NSObject, XCSourceEditorCommand {

	let supportedUTIs = [
		"public.swift-source",
		"com.apple.dt.playground",
		"com.apple.dt.playgroundpage",
		"com.apple.dt.swiftpm-package-manifest"
	]

	func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void) {

		let uti = invocation.buffer.contentUTI
		if supportedUTIs.contains(uti) {
			formatBuffer(with: invocation) { error in
				DispatchQueue.main.async {
					completionHandler(error)
				}
			}
		} else {
			completionHandler(kErrorNotSwift as Error)
		}
	}

	private func formatBuffer(with invocation: XCSourceEditorCommandInvocation, completion: @escaping (_ error: Error?) -> Void) {
		DispatchQueue.global(qos: .background).async {

			let sharedConfiguration = UserDefaults.configuration
			let sharedRules = UserDefaults.rules

			var configuration = Configuration.buildConfiguration(with: sharedConfiguration)
			for rule in sharedRules {
				configuration.rules[rule.key] = rule.value
			}

			let swiftFormatter = SwiftFormatter(configuration: configuration)
			var swiftFormatOutputStream = SwiftFormatOutputStream()

			do {
				try swiftFormatter.format(source: invocation.buffer.completeBuffer, assumingFileURL: nil, to: &swiftFormatOutputStream)
				if let output = swiftFormatOutputStream.output {
					if invocation.buffer.completeBuffer != output {
						invocation.buffer.completeBuffer = output
					}
				}
				completion(nil)
			} catch {
				completion(error)
			}
		}
	}
}
