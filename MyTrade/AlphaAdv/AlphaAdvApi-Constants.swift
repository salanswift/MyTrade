//
//  AlphaAdvApi-Constants.swift
//  MyTrade
//
//  Created by Arsalan Akhtar on 4/7/21.
//

import Foundation
extension AlphaAdvApi {
	
	struct Constants {
		// MARK: - URLs
		static let BaseUrl = "https://www.alphavantage.co/"
	}
	
	struct Resources {
		static let QUERY = "query"
	}
	
	struct Functions {
		static let INTRADAY = "TIME_SERIES_INTRADAY"
		static let DAILY_ADJUSTED = "TIME_SERIES_DAILY_ADJUSTED"
	}
	
	struct Keys {
		static let SYMBOL = "symbol"
		static let APIKEY = "apikey"
		static let METADATA = "Meta Data"
		static let FUNCTION = "function"
		static let INTERVAL = "interval"
		static let OUTPUT_SIZE = "outputsize"
	}
	
	
}
