//
//  DailyAdjustedCell.swift
//  MyTrade
//
//  Created by Arsalan Akhtar on 4/15/21.
//

import UIKit

class DailyAdjustedCell: UITableViewCell {

	@IBOutlet weak var MainDate: UILabel!
	
	@IBOutlet weak var firstSymbol: UILabel!
	
	@IBOutlet weak var firstOpen: UILabel!
	
	@IBOutlet weak var firstLow: UILabel!
	
	@IBOutlet weak var secondSymbol: UILabel!
	
	@IBOutlet weak var secondOpen: UILabel!
	
	@IBOutlet weak var secondLow: UILabel!
	
	@IBOutlet weak var thirdSymbol: UILabel!
	
	@IBOutlet weak var thirdOpen: UILabel!
	
	@IBOutlet weak var thirdLow: UILabel!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}

	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)

		// Configure the view for the selected state
	}

	func constructCell(date:String, firstRecord:Dictionary<String,String>?, secondRecord:Dictionary<String,String>?, thirdRecord:Dictionary<String,String>? )  {
		
		MainDate.text = date
		
		if let firstRecord = firstRecord, let open = firstRecord["1. open"], let low = firstRecord["3. low"]   {
			firstOpen.text = open
			firstLow.text = low
		}
		
		if let secondRecord = secondRecord, let open = secondRecord["1. open"], let low = secondRecord["3. low"]   {
			secondOpen.text = open
			secondLow.text = low
		}
		
		if let thirdRecord = thirdRecord, let open = thirdRecord["1. open"], let low = thirdRecord["3. low"]   {
			thirdOpen.text = open
			thirdLow.text = low
		}
	}
}
