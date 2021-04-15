//
//  ExchangeRateApi-Convinience.swift
//  MyTrade
//
//  Created by Arsalan Akhtar on 4/7/21.
//

import Foundation

extension AlphaAdvApi {
	
	func getIntraDay(symbol:String, completionHandler: @escaping (_ success:Bool, _ result:AnyObject?, _ errorString:String?) -> Void) {
		
		let parameters = [
			AlphaAdvApi.Keys.FUNCTION: AlphaAdvApi.Functions.INTRADAY,
			AlphaAdvApi.Keys.SYMBOL : symbol,
			AlphaAdvApi.Keys.APIKEY : AppData.ApiKey,
			AlphaAdvApi.Keys.INTERVAL : AppData.intervals[AppData.interval],
			AlphaAdvApi.Keys.OUTPUT_SIZE : AppData.outputSizes[AppData.outputSize]
		] as [String : Any]
		
		AlphaAdvApi.sharedInstance().taskForResource(resource: AlphaAdvApi.Resources.QUERY, parameters: parameters as [String : AnyObject]){  JSONResult, error  in
			
			if let _ = error
			{
				completionHandler(false, nil, "Can not find conversion for base currency")
			}
			else
			
			{
				guard let jsonResultDictionary = JSONResult as? NSDictionary, jsonResultDictionary[AlphaAdvApi.Keys.METADATA] != nil else {
					
					let error = NSError(domain: "\(String(describing: JSONResult))", code: 0, userInfo: nil)
					print(error)
					completionHandler(false, nil, error.localizedDescription)
					return
					
				}
				
				completionHandler(true, JSONResult, nil)
			}
		}
	}
	
	func getDailyAdjusted(symbol:String, completionHandler: @escaping (_ success:Bool, _ result:AnyObject?, _ errorString:String?) -> Void) {
		
		let parameters = [
			AlphaAdvApi.Keys.FUNCTION: AlphaAdvApi.Functions.DAILY_ADJUSTED,
			AlphaAdvApi.Keys.SYMBOL : symbol,
			AlphaAdvApi.Keys.APIKEY : AppData.ApiKey,
			AlphaAdvApi.Keys.OUTPUT_SIZE : AppData.outputSizes[AppData.outputSize]
		] as [String : Any]
		
		AlphaAdvApi.sharedInstance().taskForResource(resource: AlphaAdvApi.Resources.QUERY, parameters: parameters as [String : AnyObject]){  JSONResult, error  in
			
			if let _ = error
			{
				completionHandler(false, nil, "Can not find conversion for base currency")
			}
			else
			
			{
				guard let jsonResultDictionary = JSONResult as? NSDictionary, jsonResultDictionary[AlphaAdvApi.Keys.METADATA] != nil else {
					
					let error = NSError(domain: "\(String(describing: JSONResult))", code: 0, userInfo: nil)
					print(error)
					completionHandler(false, nil, error.localizedDescription)
					return
					
				}
				
				completionHandler(true, JSONResult, nil)
			}
		}
	}
}

