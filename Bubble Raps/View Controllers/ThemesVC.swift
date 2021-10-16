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
	
	let themeCost = 250
	
	@IBOutlet weak var headingView: UIView!
	
	@IBOutlet weak var backButton: UIButton!
	@IBAction func backButtonAction(_ sender: Any) {
		if let presenter = self.presentingViewController as? MenuVC {
			presenter.themeButton.setImageForAllStates(image: Theme.tabImage())
			presenter.logoImage.image = Theme.logoImage()
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
	
	let themes = ["Purpink", "Dark Purpink", "Purple", "Dark Purple", "Blue", "Dark Blue", "Gray", "Dark Gray"]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Disable Dark Mode Support
		overrideUserInterfaceStyle = .light
		
		self.tableView.delegate = self
		self.tableView.dataSource = self
		
		self.headingView.backgroundColor = Theme.primary()
		self.bubbleButton.setAttributedTitleForAllStates(title: Currency.bubbleBalanceWithIcon())
	}
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		self.headingView.clipsToBounds = true
		self.headingView.roundCorners(corners: [UIRectCorner.bottomLeft, UIRectCorner.bottomRight], radius: 5.0)
		self.headingView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
	}
	
	private func presentThemePurchaseAlert(theme: String) {
		let alert = UIAlertController(title: "Unlock \(theme) Theme", message: "\(self.themeCost) Bubbles", preferredStyle: .actionSheet)
			let purchaseAction = UIAlertAction(title: "Confirm", style: .default) { (action) in
				switch Theme.purchase(theme) {
					case .success:
						self.presentAlert(title: "\(theme) Theme Unlocked!", message: "You have \(Currency.currentBubbleBalance()) bubbles remaining.", actions: nil)
						self.bubbleButton.setAttributedTitleForAllStates(title: Currency.bubbleBalanceWithIcon())
						self.tableView.reloadData()
					case .notEnoughBubbles:
						self.presentAlert(title: "Not Enough Bubbles!", message: "You need \(self.themeCost - Currency.currentBubbleBalance()) more bubbles to unlock this theme.", actions: nil)
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
		let color = Theme.color(forTheme: selectedTheme)
		
		// Did Change Theme (Theme Was Already Unlocked)
		if (Theme.changeTheme(selectedTheme)) {
			print("[INFO] \(selectedTheme) Theme Selected.")
			
			let cell = self.tableView.cellForRow(at: indexPath) as? UnlockCell
				cell?.costLabel.text = "✓"
				cell?.costLabel.font = UIFont(name: "Avenir Next Heavy", size: 42.0)
			
			self.headingView.backgroundColor = color

		} else {
			print("[WARNING] Did Not Change Theme. [MESSAGE] Theme is not unlocked.")
			self.presentThemePurchaseAlert(theme: selectedTheme)
		}
	}
	
	func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
		if let cell = self.tableView.cellForRow(at: indexPath) as? UnlockCell {
			cell.costLabel.text = " "
		}
	}
}

extension ThemesVC: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return themes.count }
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let unlockedThemes = Theme.unlocked()
		let currentTheme = Theme.currentTheme()
		
		let theme = self.themes[indexPath.row]
		let color = Theme.color(forTheme: theme)

		let cell = self.tableView.dequeueReusableCell(withIdentifier: "UnlockCell", for: indexPath) as! UnlockCell
			
		cell.title.text = theme
		cell.costLabel.textColor = color
		cell.cellView.backgroundColor = color
		
		if theme == currentTheme {
			cell.costLabel.text = "✓"
			cell.costLabel.font = UIFont(name: "Avenir Next Heavy", size: 42.0)
		}
		else if unlockedThemes.contains(theme) && !(theme == currentTheme) {
			cell.costLabel.text = " "
			cell.costLabel.font = UIFont(name: "Avenir Next Heavy", size: 42.0)
		}
		else {
			let str = Theme.addBubbleIconTo("\(self.themeCost) ", color: color)
			cell.costLabel.attributedText = str
		}
		
		return cell
	}
}
