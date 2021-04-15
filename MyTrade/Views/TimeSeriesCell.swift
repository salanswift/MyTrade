//
//  TableViewCell.swift
//  MyTrade
//
//  Created by Arsalan Akhtar on 4/13/21.
//

import UIKit

class TimeSeriesCell: UITableViewCell {

	@IBOutlet weak var time: UILabel!
	
	@IBOutlet weak var open: UILabel!
	
	@IBOutlet weak var high: UILabel!
	
	@IBOutlet weak var low: UILabel!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

	func constructCell(tSeries:TimeSeries)  {
		time.text = tSeries.time
		open.text = "Open: \(tSeries.open)"
		high.text = "High: \(tSeries.high)"
		low.text = "Low: \(tSeries.low)"
	}
}
