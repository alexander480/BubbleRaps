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

class UnlockableHelper: NSObject  {
	
	// MARK: Class Variables
	
	// let unlockedThemes = UserDefaults.standard.array(forKey: "unlockedThemes") as? [String]
	// let unlockedPacks = UserDefaults.standard.array(forKey: "unlockedPacks") as? [String]
	
	// MARK: Coin Purchasing Functions
	
	func purchaseTheme(Named: String, Cost: Int) -> UnlockableStatus {
		if self.doesUserHaveEnoughBubbles(Cost: Cost) {
			if self.doesUserHaveTheme(Named: Named) {
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
	
	func purchasePack(Named: String, Cost: Int) -> UnlockableStatus {
		if self.doesUserHaveEnoughBubbles(Cost: Cost) {
			if self.doesUserHavePack(Named: Named) {
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
	
	// MARK: Coin Functions
	
	func currentBubbleBalance() -> Int {
		return UserDefaults.standard.integer(forKey: "bubbles")
	}
	
	func addBubbles(Amount: Int) {
		let currentBubbles = UserDefaults.standard.integer(forKey: "bubbles")
		UserDefaults.standard.set(currentBubbles + Amount, forKey: "bubbles")
	}
	
	func subtractBubbles(Amount: Int) {
		let currentBubbles = UserDefaults.standard.integer(forKey: "bubbles")
		UserDefaults.standard.set(currentBubbles - Amount, forKey: "bubbles")
	}
	
	func doesUserHaveEnoughBubbles(Cost: Int) -> Bool {
		let currentBubbles = UserDefaults.standard.integer(forKey: "bubbles")
		let remainingBubbles = currentBubbles - Cost
		if remainingBubbles >= 0 { return true } else { return false }
	}
	
	func addBubbleIconTo(String: String, Color: UIColor?, Size: CGFloat?) -> NSMutableAttributedString {
		let str = NSMutableAttributedString(string: String)
		if let font = UIFont(name: "AvenirNext-HeavyItalic", size: Size ?? 14.0) {
			str.addAttribute(.font, value: font, range: NSRange(location: 0, length: str.length))
			str.addAttribute(.foregroundColor, value: Color ?? UIColor.white, range: NSRange(location: 0, length: str.length))
			
			if Color == UIColor.white { str.add(Image: #imageLiteral(resourceName: "Bubble Currency Small (White)"), WithOffset: -3.25) }
			else { str.add(Image: #imageLiteral(resourceName: "Bubble Currency Small"), WithOffset: -3.25) }
		}
		
		return str
	}
	
	func bubbleBalanceWithIcon() -> NSMutableAttributedString {
		let str = NSMutableAttributedString(string: "\(self.currentBubbleBalance()) ")
		if let font = UIFont(name: "AvenirNext-HeavyItalic", size: 14.0) {
			str.addAttribute(.font, value: font, range: NSRange(location: 0, length: str.length))
			str.addAttribute(.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: str.length))
			str.add(Image: #imageLiteral(resourceName: "Bubble Currency Small (White)"), WithOffset: -4.15)
		}
		
		return str
	}
	
	// MARK: Theme Functions
	
	let allThemes = ["Purpink", "Dark Purpink", "Purple", "Dark Purple", "Blue", "Dark Blue", "Gray", "Dark Gray"]
	
	func currentTheme() -> String {
		guard let currentTheme = UserDefaults.standard.string(forKey: "theme") else {
			UserDefaults.standard.set("Purpink", forKey: "theme")
			return "Purpink"
		}
		
		return currentTheme
	}
	
	func changeTheme(To: String) {
		if self.currentlyUnlockedThemes().contains(To) { UserDefaults.standard.set(To, forKey: "theme") }
		else { return }
	}
	
	func currentlyUnlockedThemes() -> [String] {
		guard let unlockedThemes = UserDefaults.standard.array(forKey: "unlockedThemes") as? [String] else {
			UserDefaults.standard.set(["Purpink"], forKey: "unlockedThemes");
			return ["Purpink"]
		}
		
		return unlockedThemes
	}
	
	func unlockTheme(Named: String) {
		guard let currentlyUnlockedThemes = UserDefaults.standard.array(forKey: "unlockedThemes") as? [String]
		else { UserDefaults.standard.set(["Purpink", "\(Named)"], forKey: "unlockedThemes"); return }
		
		var newUnlockedThemes = currentlyUnlockedThemes
			newUnlockedThemes.append(Named)
		
		UserDefaults.standard.set(newUnlockedThemes, forKey: "unlockedThemes")
		print("[INFO] \(Named) Theme Unlocked!")
	}
	
	func doesUserHaveTheme(Named: String) -> Bool {
		guard let unlockedThemes = UserDefaults.standard.array(forKey: "unlockedThemes") as? [String] else { UserDefaults.standard.set(["Purpink"], forKey: "unlockedThemes")
			return false
		}
		
		if unlockedThemes.contains(Named) { return true }
		else { return false }
	}
	
	func validateUnlockedThemes() { let _ = self.doesUserHaveTheme(Named: "Purpink") }
	
	// MARK: Word Pack Unlocking Functions
	
	func validateUnlockedPacks() { let _ = self.doesUserHavePack(Named: "Standard") }
	
	func currentlyUnlockedPacks() -> [String] {
		guard let unlockedPacks = UserDefaults.standard.array(forKey: "unlockedPacks") as? [String] else {
			UserDefaults.standard.set(["Standard"], forKey: "unlockedPacks")
			return ["Standard"]
		}
		return unlockedPacks
	}
	
	func unlockPack(Named: String) {
		guard let currentlyUnlockedPacks = UserDefaults.standard.array(forKey: "unlockedPacks") as? [String]
		else { UserDefaults.standard.set(["Standard", "\(Named)"], forKey: "unlockedPacks"); return }
		
		var newUnlockedPacks = currentlyUnlockedPacks
			newUnlockedPacks.append(Named)
		
		UserDefaults.standard.set(newUnlockedPacks, forKey: "unlockedPacks")
		print("[INFO] \(Named) Word Pack Unlocked!")
	}
	
	func doesUserHavePack(Named: String) -> Bool {
		guard let unlockedPacks = UserDefaults.standard.array(forKey: "unlockedPacks") as? [String] else { UserDefaults.standard.set(["Standard"], forKey: "unlockedPacks")
			return false
		}
		
		if unlockedPacks.contains(Named) { return true }
		else { return false }
	}
}

// MARK: Themes Struct and Helper Functions

struct Themes {
	let themeColors: [String: UIColor] = ["Purpink": #colorLiteral(red: 0.937254902, green: 0.7607843137, blue: 1, alpha: 1), "Dark Purpink": #colorLiteral(red: 0.937254902, green: 0.5058823529, blue: 0.862745098, alpha: 1), "Purple": #colorLiteral(red: 0.7843137255, green: 0.6039215686, blue: 1, alpha: 1), "Dark Purple": #colorLiteral(red: 0.6235294118, green: 0.3960784314, blue: 0.8941176471, alpha: 1), "Blue": #colorLiteral(red: 0.5725490196, green: 0.7254901961, blue: 1, alpha: 1), "Dark Blue": #colorLiteral(red: 0.337254902, green: 0.5529411765, blue: 0.937254902, alpha: 1), "Gray": #colorLiteral(red: 0.6941176471, green: 0.6941176471, blue: 0.6941176471, alpha: 1), "Dark Gray": #colorLiteral(red: 0.431372549, green: 0.431372549, blue: 0.431372549, alpha: 1)]
	let borderColors: [String: UIColor] = ["Purpink": #colorLiteral(red: 0.9529411765, green: 0.8196078431, blue: 1, alpha: 1), "Dark Purpink": #colorLiteral(red: 1, green: 0.6392156863, blue: 0.937254902, alpha: 1), "Purple": #colorLiteral(red: 0.8470588235, green: 0.7215686275, blue: 1, alpha: 1), "Dark Purple": #colorLiteral(red: 0.7490196078, green: 0.5411764706, blue: 1, alpha: 1), "Blue": #colorLiteral(red: 0.7215686275, green: 0.8196078431, blue: 1, alpha: 1), "Dark Blue": #colorLiteral(red: 0.4941176471, green: 0.6705882353, blue: 0.9803921569, alpha: 1), "Gray": #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), "Dark Gray": #colorLiteral(red: 0.5490196078, green: 0.5490196078, blue: 0.5490196078, alpha: 1)]
	let themedThemeTabs: [String: UIImage] = ["Purpink": #imageLiteral(resourceName: "Theme Tab"), "Dark Purpink": #imageLiteral(resourceName: "Dark Purpink Theme Tab"), "Purple": #imageLiteral(resourceName: "Light Purple Theme Tab"), "Dark Purple": #imageLiteral(resourceName: "Dark Purple Theme Tab"), "Blue": #imageLiteral(resourceName: "Light Blue Theme Tab"), "Dark Blue": #imageLiteral(resourceName: "Dark Blue Theme Tab"), "Gray": #imageLiteral(resourceName: "Light Gray Theme Tab"), "Dark Gray": #imageLiteral(resourceName: "Dark Gray Theme Tab")]
	let themedBubbles: [String: UIImage] = ["Purpink": #imageLiteral(resourceName: "Selection Bubble"), "Dark Purpink": #imageLiteral(resourceName: "Dark Pink Bubble"), "Purple": #imageLiteral(resourceName: "Light Purple Bubble"), "Dark Purple": #imageLiteral(resourceName: "Dark Purple Bubble"), "Blue": #imageLiteral(resourceName: "Light Blue Bubble"), "Dark Blue": #imageLiteral(resourceName: "Dark Blue Bubble"), "Gray": #imageLiteral(resourceName: "Light Gray Bubble"), "Dark Gray": #imageLiteral(resourceName: "Dark Gray Bubble")]
	let themedLogos: [String: UIImage] = ["Purpink": #imageLiteral(resourceName: "Purpink Logo"), "Dark Purpink": #imageLiteral(resourceName: "Dark Purpink Logo"), "Purple": #imageLiteral(resourceName: "Light Purple Logo"), "Dark Purple": #imageLiteral(resourceName: "Dark Purple Logo"), "Blue": #imageLiteral(resourceName: "Light Blue Logo"), "Dark Blue": #imageLiteral(resourceName: "Dark Blue Logo"), "Gray": #imageLiteral(resourceName: "Light Gray Logo"), "Dark Gray": #imageLiteral(resourceName: "Dark Gray Logo")]
}

extension UnlockableHelper {
	func colorForCurrentTheme() -> UIColor { return Themes().themeColors[self.currentTheme()] ?? #colorLiteral(red: 0.937254902, green: 0.7607843137, blue: 1, alpha: 1) }
	
	func colorFor(Theme: String) -> UIColor { return Themes().themeColors[Theme] ?? #colorLiteral(red: 0.937254902, green: 0.7607843137, blue: 1, alpha: 1) }
	func borderColorFor(Theme: String) -> UIColor { return Themes().borderColors[Theme] ?? #colorLiteral(red: 0.9529411765, green: 0.8196078431, blue: 1, alpha: 1) }
	func tabImageFor(Theme: String) -> UIImage { return Themes().themedThemeTabs[Theme] ?? #imageLiteral(resourceName: "Theme Tab") }
	func bubbleImageFor(Theme: String) -> UIImage { return Themes().themedBubbles[Theme] ?? #imageLiteral(resourceName: "Selection Bubble") }
	func logoImageFor(Theme: String) -> UIImage { return Themes().themedLogos[Theme] ?? #imageLiteral(resourceName: "Purpink Logo") }
}

// MARK: WordPacks Struct


struct WordPacks {
	let keys = ["Standard", "Fashion", "Football"]
	let packs = ["Standard": ["shine", "made", "trust", "grand", "shed", "dance", "shape", "vapor", "fight", "cold", "grapple", "unicorn", "automobile", "cigarette", "sunny", "extension", "amaze", "focus", "noise", "scent", "shave", "control", "human", "crown", "shuffle", "amazing", "rhyme", "grind", "chance", "grand"], "Fashion": ["supreme", "leather", "louis", "tailor", "style", "footwear", "brand", "lingerie", "swagger", "dolce", "timberlands", "clothes", "vogue", "designer", "couture", "vuitton", "armani", "menswear", "prada", "trend", "escada", "versace", "glamour", "gucci"], "Football": ["fullback", "quarterback", "pigskin", "league", "punter", "tackle", "kick", "touchdown", "rusher", "championship", "coach", "fans", "center", "snapper", "kickoff", "player", "season", "game", "playoffs", "SuperBowl", "rings", "Lombardi", "packers", "lions", "cowboys", "bears", "browns", "seahawks", "colts", "chiefs", "bills", "redskins", "jets", "rams", "buccaneers", "jaguars", "Crews", "Brady", "Manning", "Favre", "Jackson", "Newton", "Brees", "Romo", "Bradshaw", "Montana", "Rice", "Fitzgerald", "Luck"]]
	
	let standard = ["shine", "made", "trust", "grand", "shed", "dance", "shape", "vapor", "fight", "cold", "grapple", "unicorn", "automobile", "cigarette", "sunny", "extension", "amaze", "focus", "noise", "scent", "shave", "control", "human", "crown", "shuffle", "amazing", "rhyme", "grind", "chance", "grand"]
	/*
	let fashion = ["supreme", "leather", "louis", "tailor", "style", "footwear", "brand", "lingerie", "swagger", "dolce", "timberlands", "clothes", "vogue", "designer", "couture", "vuitton", "armani", "menswear", "prada", "trend", "escada", "versace", "glamour", "gucci"]
	let football = ["fullback", "quarterback", "pigskin", "league", "punter", "tackle", "kick", "touchdown", "rusher", "championship", "coach", "fans", "center", "snapper", "kickoff", "player", "season", "game", "playoffs", "SuperBowl", "rings", "Lombardi", "packers", "lions", "cowboys", "bears", "browns", "seahawks", "colts", "chiefs", "bills", "redskins", "jets", "rams", "buccaneers", "jaguars", "Crews", "Brady", "Manning", "Favre", "Jackson", "Newton", "Brees", "Romo", "Bradshaw", "Montana", "Rice", "Fitzgerald", "Luck"]
	*/
}

extension UnlockableHelper {
	func getShuffledWordPack(Named: String?) -> [String] {
		let wordPacks = WordPacks()
		return wordPacks.packs[Named ?? "Standard"]?.shuffled() ?? wordPacks.standard.shuffled()
	}
	
	func getShuffledWordPack(FromIndex: Int) -> [String] {
		let wordPacks = WordPacks()
		let named = wordPacks.keys[FromIndex]
		return wordPacks.packs[named]?.shuffled() ?? wordPacks.standard.shuffled()
	}
	
	func getWordPackKey(FromIndex: Int) -> String {
		return WordPacks().keys[FromIndex]
	}
}
