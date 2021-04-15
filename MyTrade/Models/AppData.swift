//
//  AppData.swift
//  MyTrade
//
//  Created by Arsalan Akhtar on 4/16/21.
//

import Foundation

struct AppData {
	
	private static let intervalKey = "interval_key"
	private static let outputSizeKey = "outputSize_key"
	private static let apiKey = "Api_key"
	
	static let intervals = ["1min","5min","15min","30min","60min"]
	static let outputSizes = ["compact","full"]
	
	static var interval: Int {
		get {
			return UserDefaults.standard.integer(forKey: intervalKey)
		}
		set {
			UserDefaults.standard.set(newValue, forKey: intervalKey)
		}
	}
	
	static var outputSize: Int {
		get {
			return UserDefaults.standard.integer(forKey: outputSizeKey)
		}
		set {
			UserDefaults.standard.set(newValue, forKey: outputSizeKey)
		}
	}
	
	static var ApiKey: String {
		get {
			
			if let receivedData = KeyChain.load(key: apiKey) {
				let result = receivedData.to(type: String.self)
				return result
			}
			return "KKLMIP6V96ZOS3L2"
		}
		set {
			let data = Data(from: newValue)
			KeyChain.save(key: apiKey, data: data)
		}
	}
}


