//
//  BubblesVC.swift
//  Bubble Raps
//
//  Created by Alexander Lester on 1/16/20.
//  Copyright © 2020 Delta Vel. All rights reserved.
//

import Foundation
import UIKit

class BubbleVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	// MARK: Storyboard Outlets
	
	@IBOutlet weak var headingView: UIView!
	@IBOutlet weak var backButton: UIButton!
	@IBAction func backButtonAction(_ sender: Any) {
		if let root = self.presentingViewController {
			root.dismiss(animated: true, completion: nil)
		}
	}
	
	@IBOutlet weak var bubbleButton: UIButton!
	@IBAction func bubbleButtonAction(_ sender: Any) {
		if let BubbleVC = self.storyboard?.instantiateViewController(withIdentifier: "BubbleVC") as? BubbleVC {
			self.present(BubbleVC, animated: true, completion: nil)
		}
	}
	
	@IBOutlet weak var tableView: UITableView!
	
	// MARK: Class Variables
	
	let unlockable = UnlockableHelper()
	let purchase = PurchaseHelper()
	
	let bubbleAmounts = [5000, 3000, 1750, 750]
	let bubbleCosts = ["$3.99", "$2.99", "$1.99","$0.99"]
	
	// MARK: Override Functions
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.tableView.delegate = self
		self.tableView.dataSource = self
	}
	
	override func viewWillAppear(_ animated: Bool) {
		self.headingView.backgroundColor = self.unlockable.colorForCurrentTheme()
		self.bubbleButton.setAttributedTitleForAllStates(title: self.unlockable.bubbleBalanceWithIcon())
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.bubbleAmounts.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let index = indexPath.row
		
		let bubbleAmount = self.bubbleAmounts[index]
		let color = self.cycleThroughColors(i: indexPath.row) ?? #colorLiteral(red: 0.937254902, green: 0.7607843137, blue: 1, alpha: 1)
		let cost = self.bubbleCosts[index]
		
		let atrStr = self.addBubbleIconTo(String: "\(bubbleAmount) ", Color: UIColor.white)
		
		let cell = self.tableView.dequeueReusableCell(withIdentifier: "UnlockCell", for: indexPath) as! UnlockCell
			cell.title.attributedText = atrStr
			cell.cellView.backgroundColor = color
		
		cell.costLabel.text = cost
		cell.costLabel.textColor = color
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let index = indexPath.row
		let selectedAmount = self.bubbleAmounts[index]
		
		if let product = purchase.productFor(BubbleAmount: selectedAmount) {
			purchase.purchase(Product: product, BubbleAmount: selectedAmount, vc: self)
		}
		else {
			self.presentAlert(title: "Could Not Complete Purchase", message: "Please try again", actions: nil)
		}
	}
	
	private func cycleThroughColors(i: Int) -> UIColor? {
		let rowCount = self.bubbleAmounts.count - 1
		if i > rowCount {
			let key = self.unlockable.allThemes[i - rowCount]
			return self.unlockable.colorFor(Theme: key)
		}
		else {
			let key = self.unlockable.allThemes[i]
			return self.unlockable.colorFor(Theme: key)
		}
	}
	
	private func addBubbleIconTo(String: String, Color: UIColor) -> NSMutableAttributedString {
		let str = NSMutableAttributedString(string: String)
		if let font = UIFont(name: "AvenirNext-HeavyItalic", size: 22.0) {
			str.addAttribute(.font, value: font, range: NSRange(location: 0, length: str.length))
			str.addAttribute(.foregroundColor, value: Color, range: NSRange(location: 0, length: str.length))
			str.add(Image: #imageLiteral(resourceName: "Bubble Currency Small (White)"), WithOffset: -6.00)
		}
		
		return str
	}
}


