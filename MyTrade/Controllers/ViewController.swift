//
//  ViewController.swift
//  MyTrade
//
//  Created by Arsalan Akhtar on 4/7/21.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		AlphaAdvApi.sharedInstance().getIntraDay(symbol: "IBM") { status,data,error in
			
			do {
				
				guard let exchangeRates = data?["Time Series (5min)"] as? NSDictionary else {
					return
				}
				
				let jsonData = try JSONSerialization.data(withJSONObject: exchangeRates, options: [])
				
				// Ask JSONDecoder to decode the JSON data as DecodedArray
				let decodedResult = try! JSONDecoder().decode(DecodedTimeSeriesArray.self, from: jsonData)

				
				
			} catch let error as NSError {
				print("Could not save. \(error), \(error.userInfo)")
			}
		}
	}


}

