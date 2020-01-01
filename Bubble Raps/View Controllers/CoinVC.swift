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
	
	let purchaseHelper = PurchaseHelper()
	let currentCoins = UserDefaults.standard.integer(forKey: "coins")
	
	@IBOutlet weak var currentCoinsLabel: UILabel!
	
	@IBOutlet weak var backButton: UIButton!
	@IBAction func backButtonAction(_ sender: Any) {
		if let presenter = self.presentingViewController as? MenuVC {
			let coins = UserDefaults.standard.integer(forKey: "coins")
			presenter.coinButton.setTitleForAllStates(title: "\(coins) 🅒")
			presenter.dismiss(animated: true, completion: nil)
		}
	}
	
	@IBAction func purchase5000CoinsButton(_ sender: Any) {
		if let product = purchaseHelper.productFor(Coins: 5000) { purchaseHelper.purchase(Product: product, CoinAmount: 5000, vc: self) }
		else { self.presentAlert(title: "Could Not Complete Purchase", message: "Please try again", actions: nil) }
	}
	
	@IBAction func purchase3000CoinsButton(_ sender: Any) {
		if let product = purchaseHelper.productFor(Coins: 3000) { purchaseHelper.purchase(Product: product, CoinAmount: 3000, vc: self) }
		else { self.presentAlert(title: "Could Not Complete Purchase", message: "Please try again", actions: nil) }
	}
	
	@IBAction func purchase1750CoinsButton(_ sender: Any) {
		if let product = purchaseHelper.productFor(Coins: 1750) { purchaseHelper.purchase(Product: product, CoinAmount: 1750, vc: self) }
		else { self.presentAlert(title: "Could Not Complete Purchase", message: "Please try again", actions: nil) }
	}
	
	@IBAction func purchase750CoinsButton(_ sender: Any) {
		if let product = purchaseHelper.productFor(Coins: 750) { purchaseHelper.purchase(Product: product, CoinAmount: 750, vc: self) }
		else { self.presentAlert(title: "Could Not Complete Purchase", message: "Please try again", actions: nil) }
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.currentCoinsLabel.text = "\(self.currentCoins) 🅒"
	}
}
