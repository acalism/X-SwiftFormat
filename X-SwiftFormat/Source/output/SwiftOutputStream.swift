//
//  SwiftOutputStream.swift
//  X-SwiftFormat
//
//  Created by Rui Aureliano on 28/03/2020.
//  Copyright © 2020 Rui Aureliano. All rights reserved.
//

import Cocoa

struct SwiftOutputStream: TextOutputStream {

	var outputString: String?

	mutating func write(_ string: String) {
		self.outputString = string
	}
}
