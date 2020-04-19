//
//  NSViewColor.swift
//  X-SwiftFormat
//
//  Created by Rui Aureliano on 27/03/2020.
//  Copyright © 2020 Rui Aureliano. All rights reserved.
//

import Cocoa

@IBDesignable class NSViewColor: NSView {

	@IBInspectable public var color: NSColor = .white
	@IBInspectable public var radius: CGFloat = 0

	override func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()
	}

	override var allowsVibrancy: Bool {
		return false
	}

	convenience init(width: CGFloat, height: CGFloat) {
		self.init(frame: NSRect(x: 0, y: 0, width: width, height: height))
	}

	override func draw(_ dirtyRect: NSRect) {
		super.draw(dirtyRect)
		self.color.setFill()
		let bezier = NSBezierPath(roundedRect: dirtyRect, xRadius: self.radius, yRadius: self.radius)
		bezier.fill()
	}

	func setColor(color: NSColor) {
		self.color = color
		self.needsDisplay = true
	}

	func setRadius(radius: CGFloat) {
		self.radius = radius
		self.needsDisplay = true
	}
}
