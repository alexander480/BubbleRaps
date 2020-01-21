//
//  ThemeVC.swift
//  RhymingBubbles
//
//  Created by Alexander Lester on 9/8/19.
//  Copyright © 2019 Delta Vel. All rights reserved.
//

import Foundation
import UIKit

class ThemesVC: UIViewController {
	
	@IBOutlet weak var headingView: UIView!
	
	@IBOutlet weak var backButton: UIButton!
	@IBAction func backButtonAction(_ sender: Any) {
		if let presenter = self.presentingViewController as? MenuVC {
			let currentTheme = self.unlockable.currentTheme()
			presenter.themeButton.setImageForAllStates(image: self.unlockable.tabImageFor(Theme: currentTheme))
			presenter.logoImage.image = self.unlockable.logoImageFor(Theme: currentTheme)
			presenter.dismiss(animated: true, completion: nil)
		}
	}
	
	@IBOutlet weak var bubbleButton: UIButton!
	@IBAction func bubbleButtonAction(_ sender: Any) {
		if let BubbleVC = self.storyboard?.instantiateViewController(withIdentifier: "BubbleVC") as? BubbleVC {
			self.present(BubbleVC, animated: true, completion: nil)
		}
	}
	
	@IBOutlet weak var tableView: UITableView!
	
	let unlockable = UnlockableHelper()
	let themes = ["Purpink", "Dark Purpink", "Purple", "Dark Purple", "Blue", "Dark Blue", "Gray", "Dark Gray"]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.tableView.delegate = self
		self.tableView.dataSource = self
		
		self.headingView.backgroundColor = self.unlockable.colorForCurrentTheme()
		self.bubbleButton.setAttributedTitleForAllStates(title: self.unlockable.bubbleBalanceWithIcon())
	}
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		self.headingView.clipsToBounds = true
		self.headingView.roundCorners(corners: [UIRectCorner.bottomLeft, UIRectCorner.bottomRight], radius: 5.0)
		self.headingView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
	}
	
	private func presentPurchaseAlert(theme: String, cost: Int) {
			let alert = UIAlertController(title: "Purchase \(theme) Theme", message: "This theme costs \(cost) bubbles.", preferredStyle: .alert)
			let purchaseAction = UIAlertAction(title: "Purchase", style: .default) { (action) in
				switch self.unlockable.purchaseTheme(Named: theme, Cost: cost) {
				case .success:
					self.presentAlert(title: "\(theme) Theme Unlocked!", message: "You have \(self.unlockable.currentBubbleBalance()) bubbles remaining.", actions: nil)
					self.bubbleButton.setAttributedTitleForAllStates(title: self.unlockable.bubbleBalanceWithIcon())
					self.tableView.reloadData()
				case .notEnoughBubbles:
					self.presentAlert(title: "Not Enough Bubbles!", message: "You need \(cost - self.unlockable.currentBubbleBalance()) more bubbles to unlock this theme.", actions: nil)
				case .alreadyUnlocked:
					self.presentAlert(title: "You Have Already Unlocked This Theme!", message: "Get yourself something nice, you've got enough bubbles (;", actions: nil)
				}
				alert.dismiss(animated: true, completion: nil)
			}
			
			let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in alert.dismiss(animated: true, completion: nil) }
			
			alert.addAction(cancelAction)
			alert.addAction(purchaseAction)
			
			self.present(alert, animated: true, completion: nil)
	}
}

extension ThemesVC: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let selectedTheme = self.themes[indexPath.row]
		let unlockedThemes = self.unlockable.currentlyUnlockedThemes()
		let color = self.unlockable.colorFor(Theme: selectedTheme)
		
		if unlockedThemes.contains(selectedTheme) {
			print("[INFO] \(selectedTheme) Theme Selected.")
			self.unlockable.changeTheme(To: selectedTheme)
			if let cell = self.tableView.cellForRow(at: indexPath) as? UnlockCell {
				cell.costLabel.text = "●"
				cell.costLabel.font = UIFont(name: "Avenir Next Medium", size: 32.0)
			}
			self.headingView.backgroundColor = color
		}
		else {
			self.presentPurchaseAlert(theme: selectedTheme, cost: 250)
		}
	}
}

extension ThemesVC: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return themes.count }
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let selectedTheme = self.themes[indexPath.row]
		let currentTheme = self.unlockable.currentTheme()
		let unlockedThemes = self.unlockable.currentlyUnlockedThemes()
		let color = self.unlockable.colorFor(Theme: selectedTheme)

		let cell = self.tableView.dequeueReusableCell(withIdentifier: "UnlockCell", for: indexPath) as! UnlockCell
			
		cell.title.text = selectedTheme
		cell.costLabel.textColor = color
		cell.cellView.backgroundColor = color
		
		if selectedTheme == currentTheme {
			cell.costLabel.text = "●"
			cell.costLabel.font = UIFont(name: "Avenir Next Medium", size: 32.0)
		}
		else if unlockedThemes.contains(selectedTheme) && !(selectedTheme == currentTheme) {
			cell.costLabel.text = " "
			cell.costLabel.font = UIFont(name: "Avenir Next Medium", size: 32.0)
		}
		else {
			let str = self.unlockable.addBubbleIconTo(String: "250 ", Color: color, Size: nil, Offset: nil)
			cell.costLabel.attributedText = str
		}
		
		return cell
	}
}
