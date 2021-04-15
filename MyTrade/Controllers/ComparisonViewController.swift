//
//  ComparisonViewController.swift
//  MyTrade
//
//  Created by Arsalan Akhtar on 4/15/21.
//

import UIKit

class ComparisonViewController: UIViewController {

	@IBOutlet weak var symbolTextField: UITextField!
	
	@IBOutlet weak var symbolsStack: UIStackView!
	
	@IBOutlet weak var addButton: UIButton!
	
	@IBOutlet weak var clearButton: UIButton!
	
	@IBOutlet weak var searchButton: UIButton!
	
	@IBOutlet weak var tableView: UITableView!
	
	var symbol = [String]()
	
	var dates = [String]()
	
	var dailyAdjusted = [String:Dictionary<String, Dictionary<String,String>>]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		symbolTextField.delegate = self
		tableView.dataSource = self
	}
	
	@IBAction func addAction(_ sender: Any) {
	
		guard let text = symbolTextField.text, !text.isEmpty else {
			let alert = simpleMessageAlert(message: "Enter a symbol and press compare to start the comparison")
			self.present(alert, animated: true, completion: nil)
			return
		}
		
		guard symbol.count < 3 else {
			let alert = simpleMessageAlert(message: "Allowed upto 3 symbols only!")
			self.present(alert, animated: true, completion: nil)
			return
		}
		
		symbol.append(text)
		symbolTextField.text = ""
		addASymbolLabel(symbol: text)
	}
	
	@IBAction func clearAction(_ sender: Any) {
		symbolTextField.text = ""
		symbol.removeAll()
		for view in self.symbolsStack.arrangedSubviews{
			self.symbolsStack.removeArrangedSubview(view)
			view.removeFromSuperview()
		}
	}
	
	@IBAction func searchAction(_ sender: Any) {
		guard symbol.count >= 2 else {
			let alert = simpleMessageAlert(message: "Add at least two symbols and tap again to start the comparison!")
			self.present(alert, animated: true, completion: nil)
			return
		}
		
		fetchRecordsAndDisplay(index: 0)
		
		
	}
	
	func fetchRecordsAndDisplay(index:Int) {
		fetchAdjusted(symbolIndex: index) { success,nextIndex,isFetchingCompleted in
			
			guard success == true else {
				let alert = simpleMessageAlert(message:"Comparison Failed, try again with the correct symbols")
				self.present(alert, animated: true, completion: nil)
				return
			}
			
			if let ind = nextIndex {
				self.fetchRecordsAndDisplay(index:ind)
			} else if let isCompleted = isFetchingCompleted, isCompleted == true {
				
				DispatchQueue.main.async {
					self.displayResult()
				}
			}
		}
	}
	
	func displayResult() {
		if let dict = self.dailyAdjusted[self.symbol[0]] {
			self.dates = Array(dict.keys)
			tableView.reloadData()
		}
	}
	
	
	func addASymbolLabel(symbol:String) {
		let label: UILabel = UILabel()
		label.text = symbol
		label.textColor = .black
		label.backgroundColor = .white
		symbolsStack.addArrangedSubview(label)
	}
	
	func fetchAdjusted(symbolIndex:Int, completionHandler: @escaping (_ success:Bool, _ nextIndex:Int?, _ isFetchingCompleted:Bool?) -> Void) {
		
		AlphaAdvApi.sharedInstance().getDailyAdjusted(symbol: symbol[symbolIndex]) { status,data,error in
			
			do {
				
				guard let exchangeRates = data?["Time Series (Daily)"] as? NSDictionary else {
					return
				}
				
				let jsonData = try JSONSerialization.data(withJSONObject: exchangeRates, options: [])
				
				// Ask JSONDecoder to decode the JSON data as DecodedArray
				let decodedResult = try! JSONDecoder().decode(Dictionary<String, Dictionary<String,String>>.self, from: jsonData)
				
				self.dailyAdjusted[self.symbol[symbolIndex]] = decodedResult
				
				let nextIndex = symbolIndex < (self.symbol.count - 1) ? (symbolIndex + 1) : nil
				
				let isCompleted = nextIndex == nil ? true : false
				
				completionHandler(true, nextIndex, isCompleted)
			} catch let error as NSError {
				completionHandler(false, nil, nil)
				print("Could not fetch. \(error), \(error.userInfo)")
			}
		}
	}
	
}

extension ComparisonViewController : UITextFieldDelegate {

	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		if (string == " ") {
		  return false
		}
		return true
	}
}

extension ComparisonViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return dates.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "DailyAdjustedCell", for: indexPath) as! DailyAdjustedCell
		
		let date = dates[indexPath.row]
		
		let firstSymbol = self.symbol.count >= 1 ? self.symbol[0] : "-"
		let secondSymbol = self.symbol.count >= 2 ? self.symbol[1] : "-"
		let thirdSymbol = self.symbol.count >= 3 ? self.symbol[2] : "-"
		
		let firstRecord = dailyAdjusted[firstSymbol]?[date] ?? nil
		let secondRecord = dailyAdjusted[secondSymbol]?[date] ?? nil
	
		let thirdRecord = dailyAdjusted[thirdSymbol]?[date] ?? nil
		
		cell.constructCell(date: date, firstRecord: firstRecord, secondRecord: secondRecord, thirdRecord: thirdRecord)
		
		cell.firstSymbol.text = firstSymbol
		cell.secondSymbol.text = secondSymbol
		cell.thirdSymbol.text = thirdSymbol
		
		return cell
	}
}


func simpleMessageAlert(message:String) -> UIAlertController{
	let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
	alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
	return alert
}
