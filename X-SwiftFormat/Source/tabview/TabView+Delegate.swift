//
//  TabView+Delegate.swift
//  X-SwiftFormat
//
//  Created by Rui Aureliano on 27/03/2020.
//  Copyright © 2020 Rui Aureliano. All rights reserved.
//

import Cocoa

extension TabView: NSTextFieldDelegate {

	func controlTextDidChange(_ obj: Notification) {
		if let textfield = obj.object as? NSTextField {
			if textfield == lineLengthField {
				if let value = Int(textfield.stringValue) {
					lineLengthStepper.integerValue = value
				} else {
					textfield.stringValue = "\(1)"
					lineLengthStepper.integerValue = 1
				}
			} else if textfield == indentationField {
				if let value = Int(textfield.stringValue) {
					indentationStepper.integerValue = value
				} else {
					textfield.stringValue = "\(1)"
					indentationStepper.integerValue = 1
				}
			} else if textfield == tabWidthField {
				if let value = Int(textfield.stringValue) {
					tabWidthStepper.integerValue = value
				} else {
					textfield.stringValue = "\(1)"
					tabWidthStepper.integerValue = 1
				}
			} else if textfield == maximumBlankLinesField {
				if let value = Int(textfield.stringValue) {
					maximumBlankLinesStepper.integerValue = value
				} else {
					textfield.stringValue = "\(1)"
					maximumBlankLinesStepper.integerValue = 1
				}
			}
			updateConfiguration()
		}
	}
}
