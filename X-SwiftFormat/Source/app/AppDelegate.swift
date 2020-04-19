//
//  AppDelegate.swift
//  X-SwiftFormat
//
//  Created by Rui Aureliano on 27/03/2020.
//  Copyright © 2020 Rui Aureliano. All rights reserved.
//

import Cocoa

@NSApplicationMain class AppDelegate: NSObject, NSApplicationDelegate {

	@IBOutlet weak var window: NSWindow!

	@IBOutlet weak var previewWindow: SourcePreviewWindow!
	@IBOutlet weak var previewWindowCancel: NSButton!
	@IBOutlet weak var previewWindowFormat: NSButton!

	@IBOutlet weak var appIcon: NSImageView!
	@IBOutlet weak var appName: NSTextField!
	@IBOutlet weak var appVersion: NSTextField!

	@IBOutlet weak var tabView: TabView!

	private var kvo: NSKeyValueObservation?

	func applicationDidFinishLaunching(_ aNotification: Notification) {

		window.isMovableByWindowBackground = true
		if let contentView = window.contentView {
			kvo = contentView.observe(\.effectiveAppearance) { [weak self] _, _ in
				self?.changeApplicationIconImage()
			}
		}

		if let version = Bundle.main.CFBundleVersion, let shortVersionString = Bundle.main.CFBundleShortVersionString {
			appVersion.stringValue = "Version: \(shortVersionString) (\(version))"
		}
		if let executable = Bundle.main.CFBundleExecutable {
			appName.stringValue = executable
		}

		tabView.appDelegate = self

		changeApplicationIconImage()
	}

	func applicationWillTerminate(_ aNotification: Notification) {
	}

	func applicationDidBecomeActive(_ notification: Notification) {
		changeApplicationIconImage()
	}

	func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
		window.makeKeyAndOrderFront(self)
		return true
	}

	func changeApplicationIconImage() {
		if let image = NSImage(named: "x-swiftformat")?.copy() as? NSImage {
			if let icon = AppIcon.with(image: image, with: .controlAccentColor) {
				NSApp.applicationIconImage = icon
			}
		}
	}
}
