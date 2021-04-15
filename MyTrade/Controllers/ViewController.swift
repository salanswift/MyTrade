//
//  ViewController.swift
//  MyTrade
//
//  Created by Arsalan Akhtar on 4/7/21.
//

import UIKit

enum TimeSeriesProperties: String {
	case Time = "Time"
	case Open = "Open"
	case High = "High"
	case Low = "Low"
}

class ViewController: UIViewController {
	
	@IBOutlet var searchBar: UISearchBar!
	
	@IBOutlet var tableView: UITableView!
	
	let segment: UISegmentedControl = UISegmentedControl(items: [TimeSeriesProperties.Time.rawValue,TimeSeriesProperties.Open.rawValue,TimeSeriesProperties.High.rawValue,TimeSeriesProperties.Low.rawValue])
	
	var timeSeries = [TimeSeries](){
		didSet(modified) {
			DispatchQueue.main.async { [self] in
				self.segment.isEnabled = self.timeSeries.count > 0
			}
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.tableView.dataSource = self
		self.searchBar.delegate = self
		let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
		view.addGestureRecognizer(tap)
		
		segment.sizeToFit()
		segment.isEnabled = false
		if #available(iOS 13.0, *) {
			segment.selectedSegmentTintColor = UIColor.red
		} else {
			segment.tintColor = UIColor.red
		}
		
		segment.addTarget(self, action: #selector(ViewController.indexChanged(_:)), for: .valueChanged)
		
		self.navigationItem.titleView = segment
		
	}
	
	@objc func indexChanged(_ sender: UISegmentedControl) {
		
		guard let name = sender.titleForSegment(at: sender.selectedSegmentIndex), let property = TimeSeriesProperties(rawValue: name) else {
			return
		}
		sortTable(BY: property)
	
	}
	
	func sortTable(BY criteria:TimeSeriesProperties) {
		
		switch criteria {
		case .Time:
			timeSeries = timeSeries.sorted(by: { $0.time > $1.time })
		case .Open:
			timeSeries = timeSeries.sorted(by: { $0.open > $1.open })
		case .High:
			timeSeries = timeSeries.sorted(by: { $0.high > $1.high })
		case .Low:
			timeSeries = timeSeries.sorted(by: { $0.low > $1.low })
		}
		
		self.tableView.reloadData()
	}
	
	//Calls this function when the tap is recognized.
	@objc func dismissKeyboard() {
		view.endEditing(true)
	}
}

extension ViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return timeSeries.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "TimeSeriesCell", for: indexPath) as! TimeSeriesCell
		cell.constructCell(tSeries: timeSeries[indexPath.row])
		return cell
	}
}

extension ViewController: UISearchBarDelegate {
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		
		guard let symbol = searchBar.text, symbol != "" else {
			return
		}
		
		searchAndDisplayTSeries(symbol:symbol)
	}
	
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		
	}
	
	func searchAndDisplayTSeries(symbol:String) {
		
		self.view.endEditing(true)
		
		AlphaAdvApi.sharedInstance().getIntraDay(symbol: symbol) { status,data,error in
			
			do {
				
				guard let timeSeries = data?["Time Series (\(AppData.intervals[AppData.interval]))"] as? NSDictionary else {
					return
				}
				
				let jsonData = try JSONSerialization.data(withJSONObject: timeSeries, options: [])
				
				// Ask JSONDecoder to decode the JSON data as DecodedArray
				let decodedResult = try! JSONDecoder().decode(DecodedTimeSeriesArray.self, from: jsonData)
				
				self.timeSeries = decodedResult.array
				
				DispatchQueue.main.async {
					self.tableView.reloadData()
				}
				
			} catch let error as NSError {
				print("Could not save. \(error), \(error.userInfo)")
			}
		}
	}
	
}
