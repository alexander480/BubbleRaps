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
	
	let packCost = 750
	
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
	
	// MARK: Local Variables
	
	let wordPacks = Packs()
	
	var selectedPack = ""
	
	// MARK: View Did Load
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Disable Dark Mode Support
		overrideUserInterfaceStyle = .light
		
		self.tableView.dataSource = self
		self.tableView.delegate = self
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		self.headingView.backgroundColor = Theme.primary()
		self.bubbleButton.setAttributedTitleForAllStates(title: Currency.bubbleBalanceWithIcon())
	}
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		self.headingView.clipsToBounds = true
		self.headingView.roundCorners(corners: [UIRectCorner.bottomLeft, UIRectCorner.bottomRight], radius: 5.0)
		self.headingView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
	}
	
	// MARK: Purchase Theme UI Handler
	private func presentPackPurchaseAlert(pack: String) {
		let alert = UIAlertController(title: "Unlock \(pack) Word Pack", message: "\(self.packCost) Bubbles", preferredStyle: .actionSheet)
		let purchaseAction = UIAlertAction(title: "Confirm", style: .default) { (action) in
			switch Packs.purchase(pack) {
				case .success:
					self.presentAlert(title: "\(pack) Word Pack Unlocked!", message: "\(Currency.currentBubbleBalance()) bubbles remaining.", actions: nil)
					self.bubbleButton.setAttributedTitleForAllStates(title: Currency.bubbleBalanceWithIcon())
					self.tableView.reloadData()
				case .notEnoughBubbles:
					self.presentAlert(title: "Not Enough Bubbles!", message: "You need \(self.packCost - Currency.currentBubbleBalance()) more bubbles to unlock this word pack.", actions: nil)
				case .alreadyUnlocked:
					self.presentAlert(title: "You Have Already Unlocked This Word Pack!", message: "Go get yourself something nice, you've got enough bubbles (;", actions: nil)
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
		let unlockedPacks = Packs.unlocked()
		let selectedPack = Packs.keys[indexPath.section]
		print("[INFO] \(selectedPack) Word Pack Selected")
		
		if unlockedPacks.contains(selectedPack) {
			if let cell = tableView.cellForRow(at: indexPath) as? UnlockCell { cell.costLabel.text = "●" }
			self.tableView.reloadData()
		}
		else {
			self.presentPackPurchaseAlert(pack: selectedPack)
		}
	}
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 85.0 }
}

// MARK: UITableViewDataSource

extension WordPackVC: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int { return Packs.keys.count }
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return 1 }
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let unlockedPacks = Packs.unlocked()
		let selectedPack = Packs.keys[indexPath.section]
		let color = self.cycleThroughColors(i: indexPath.section) ?? #colorLiteral(red: 0.937254902, green: 0.7607843137, blue: 1, alpha: 1)
		
		let cell = self.tableView.dequeueReusableCell(withIdentifier: "UnlockCell", for: indexPath) as! UnlockCell
			cell.title.text = selectedPack
			cell.cellView.backgroundColor = color
		
		cell.costLabel.attributedText = Theme.addBubbleIconTo("\(packCost) ", color: color)
		
		if unlockedPacks.contains(selectedPack) {
			cell.costLabel.text = "●"
			cell.costLabel.textColor = color
		}
		
		return cell
	}
	
	private func cycleThroughColors(i: Int) -> UIColor? {
		let allThemes = Theme.allThemes
		let themeCount = Theme.allThemes.count - 1
		
		if i > themeCount { return Theme.color(forTheme: allThemes[i - themeCount]) }
		else { return Theme.color(forTheme: allThemes[i]) }
	}
}


