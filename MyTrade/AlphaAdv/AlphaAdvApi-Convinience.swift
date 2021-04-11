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
			AlphaAdvApi.Keys.APIKEY : "KKLMIP6V96ZOS3L2",
			AlphaAdvApi.Keys.INTERVAL : "5min"
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

