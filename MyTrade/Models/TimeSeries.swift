//
//  TimeSeries.swift
//  MyTrade
//
//  Created by Arsalan Akhtar on 4/12/21.
//

import Foundation

struct TimeSeries: Codable {
	var open: String
	var high: String
	var low: String
	
	let time: String
	
	
	enum CodingKeys: String, CodingKey {
		case open = "1. open"
		case high = "2. high"
		case low = "3. low"
	}
	
	init(from decoder: Decoder) throws {
		
		let container = try decoder.container(keyedBy: CodingKeys.self)
		
		open = try container.decode(String.self, forKey: CodingKeys.open)
		high = try container.decode(String.self, forKey: CodingKeys.high)
		low = try container.decode(String.self, forKey: CodingKeys.low)
		
		time = container.codingPath.first!.stringValue
	}
}

struct DecodedTimeSeriesArray: Decodable {
	var array: [TimeSeries]
	
	private struct DynamicCodingKeys: CodingKey {
		
		// Use for string-keyed dictionary
		var stringValue: String
		init?(stringValue: String) {
			self.stringValue = stringValue
		}
		
		// Use for integer-keyed dictionary
		var intValue: Int?
		init?(intValue: Int) {
			// We are not using this, thus just return nil
			return nil
		}
	}
	
	init(from decoder: Decoder) throws {
		
		let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
		
		var tempArray = [TimeSeries]()
		
		for key in container.allKeys {
			let decodedObject = try container.decode(TimeSeries.self, forKey: DynamicCodingKeys(stringValue: key.stringValue)!)
			tempArray.append(decodedObject)
		}
		
		array = tempArray
	}
	
}
