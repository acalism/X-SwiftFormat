//
//  Configuration+Extension.swift
//  X-SwiftFormat
//
//  Created by Rui Aureliano on 29/03/2020.
//  Copyright © 2020 Rui Aureliano. All rights reserved.
//

import Cocoa
import SwiftFormatConfiguration

extension Configuration {

	class func buildConfiguration(with configuration: [String: Any]) -> Configuration {
		let _configuration = Configuration()

		if let lineLength = configuration["lineLength"] as? Int {
			_configuration.lineLength = lineLength
		}
		if let indentation = configuration["indentation"] as? [String: Any] {
			if let spaces = indentation["spaces"] as? Int {
				_configuration.indentation = Indent.spaces(spaces)
			} else if let tabs = indentation["tabs"] as? Int {
				_configuration.indentation = Indent.tabs(tabs)
			}
		}
		if let tabWidth = configuration["tabWidth"] as? Int {
			_configuration.tabWidth = tabWidth
		}
		if let maximumBlankLines = configuration["maximumBlankLines"] as? Int {
			_configuration.maximumBlankLines = maximumBlankLines
		}
		if let respectsExistingLineBreaks = configuration["respectsExistingLineBreaks"] as? Bool {
			_configuration.respectsExistingLineBreaks = respectsExistingLineBreaks
		}
		if let lineBreakBeforeControlFlowKeywords = configuration["lineBreakBeforeControlFlowKeywords"] as? Bool {
			_configuration.lineBreakBeforeControlFlowKeywords = lineBreakBeforeControlFlowKeywords
		}
		if let lineBreakBeforeEachArgument = configuration["lineBreakBeforeEachArgument"] as? Bool {
			_configuration.lineBreakBeforeEachArgument = lineBreakBeforeEachArgument
		}
		/* NOT SUPORTED FOR 5.1 */
		/* if let prioritizeKeepingFunctionOutputTogether = configuration["prioritizeKeepingFunctionOutputTogether"] as? Bool {
			_configuration.prioritizeKeepingFunctionOutputTogether = prioritizeKeepingFunctionOutputTogether
		} */
		if let indentConditionalCompilationBlocks = configuration["indentConditionalCompilationBlocks"] as? Bool {
			_configuration.indentConditionalCompilationBlocks = indentConditionalCompilationBlocks
		}
		/* NOT SUPORTED FOR 5.1 */
		/* if let lineBreakAroundMultilineExpressionChainComponents = configuration["lineBreakAroundMultilineExpressionChainComponents"] as? Bool {
			_configuration.lineBreakAroundMultilineExpressionChainComponents = lineBreakAroundMultilineExpressionChainComponents
		} */
		return _configuration
	}
}
