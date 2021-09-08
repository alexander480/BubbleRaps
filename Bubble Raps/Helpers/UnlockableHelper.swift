//
//  PurchaseHelper.swift
//  RhymingBubbles
//
//  Created by Alexander Lester on 9/14/19.
//  Copyright © 2019 Delta Vel. All rights reserved.
//

import Foundation
import UIKit

enum UnlockableStatus {
	case success
	case notEnoughBubbles
	case alreadyUnlocked
}

struct UnlockableHelper  {
	
	static let allThemes: [String] = ["Purpink", "Dark Purpink", "Purple", "Dark Purple", "Blue", "Dark Blue", "Gray", "Dark Gray"]
	static let allPacks: [String] = ["Standard", "Fashion", "Football", "Money", "Jewelry", "Cars"]
	
	// -- Unlock Themes
	
	static func purchaseTheme(Named: String, Cost: Int) -> UnlockableStatus {
		if self.doesUserHaveEnoughBubbles(Cost: Cost) {
			if UnlockableHelper.fetchUnlockedThemes().contains(Named) {
				print("[WARNING] User Has Already Unlocked \(Named) Theme.")
				
				return .alreadyUnlocked
			}
			else {
				self.subtractBubbles(Amount: Cost)
				self.unlockTheme(Named: Named)
				
				return .success
			}
		}
		else {
			print("[WARNING] User Does Not Have Enough Bubbles To Purchase This Theme.")
			
			return .notEnoughBubbles
		}
	}
	
	static func unlockTheme(Named: String) {
		guard let currentlyUnlockedThemes = UserDefaults.standard.array(forKey: "unlockedThemes") as? [String]
		else { UserDefaults.standard.set(["Purpink", "\(Named)"], forKey: "unlockedThemes"); return }
		
		var newUnlockedThemes = currentlyUnlockedThemes
		newUnlockedThemes.append(Named)
		
		UserDefaults.standard.set(newUnlockedThemes, forKey: "unlockedThemes")
		print("[INFO] \(Named) Theme Unlocked!")
	}
	
	static func fetchUnlockedThemes() -> [String] {
		if let unlocked = UserDefaults.standard.array(forKey: "unlockedThemes") as? [String] {
			print("[INFO] Unlocked Themes: \(unlocked).")
			return unlocked
		} else {
			print("[WARNING] Failed To Validate Unlocked Themes. [INFO] Updating User Defaults Now.")
			UserDefaults.standard.set(["Purpink"], forKey: "unlockedThemes")
			return ["Purpink"]
		}
	}
	
	// -- Unlock Word Packs
	
	static func purchasePack(Named: String, Cost: Int) -> UnlockableStatus {
		if self.doesUserHaveEnoughBubbles(Cost: Cost) {
			if UnlockableHelper.fetchUnlockedPacks().contains(Named) {
				print("[WARNING] User Has Already Unlocked \(Named) Word Pack.")
				
				return .alreadyUnlocked
			}
			else {
				self.subtractBubbles(Amount: Cost)
				self.unlockPack(Named: Named)
				
				return .success
			}
		}
		else {
			print("[WARNING] User Does Not Have Enough Bubbles To Purchase This Word Pack.")
			
			return .notEnoughBubbles
		}
	}
	
	static func unlockPack(Named: String) {
		guard let currentlyUnlockedPacks = UserDefaults.standard.array(forKey: "unlockedPacks") as? [String] else {
			UserDefaults.standard.set(["Standard", "\(Named)"], forKey: "unlockedPacks")
			return
		}
		
		var newUnlockedPacks = currentlyUnlockedPacks
		newUnlockedPacks.append(Named)
		
		UserDefaults.standard.set(newUnlockedPacks, forKey: "unlockedPacks")
		print("[INFO] \(Named) Word Pack Unlocked!")
	}
	
	static func fetchUnlockedPacks() -> [String] {
		if let unlockedPacks = UserDefaults.standard.array(forKey: "unlockedPacks") as? [String] {
			print("[INFO] Unlocked Word Packs: \(unlockedPacks).")
			return unlockedPacks
		} else {
			print("[WARNING] Failed To Validate Unlocked Packs. [INFO] Updating User Defaults Now.")
			UserDefaults.standard.set(["Standard"], forKey: "unlockedPacks")
			return ["Standard"]
		}
	}
	
	
	// MARK: Coin Functions
	
	static func currentBubbleBalance() -> Int {
		return UserDefaults.standard.integer(forKey: "bubbles")
	}
	
	static func addBubbles(Amount: Int) {
		let currentBubbles = UserDefaults.standard.integer(forKey: "bubbles")
		UserDefaults.standard.set(currentBubbles + Amount, forKey: "bubbles")
	}
	
	static func subtractBubbles(Amount: Int) {
		let currentBubbles = UserDefaults.standard.integer(forKey: "bubbles")
		UserDefaults.standard.set(currentBubbles - Amount, forKey: "bubbles")
	}
	
	static func doesUserHaveEnoughBubbles(Cost: Int) -> Bool {
		let currentBubbles = UserDefaults.standard.integer(forKey: "bubbles")
		let remainingBubbles = currentBubbles - Cost
		if remainingBubbles >= 0 { return true } else { return false }
	}
	
	static func addBubbleIconTo(String: String, Color: UIColor?, Size: CGFloat?, Offset: CGFloat?) -> NSMutableAttributedString {
		let str = NSMutableAttributedString(string: String)
		let themedIcon = theme.assets.currencyImage
		let icon = theme.iconImageFor(Color: Color ?? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
		if let font = UIFont(name: "AvenirNext-HeavyItalic", size: Size ?? 14.0) {
			str.addAttribute(.font, value: font, range: NSRange(location: 0, length: str.length))
			str.addAttribute(.foregroundColor, value: Color ?? UIColor.white, range: NSRange(location: 0, length: str.length))
			str.add(Image: icon, WithOffset: Offset ?? -3.25)
		}
		
		return str
	}
	
	static func bubbleBalanceWithIcon() -> NSMutableAttributedString {
		let str = NSMutableAttributedString(string: "\(self.currentBubbleBalance()) ")
		if let font = UIFont(name: "AvenirNext-HeavyItalic", size: 14.0) {
			str.addAttribute(.font, value: font, range: NSRange(location: 0, length: str.length))
			str.addAttribute(.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: str.length))
			str.add(Image: #imageLiteral(resourceName: "Bubble Currency Small (White)"), WithOffset: -4.15)
		}
		
		return str
	}
}

// MARK: WordPacks Struct

//extension UnlockableHelper {
//	func getShuffledWordPack(Named: String?) -> [String] {
//		let wordPacks = WordPacks()
//		return wordPacks.packs[Named ?? "Standard"]?.shuffled() ?? wordPacks.standard.shuffled()
//	}
//
//	func getShuffledWordPack(FromIndex: Int) -> [String] {
//		let wordPacks = WordPacks()
//		let named = wordPacks.keys[FromIndex]
//		return wordPacks.packs[named]?.shuffled() ?? wordPacks.standard.shuffled()
//	}
//
//	func getWordPackKey(FromIndex: Int) -> String {
//		return WordPacks().keys[FromIndex]
//	}
//}
