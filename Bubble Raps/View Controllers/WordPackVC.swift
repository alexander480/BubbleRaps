//
//  PacksVC.swift
//  RhymingBubbles
//
//  Created by Alexander Lester on 9/8/19.
//  Copyright © 2019 Delta Vel. All rights reserved.
//


// In Progress Of Creating WordPackPurchase Functions

import Foundation
import UIKit

class WordPackVC: UIViewController {
	
	// MARK: Storyboard Outlets
	
	@IBOutlet weak var headingView: UIView!
	
	@IBOutlet weak var backButton: UIButton!
	@IBAction func backButtonAction(_ sender: Any) {
		if let root = self.presentingViewController {
			root.dismiss(animated: true, completion: nil)
		}
	}
	
	@IBOutlet weak var coinButton: UIButton!
	@IBAction func coinButtonAction(_ sender: Any) {
		if let coinVC = self.storyboard?.instantiateViewController(withIdentifier: "CoinVC") as? CoinVC {
			self.present(coinVC, animated: true, completion: nil)
		}
	}
	
	@IBOutlet weak var tableView: UITableView!
	
	// MARK: Local Variables
	
	let wordPacks = WordPacks()
	let unlockable = UnlockableHelper()
	
	var selectedPack = ""
	
	// MARK: View Did Load
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
		self.tableView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
		
		self.tableView.dataSource = self
		self.tableView.delegate = self
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		
		self.headingView.backgroundColor = self.unlockable.colorForCurrentTheme()
		self.coinButton.setAttributedTitleForAllStates(title: self.unlockable.coinBalanceWithIcon())
	}
	

	// MARK: Purchase Theme UI Handler
	private func presentPurchaseAlert(pack: String, cost: Int) {
		let alert = UIAlertController(title: "Purchase \(pack) Word Pack", message: "This Word Pack Costs \(cost) Coins.", preferredStyle: .alert)
		let purchaseAction = UIAlertAction(title: "Purchase", style: .default) { (action) in
			switch self.unlockable.purchasePack(Named: pack, Cost: cost) {
			case .success:
				self.presentAlert(title: "\(pack) Word Pack Unlocked!", message: "\(self.unlockable.currentCoinBalance()) Coins Remaining.", actions: nil)
				self.tableView.reloadData()
			case .notEnoughCoins:
				self.presentAlert(title: "Not Enough Coins!", message: "You Need \(cost - self.unlockable.currentCoinBalance()) More Coins To Unlock This Word Pack.", actions: nil)
			case .alreadyUnlocked:
				self.presentAlert(title: "You Have Already Unlocked This Word Pack!", message: "Go Get Yourself Something Nice, You've Got Enough Coins (;", actions: nil)
			}
			alert.dismiss(animated: true, completion: nil)
		}
		
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in alert.dismiss(animated: true, completion: nil) }
		
		alert.addAction(cancelAction)
		alert.addAction(purchaseAction)
		
		self.present(alert, animated: true, completion: nil)
	}
}

// MARK: UITableViewDelegate

extension WordPackVC: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let unlockedPacks = self.unlockable.currentlyUnlockedPacks()
		let selectedPack = self.wordPacks.keys[indexPath.section]
		print("[INFO] \(selectedPack) Word Pack Selected")
		
		if unlockedPacks.contains(selectedPack) {
			if let cell = tableView.cellForRow(at: indexPath) as? WordPackCell { cell.costLabel.text = "●" }
			self.tableView.reloadData()
		}
		else {
			self.presentPurchaseAlert(pack: selectedPack, cost: 5)
		}
	}
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 85.0 }
}

// MARK: UITableViewDataSource

extension WordPackVC: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int { return wordPacks.keys.count }
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return 1 }
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let unlockedPacks = self.unlockable.currentlyUnlockedPacks()
		let selectedPack = self.wordPacks.keys[indexPath.section]
		
		let color = self.cycleThroughColors(i: indexPath.section) ?? #colorLiteral(red: 0.937254902, green: 0.7607843137, blue: 1, alpha: 1)
		let cell = self.tableView.dequeueReusableCell(withIdentifier: "WordPackCell", for: indexPath) as! WordPackCell
			cell.title.text = selectedPack
			cell.cellView.backgroundColor = color
		
		cell.costLabel.attributedText = self.unlockable.addCoinIconTo(String: "500 ", Color: #colorLiteral(red: 0.2427230775, green: 0.6916770339, blue: 1, alpha: 1), Size: nil)
		
		if unlockedPacks.contains(selectedPack) {
			cell.costLabel.text = "●"
			cell.costLabel.textColor = color
		}
		
		return cell
	}
	
	private func cycleThroughColors(i: Int) -> UIColor? {
		let themesCount = self.unlockable.allThemes.count - 1
		if i > themesCount {
			let key = self.unlockable.allThemes[i - themesCount]
			return self.unlockable.colorFor(Theme: key)
		}
		else {
			let key = self.unlockable.allThemes[i]
			return self.unlockable.colorFor(Theme: key)
		}
	}
}

class WordPackCell: UITableViewCell {
	@IBOutlet weak var cellView: UIView!
	@IBOutlet weak var title: UILabel!
	@IBOutlet weak var costLabel: UILabel!
}
