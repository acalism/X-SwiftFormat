//
//  AppDelegate+Actions.swift
//  X-SwiftFormat
//
//  Created by Rui Aureliano on 27/03/2020.
//  Copyright © 2020 Rui Aureliano. All rights reserved.
//

import Cocoa

extension AppDelegate {

	@IBAction func andreTwitterPress(_ button: NSAnimatedButton) {
		if let url = URL(string: "https://twitter.com/andre_goncalves") {
			NSWorkspace.shared.open(url)
		}
	}

	@IBAction func andreDribblePress(_ button: NSAnimatedButton) {
		if let url = URL(string: "https://dribbble.com/andre_goncalves") {
			NSWorkspace.shared.open(url)
		}
	}

	@IBAction func ruiTwitterPress(_ button: NSAnimatedButton) {
		if let url = URL(string: "https://twitter.com/ruiaureliano") {
			NSWorkspace.shared.open(url)
		}
	}

	@IBAction func ruiGithubPress(_ button: NSAnimatedButton) {
		if let url = URL(string: "https://github.com/ruiaureliano") {
			NSWorkspace.shared.open(url)
		}
	}

	@IBAction func showInvisiblesBtPress(_ _switch: NSSwitch) {
		previewWindow.showInvisibles(invisibles: (_switch.state == .on ? true : false))
	}

	@IBAction func previewCloseBtPress(_ button: NSButton) {
		previewWindow.close()
	}

	@IBAction func previewFormatBtPress(_ button: NSButton) {
		previewWindow.formatCode()
	}
}
