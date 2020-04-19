//
//  TabView+Actions.swift
//  X-SwiftFormat
//
//  Created by Rui Aureliano on 27/03/2020.
//  Copyright © 2020 Rui Aureliano. All rights reserved.
//

import Cocoa

extension TabView {

	@IBAction func helpBtPress(_ button: NSButton) {
		if let url = URL(string: "https://github.com/apple/swift-format") {
			NSWorkspace.shared.open(url)
		}
	}

	@IBAction func resetBtPress(_ button: NSButton) {

		configuration = [:]

		lineLengthField.stringValue = "\(100)"
		lineLengthStepper.integerValue = 100

		indentationPopup.selectItem(at: 0)
		indentationField.stringValue = "\(2)"
		indentationStepper.integerValue = 2

		tabWidthField.stringValue = "\(8)"
		tabWidthStepper.integerValue = 8

		maximumBlankLinesField.stringValue = "\(1)"
		maximumBlankLinesStepper.integerValue = 1

		respectsExistingLineBreaksSwitch.state = .on
		lineBreakBeforeControlFlowKeywordsSwitch.state = .off
		lineBreakBeforeEachArgumentSwitch.state = .off
		lineBreakBeforeEachGenericRequirementSwitch.state = .off
		prioritizeKeepingFunctionOutputTogetherSwitch.state = .off
		indentConditionalCompilationBlocksSwitch.state = .on
		lineBreakAroundMultilineExpressionChainComponentsSwitch.state = .off

		validateConfiguration()
		validateExport()
		saveUserDefaults()
	}

	@IBAction func previewBtPress(_ button: NSButton) {
		if let appDelegate = self.appDelegate {
			appDelegate.previewWindow.loadConfiguration(configuration: configuration)
			appDelegate.window.beginSheet(appDelegate.previewWindow) { (_) in
			}
		}
	}

	@IBAction func exportBtPress(_ button: NSButton) {
		let savePanel = NSSavePanel()
		savePanel.canCreateDirectories = true
		savePanel.showsTagField = false
		savePanel.nameFieldStringValue = ".swift-format"
		if let appDelegate = self.appDelegate {
			savePanel.beginSheetModal(for: appDelegate.window) { (response) in
				if response.rawValue == 1 {
					if let url = savePanel.url {
						if let json = self.configuration.jsonPretty {
							try? json.write(to: url, atomically: true, encoding: String.Encoding.utf8)
						}
					}
				}
			}
		}
	}

	@IBAction func checkBoxPress(_ checkbox: NSButton) {
		if checkbox == lineLengthCheck {
			lineLengthField.isEnabled = (checkbox.state == .on)
			lineLengthStepper.isEnabled = (checkbox.state == .on)
		} else if checkbox == indentationCheck {
			indentationField.isEnabled = (checkbox.state == .on)
			indentationPopup.isEnabled = (checkbox.state == .on)
			indentationStepper.isEnabled = (checkbox.state == .on)
		} else if checkbox == tabWidthCheck {
			tabWidthField.isEnabled = (checkbox.state == .on)
			tabWidthStepper.isEnabled = (checkbox.state == .on)
		} else if checkbox == maximumBlankLinesCheck {
			maximumBlankLinesField.isEnabled = (checkbox.state == .on)
			maximumBlankLinesStepper.isEnabled = (checkbox.state == .on)
		} else if checkbox == respectsExistingLineBreaksCheck {
			respectsExistingLineBreaksSwitch.isEnabled = (checkbox.state == .on)
		} else if checkbox == lineBreakBeforeControlFlowKeywordsCheck {
			lineBreakBeforeControlFlowKeywordsSwitch.isEnabled = (checkbox.state == .on)
		} else if checkbox == lineBreakBeforeEachArgumentCheck {
			lineBreakBeforeEachArgumentSwitch.isEnabled = (checkbox.state == .on)
		} else if checkbox == lineBreakBeforeEachGenericRequirementCheck {
			lineBreakBeforeEachGenericRequirementSwitch.isEnabled = (checkbox.state == .on)
		} else if checkbox == prioritizeKeepingFunctionOutputTogetherCheck {
			prioritizeKeepingFunctionOutputTogetherSwitch.isEnabled = (checkbox.state == .on)
		} else if checkbox == indentConditionalCompilationBlocksCheck {
			indentConditionalCompilationBlocksSwitch.isEnabled = (checkbox.state == .on)
		} else if checkbox == lineBreakAroundMultilineExpressionChainComponentsCheck {
			lineBreakAroundMultilineExpressionChainComponentsSwitch.isEnabled = (checkbox.state == .on)
		}
		updateConfiguration()
	}

	@IBAction func stepperChanged(_ stepper: NSStepper) {
		if stepper == lineLengthStepper {
			lineLengthField.stringValue = "\(lineLengthStepper.integerValue)"
		} else if stepper == indentationStepper {
			indentationField.stringValue = "\(indentationStepper.integerValue)"
		} else if stepper == tabWidthStepper {
			tabWidthField.stringValue = "\(tabWidthStepper.integerValue)"
		} else if stepper == maximumBlankLinesStepper {
			maximumBlankLinesField.stringValue = "\(maximumBlankLinesStepper.integerValue)"
		}

		updateConfiguration()
	}

	@IBAction func popupChanged(_ popup: NSPopUpButton) {
		updateConfiguration()
	}

	@IBAction func switchChanged(_ _switch: NSSwitch) {
		updateConfiguration()
	}

	@IBAction func warningBtPress(_ button: NSButton) {
		let controller = NSViewController()
		let popover = NSPopover()
		controller.view = NSView(frame: NSRect(x: 0, y: 0, width: 290, height: 40))
		popover.contentViewController = controller
		popover.contentSize = controller.view.frame.size
		popover.behavior = .semitransient
		popover.animates = true

		let textField = NSTextField(string: "👋 Sorry, not available for swift-format 5.1")
		textField.frame = NSRect(x: 10, y: 8, width: 270, height: 20)
		textField.isBezeled = false
		textField.drawsBackground = true
		textField.backgroundColor = .clear
		textField.isEditable = false
		textField.isSelectable = true
		textField.alignment = .center
		controller.view.addSubview(textField)

		popover.show(relativeTo: .zero, of: button, preferredEdge: .minX)

	}
}
