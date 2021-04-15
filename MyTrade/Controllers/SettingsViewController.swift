//
//  SettingsViewController.swift
//  MyTrade
//
//  Created by Arsalan Akhtar on 4/16/21.
//

import UIKit

class SettingsViewController: UIViewController {
	
	
	@IBOutlet weak var intervalSegment: UISegmentedControl!
	
	@IBOutlet weak var outPutSegment: UISegmentedControl!
	
	@IBOutlet weak var apiKeyTextField: UITextField!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		intervalSegment.selectedSegmentIndex = AppData.interval
		outPutSegment.selectedSegmentIndex = AppData.outputSize
		apiKeyTextField.text = AppData.ApiKey
	}
	
	@IBAction func setIntervals(_ sender: UISegmentedControl) {
		AppData.interval = sender.selectedSegmentIndex
	}
	
	@IBAction func setOutputSize(_ sender: UISegmentedControl) {
		AppData.outputSize = sender.selectedSegmentIndex
	}
	
	@IBAction func saveKey(_ sender: Any) {
		
		guard let text = apiKeyTextField.text, !text.isEmpty else {
			let alert = simpleMessageAlert(message: "Enter key and press save!")
			self.present(alert, animated: true, completion: nil)
			return
		}
		AppData.ApiKey = text
	}
	
}
