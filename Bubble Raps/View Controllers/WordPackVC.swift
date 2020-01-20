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
	
	@IBOutlet weak var bubbleButton: UIButton!
	@IBAction func bubbleButtonAction(_ sender: Any) {
		if let BubbleVC = self.storyboard?.instantiateViewController(withIdentifier: "BubbleVC") as? BubbleVC {
			self.present(BubbleVC, animated: true, completion: nil)
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
		self.tableView.dataSource = self
		self.tableView.delegate = self
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		self.headingView.backgroundColor = self.unlockable.colorForCurrentTheme()
		self.bubbleButton.setAttributedTitleForAllStates(title: self.unlockable.bubbleBalanceWithIcon())
	}
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		self.headingView.clipsToBounds = true
		self.headingView.roundCorners(corners: [UIRectCorner.bottomLeft, UIRectCorner.bottomRight], radius: 5.0)
		self.headingView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
	}
	
	// MARK: Purchase Theme UI Handler
	private func presentPurchaseAlert(pack: String, cost: Int) {
		let alert = UIAlertController(title: "Purchase \(pack) Word Pack", message: "This word pack costs \(cost) bubbles.", preferredStyle: .alert)
		let purchaseAction = UIAlertAction(title: "Purchase", style: .default) { (action) in
			switch self.unlockable.purchasePack(Named: pack, Cost: cost) {
			case .success:
				self.presentAlert(title: "\(pack) Word Pack Unlocked!", message: "\(self.unlockable.currentBubbleBalance()) bubbles remaining.", actions: nil)
				self.bubbleButton.setAttributedTitleForAllStates(title: self.unlockable.bubbleBalanceWithIcon())
				self.tableView.reloadData()
			case .notEnoughBubbles:
				self.presentAlert(title: "Not Enough Bubbless!", message: "You need \(cost - self.unlockable.currentBubbleBalance()) more bubbles to unlock this word pack.", actions: nil)
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
		let unlockedPacks = self.unlockable.currentlyUnlockedPacks()
		let selectedPack = self.wordPacks.keys[indexPath.section]
		print("[INFO] \(selectedPack) Word Pack Selected")
		
		if unlockedPacks.contains(selectedPack) {
			if let cell = tableView.cellForRow(at: indexPath) as? UnlockCell { cell.costLabel.text = "●" }
			self.tableView.reloadData()
		}
		else { self.presentPurchaseAlert(pack: selectedPack, cost: 750) }
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
		
		let cell = self.tableView.dequeueReusableCell(withIdentifier: "UnlockCell", for: indexPath) as! UnlockCell
			cell.title.text = selectedPack
			cell.cellView.backgroundColor = color
		
		cell.costLabel.attributedText = self.unlockable.addBubbleIconTo(String: "750 ", Color: color, Size: nil, Offset: nil)
		
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

class UnlockCell: UITableViewCell {
	@IBOutlet weak var cellView: UIView!
	@IBOutlet weak var title: UILabel!
	@IBOutlet weak var costLabel: UILabel!
}
