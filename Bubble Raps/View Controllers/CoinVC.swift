//
//  CoinVC.swift
//  RhymingBubbles
//
//  Created by Alexander Lester on 9/25/19.
//  Copyright © 2019 Delta Vel. All rights reserved.
//

import Foundation
import UIKit

class CoinVC: UIViewController, UIGestureRecognizerDelegate {
	
	let unlockable = UnlockableHelper()
	let purchaseHelper = PurchaseHelper()
	
	@IBOutlet weak var currentCoinsLabel: UILabel!
	
	@IBOutlet weak var backButton: UIButton!
	@IBAction func backButtonAction(_ sender: Any) {
		if let presenter = self.presentingViewController as? MenuVC {
			let str = self.unlockable.addCoinIconTo(String: "\(self.unlockable.currentCoinBalance()) ", Color: UIColor.white, Size: nil)
			presenter.coinButton.setAttributedTitleForAllStates(title: str)
			presenter.dismiss(animated: true, completion: nil)
		}
	}
	
	@IBOutlet weak var fiveThousandCoinsLabel: UILabel!
	@IBAction func purchase5000CoinsButton(_ sender: Any) {
		if let product = purchaseHelper.productFor(Coins: 5000) { purchaseHelper.purchase(Product: product, CoinAmount: 5000, vc: self) }
		else { self.presentAlert(title: "Could Not Complete Purchase", message: "Please try again", actions: nil) }
	}
	
	
	@IBOutlet weak var threeThousandCoinsLabel: UILabel!
	@IBAction func purchase3000CoinsButton(_ sender: Any) {
		if let product = purchaseHelper.productFor(Coins: 3000) { purchaseHelper.purchase(Product: product, CoinAmount: 3000, vc: self) }
		else { self.presentAlert(title: "Could Not Complete Purchase", message: "Please try again", actions: nil) }
	}
	
	
	@IBOutlet weak var seventeenHundredCoinsLabel: UILabel!
	@IBAction func purchase1750CoinsButton(_ sender: Any) {
		if let product = purchaseHelper.productFor(Coins: 1750) { purchaseHelper.purchase(Product: product, CoinAmount: 1750, vc: self) }
		else { self.presentAlert(title: "Could Not Complete Purchase", message: "Please try again", actions: nil) }
	}
	
	@IBOutlet weak var sevenFiftyCoinsLabel: UILabel!
	@IBAction func purchase750CoinsButton(_ sender: Any) {
		if let product = purchaseHelper.productFor(Coins: 750) { purchaseHelper.purchase(Product: product, CoinAmount: 750, vc: self) }
		else { self.presentAlert(title: "Could Not Complete Purchase", message: "Please try again", actions: nil) }
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.currentCoinsLabel.attributedText = self.unlockable.coinBalanceWithIcon()
		self.fiveThousandCoinsLabel.attributedText = self.attributedTextWithIcon(String: "5000 ")
		self.threeThousandCoinsLabel.attributedText = self.attributedTextWithIcon(String: "3000 ")
		self.seventeenHundredCoinsLabel.attributedText = self.attributedTextWithIcon(String: "1750 ")
		self.sevenFiftyCoinsLabel.attributedText = self.attributedTextWithIcon(String: "750 ")
	}
	
	private func attributedTextWithIcon(String: String) -> NSMutableAttributedString {
		let str = NSMutableAttributedString(string: String)
		if let font = UIFont(name: "AvenirNext-HeavyItalic", size: 20.0) {
			str.addAttribute(.font, value: font, range: NSRange(location: 0, length: str.length))
			str.addAttribute(.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: str.length))
			
			str.add(Image: #imageLiteral(resourceName: "Bubble Currency Small (White)"), WithOffset: -5.25)
		}
		
		return str
	}
}
