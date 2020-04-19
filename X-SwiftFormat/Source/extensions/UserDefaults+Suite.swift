//
//  UserDefaults+Suite.swift
//  X-SwiftFormat
//
//  Created by Rui Aureliano on 27/03/2020.
//  Copyright © 2020 Rui Aureliano. All rights reserved.
//

import Cocoa

private let kUserDefaultsSuiteName = "com.ruiaureliano.xswiftformat.suite"
private let kUserDefaultsConfiguration = "kUserDefaultsConfiguration"

extension UserDefaults {

	class func saveConfiguration(configuration: [String: Any]) -> Bool {
		if let defaults = UserDefaults(suiteName: kUserDefaultsSuiteName) {
			if let json = configuration.json {
				defaults.set(json, forKey: kUserDefaultsConfiguration)
				defaults.synchronize()
				return true
			}
		}
		return false
	}

	class func loadConfiguration() -> [String: Any]? {
		if let defaults = UserDefaults(suiteName: kUserDefaultsSuiteName) {
			if let json = defaults.string(forKey: kUserDefaultsConfiguration) {
				if let data = json.data(using: .utf8) {
					if let configuration = data.json as? [String: Any] {
						return configuration
					}
				}
			}
		}
		return nil
	}
}
