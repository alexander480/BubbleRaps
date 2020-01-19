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
		let unlockedThemes = self.unlockable.currentlyUnlockedThemes()
		let selectedTheme = self.themes[indexPath.row]
		
		print("[INFO] \(selectedTheme) Theme Selected")
		
		if unlockedThemes.contains(selectedTheme) {
			if let cell = self.tableView.cellForRow(at: indexPath) as? UnlockCell { cell.costLabel.text = "●" }
			self.tableView.reloadData()
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
		let selectedThemeColor = self.unlockable.colorFor(Theme: selectedTheme)
		
		let unlockedThemes = self.unlockable.currentlyUnlockedThemes()

		let cell = self.tableView.dequeueReusableCell(withIdentifier: "UnlockCell", for: indexPath) as! UnlockCell
			cell.title.text = selectedTheme
			cell.cellView.backgroundColor = selectedThemeColor
		
		cell.costLabel.attributedText = self.unlockable.addBubbleIconTo(String: "250 ", Color: selectedThemeColor, Size: nil, Offset: nil)
		
		if unlockedThemes.contains(selectedTheme) {
			cell.costLabel.text = "●"
			cell.costLabel.textColor = selectedThemeColor
		}
		
		return cell
	}
}

/*
class ThemeVC: UIViewController {
	
	// MARK: Class Variables
	
	let unlockable = UnlockableHelper()

	// MARK: Storyboard Outlets
	
	@IBOutlet var mainView: UIView!
	@IBOutlet weak var headingView: UIView!
	@IBOutlet weak var collectionView: UICollectionView!
	
	@IBOutlet weak var backButton: UIButton!
	@IBAction func backAction(_ sender: Any) {
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
	
	@IBAction func holdTitleAction(_ sender: Any) {
		// MARK: Uncomment Following Lines To Enable Reseting Unlocked Themes
		UserDefaults.standard.set(["Purpink", "Dark Purpink"], forKey: "unlockedThemes")
		self.collectionView.reloadData()
	}
	
	// MARK: Override Functions
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.collectionView.delegate = self
		self.collectionView.dataSource = self
	}
	
	override func viewWillAppear(_ animated: Bool) {
		self.mainView.backgroundColor = self.unlockable.colorForCurrentTheme()
		self.bubbleButton.setAttributedTitleForAllStates(title: self.unlockable.bubbleBalanceWithIcon())
	}
	
	// MARK: Purchase Theme UI Handler
	private func presentPurchaseAlert(theme: String, cost: Int) {
		let alert = UIAlertController(title: "Purchase \(theme) Theme", message: "This theme costs \(cost) bubbles.", preferredStyle: .alert)
		let purchaseAction = UIAlertAction(title: "Purchase", style: .default) { (action) in
			switch self.unlockable.purchaseTheme(Named: theme, Cost: cost) {
			case .success:
				self.presentAlert(title: "\(theme) Theme Unlocked!", message: "You have \(self.unlockable.currentBubbleBalance()) bubbles remaining.", actions: nil)
				self.bubbleButton.setAttributedTitleForAllStates(title: self.unlockable.bubbleBalanceWithIcon())
				self.collectionView.reloadData()
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

// MARK: Did Select Cell

extension ThemeVC: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let unlockedThemes = self.unlockable.currentlyUnlockedThemes()
		let selectedColor = self.unlockable.allThemes[indexPath.row]
		
		if unlockedThemes.contains(selectedColor) {
			if let cell = collectionView.cellForItem(at: indexPath) as? UnlockedThemeCell {
				cell.imageView.isHidden = false
				cell.imageView.image = #imageLiteral(resourceName: "Selected Icon")
			}
			
			self.mainView.backgroundColor = self.unlockable.colorFor(Theme: selectedColor)
			self.unlockable.changeTheme(To: selectedColor)
			
			self.collectionView.reloadData()
		}
		else {
			self.presentPurchaseAlert(theme: selectedColor, cost: 250)
		}
	}
}

// MARK: UICollectionViewCell Setup

extension ThemeVC: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { return self.unlockable.allThemes.count }
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cellTheme = self.unlockable.allThemes[indexPath.item]
		
		if self.unlockable.currentlyUnlockedThemes().contains(cellTheme) {
			let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "UnlockedThemeCell", for: indexPath) as! UnlockedThemeCell
			cell.backgroundColor = self.unlockable.colorFor(Theme: cellTheme)
			
			if cellTheme == self.unlockable.currentTheme() {
				cell.imageView.isHidden = false
				cell.imageView.image = #imageLiteral(resourceName: "Selected Icon")
			}
			else {
				cell.imageView.isHidden = true
			}
			
			return cell
		}
		else {
			let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "LockedThemeCell", for: indexPath) as! LockedThemeCell
				cell.backgroundColor = self.unlockable.colorFor(Theme: cellTheme)
				cell.titleLabel.attributedText = self.unlockable.addBubbleIconTo(String: "250 ", Color: #colorLiteral(red: 0.2427230775, green: 0.6916770339, blue: 1, alpha: 1), Size: nil)
			
			return cell
		}
	}
}

// MARK: UICollectionView Layout

extension ThemeVC: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let screenWidth = UIScreen.main.bounds.width
		return CGSize(width: screenWidth/3, height: screenWidth/3)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return CGFloat(integerLiteral: 0)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return CGFloat(integerLiteral: 0)
	}
}

// MARK: Custom UICollectionViewCells

class LockedThemeCell: UICollectionViewCell {
	@IBOutlet weak var titleLabel: UILabel!
}

class UnlockedThemeCell: UICollectionViewCell {
	@IBOutlet weak var imageView: UIImageView!
}
*/
