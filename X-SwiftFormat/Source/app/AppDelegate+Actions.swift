//
//  AppDelegate+Actions.swift
//  X-SwiftFormat
//
//  Created by Rui Aureliano on 30/03/2020.
//  Copyright © 2020 Rui Aureliano. All rights reserved.
//

import Cocoa

extension AppDelegate {

	@IBAction func andreTwitterPress(_ button: AnimatedButton) {
		if let url = URL(string: "https://twitter.com/andre_goncalves") {
			NSWorkspace.shared.open(url)
		}
	}

	@IBAction func andreDribblePress(_ button: AnimatedButton) {
		if let url = URL(string: "https://dribbble.com/andre_goncalves") {
			NSWorkspace.shared.open(url)
		}
	}

	@IBAction func ruiTwitterPress(_ button: AnimatedButton) {
		if let url = URL(string: "https://twitter.com/ruiaureliano") {
			NSWorkspace.shared.open(url)
		}
	}

	@IBAction func ruiGithubPress(_ button: AnimatedButton) {
		if let url = URL(string: "https://github.com/ruiaureliano") {
			NSWorkspace.shared.open(url)
		}
	}

	@IBAction func versionButtonPress(_ button: NSButton) {
		if let url = URL(string: kSwiftFormatURL) {
			NSWorkspace.shared.open(url)
		}
	}

	@IBAction func resetButtonPress(_ button: NSButton) {
		let alert = NSAlert()
		alert.messageText = "Reset Configuration & Rules"
		alert.informativeText = "Are you sure you want to proceed?"
		alert.alertStyle = .critical
		alert.addButton(withTitle: "OK")
		alert.addButton(withTitle: "Cancel")
		alert.beginSheetModal(for: self.window) { (response) in
			if response.rawValue == 1000 {
				_ = UserDefaults.deleteConfiguration()
				_ = UserDefaults.deleteRules()
				self.tabViewConfiguration.reloadDataSource()
				self.tabViewRules.reloadDataSource()
			}
		}
	}

	@IBAction func previewButtonPress(_ button: NSButton) {
		previewWindow.openWithConfiguration(configuration: tabViewConfiguration.sharedConfiguration, rules: tabViewRules.sharedRules)
		previewWindow.makeKeyAndOrderFront(self)
	}

	@IBAction func exportButtonPress(_ button: NSButton) {
		var tabOption: TabOption = .configuration
		if let selectedTabViewItem = tabView.selectedTabViewItem {
			if let option = TabOption(rawValue: selectedTabViewItem.label) {
				tabOption = option
			}
		}
		let savePanel = NSSavePanel()
		savePanel.canCreateDirectories = true
		savePanel.showsTagField = false
		switch tabOption {
		case .configuration:
			savePanel.nameFieldStringValue = "swift-format-configuration.\(XSFDocType.config.rawValue)"
		case .rules:
			savePanel.nameFieldStringValue = "swift-format-rules.\(XSFDocType.rules.rawValue)"
		}
		savePanel.beginSheetModal(for: self.window) { (response) in
			if response.rawValue == 1 {
				if let url = savePanel.url {
					switch tabOption {
					case .configuration:
						var configuration: [String: Any] = [:]
						for entry in UserDefaults.configuration {
							configuration[entry.key] = entry.value
						}
						var metadata: [String: String] = ["type": "configuration"]
						if let version = Bundle.main.CFBundleShortVersionString {
							metadata["version"] = version
						}
						if let build = Bundle.main.CFBundleVersion {
							metadata["build"] = build
						}
						configuration["metadata"] = metadata
						if let json = configuration.jsonPretty {
							try? json.write(to: url, atomically: true, encoding: String.Encoding.utf8)
						}
					case .rules:
						var rules: [String: Any] = [:]
						for entry in UserDefaults.rules {
							rules[entry.key] = entry.value
						}
						var metadata: [String: String] = ["type": "rules"]
						if let version = Bundle.main.CFBundleShortVersionString {
							metadata["version"] = version
						}
						if let build = Bundle.main.CFBundleVersion {
							metadata["build"] = build
						}
						rules["metadata"] = metadata
						if let json = rules.jsonPretty {
							try? json.write(to: url, atomically: true, encoding: String.Encoding.utf8)
						}
					}
				}
			}
		}
	}
}
