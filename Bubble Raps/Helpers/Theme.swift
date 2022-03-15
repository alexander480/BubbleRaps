//
//  Theme.swift
//  Theme
//
//  Created by Alexander Lester on 9/22/21.
//  Copyright © 2021 Delta Vel. All rights reserved.
//

import UIKit

struct Theme {
	static let allThemes = ["Purpink", "Dark Purpink", "Purple", "Dark Purple", "Blue", "Dark Blue", "Gray", "Dark Gray"]
	
	static let primaryColors: [String: UIColor] = ["Purpink": #colorLiteral(red: 0.937254902, green: 0.7607843137, blue: 1, alpha: 1), "Dark Purpink": #colorLiteral(red: 0.937254902, green: 0.5058823529, blue: 0.862745098, alpha: 1), "Purple": #colorLiteral(red: 0.7843137255, green: 0.6039215686, blue: 1, alpha: 1), "Dark Purple": #colorLiteral(red: 0.6235294118, green: 0.3960784314, blue: 0.8941176471, alpha: 1), "Blue": #colorLiteral(red: 0.5725490196, green: 0.7254901961, blue: 1, alpha: 1), "Dark Blue": #colorLiteral(red: 0.337254902, green: 0.5529411765, blue: 0.937254902, alpha: 1), "Gray": #colorLiteral(red: 0.6941176471, green: 0.6941176471, blue: 0.6941176471, alpha: 1), "Dark Gray": #colorLiteral(red: 0.431372549, green: 0.431372549, blue: 0.431372549, alpha: 1), "White": #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
	static func primary() -> UIColor { return Theme.primaryColors[Theme.currentTheme()] ?? #colorLiteral(red: 0.937254902, green: 0.7607843137, blue: 1, alpha: 1) }
	
	static let secondaryColors: [String: UIColor] = ["Purpink": #colorLiteral(red: 0.9529411765, green: 0.8196078431, blue: 1, alpha: 1), "Dark Purpink": #colorLiteral(red: 1, green: 0.6392156863, blue: 0.937254902, alpha: 1), "Purple": #colorLiteral(red: 0.8470588235, green: 0.7215686275, blue: 1, alpha: 1), "Dark Purple": #colorLiteral(red: 0.7490196078, green: 0.5411764706, blue: 1, alpha: 1), "Blue": #colorLiteral(red: 0.7215686275, green: 0.8196078431, blue: 1, alpha: 1), "Dark Blue": #colorLiteral(red: 0.4941176471, green: 0.6705882353, blue: 0.9803921569, alpha: 1), "Gray": #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), "Dark Gray": #colorLiteral(red: 0.5490196078, green: 0.5490196078, blue: 0.5490196078, alpha: 1)]
	static func secondary() -> UIColor { return Theme.secondaryColors[Theme.currentTheme()] ?? #colorLiteral(red: 0.9529411765, green: 0.8196078431, blue: 1, alpha: 1) }
	
	static let bubbleImages: [String: UIImage] = ["Purpink": #imageLiteral(resourceName: "Selection Bubble"), "Dark Purpink": #imageLiteral(resourceName: "Dark Pink Bubble"), "Purple": #imageLiteral(resourceName: "Light Purple Bubble"), "Dark Purple": #imageLiteral(resourceName: "Dark Purple Bubble"), "Blue": #imageLiteral(resourceName: "Light Blue Bubble"), "Dark Blue": #imageLiteral(resourceName: "Dark Blue Bubble"), "Gray": #imageLiteral(resourceName: "Light Gray Bubble"), "Dark Gray": #imageLiteral(resourceName: "Dark Gray Bubble")]
	static func bubbleImage() -> UIImage { return Theme.bubbleImages[Theme.currentTheme()] ?? #imageLiteral(resourceName: "Selection Bubble") }
	
	static let bubbleIcons: [UIColor: UIImage] = [#colorLiteral(red: 0.937254902, green: 0.7607843137, blue: 1, alpha: 1): #imageLiteral(resourceName: "Purpink Icon"), #colorLiteral(red: 0.937254902, green: 0.5058823529, blue: 0.862745098, alpha: 1): #imageLiteral(resourceName: "Dark Purpink Icon"), #colorLiteral(red: 0.7843137255, green: 0.6039215686, blue: 1, alpha: 1): #imageLiteral(resourceName: "Light Purple Icon"), #colorLiteral(red: 0.6235294118, green: 0.3960784314, blue: 0.8941176471, alpha: 1): #imageLiteral(resourceName: "Dark Purple Icon"), #colorLiteral(red: 0.5725490196, green: 0.7254901961, blue: 1, alpha: 1): #imageLiteral(resourceName: "Light Blue Icon"), #colorLiteral(red: 0.337254902, green: 0.5529411765, blue: 0.937254902, alpha: 1): #imageLiteral(resourceName: "Dark Blue Icon"), #colorLiteral(red: 0.6941176471, green: 0.6941176471, blue: 0.6941176471, alpha: 1): #imageLiteral(resourceName: "Light Gray Icon"), #colorLiteral(red: 0.431372549, green: 0.431372549, blue: 0.431372549, alpha: 1): #imageLiteral(resourceName: "Dark Gray Icon"), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1): #imageLiteral(resourceName: "Bubble Currency Small (White)")]
	static func bubbleIcon(forColor: UIColor) -> UIImage { return Theme.bubbleIcons[forColor] ?? #imageLiteral(resourceName: "Bubble Currency Small (White)") }
	
	static let tabImages: [String: UIImage] = ["Purpink": #imageLiteral(resourceName: "Theme Tab"), "Dark Purpink": #imageLiteral(resourceName: "Dark Purpink Theme Tab"), "Purple": #imageLiteral(resourceName: "Light Purple Theme Tab"), "Dark Purple": #imageLiteral(resourceName: "Dark Purple Theme Tab"), "Blue": #imageLiteral(resourceName: "Light Blue Theme Tab"), "Dark Blue": #imageLiteral(resourceName: "Dark Blue Theme Tab"), "Gray": #imageLiteral(resourceName: "Light Gray Theme Tab"), "Dark Gray": #imageLiteral(resourceName: "Dark Gray Theme Tab")]
	static func tabImage() -> UIImage { return Theme.tabImages[Theme.currentTheme()] ?? #imageLiteral(resourceName: "Theme Tab") }
	
	static let logoImages: [String: UIImage] = ["Purpink": #imageLiteral(resourceName: "Purpink Logo"), "Dark Purpink": #imageLiteral(resourceName: "Dark Purpink Logo"), "Purple": #imageLiteral(resourceName: "Light Purple Logo"), "Dark Purple": #imageLiteral(resourceName: "Dark Purple Logo"), "Blue": #imageLiteral(resourceName: "Light Blue Logo"), "Dark Blue": #imageLiteral(resourceName: "Dark Blue Logo"), "Gray": #imageLiteral(resourceName: "Light Gray Logo"), "Dark Gray": #imageLiteral(resourceName: "Dark Gray Logo")]
	static func logoImage() -> UIImage { return Theme.logoImages[Theme.currentTheme()] ?? #imageLiteral(resourceName: "Purpink Logo") }
	
	static func color(forTheme: String) -> UIColor { return Theme.primaryColors[forTheme] ?? #colorLiteral(red: 0.937254902, green: 0.7607843137, blue: 1, alpha: 1) }
	
	static func addBubbleIconTo(_ string: String, color: UIColor = .white, size: CGFloat = 14.0, offset: CGFloat = -3.25) -> NSMutableAttributedString {
		let icon = Theme.bubbleIcon(forColor: color)
		let font = UIFont(name: "AvenirNext-HeavyItalic", size: size) ?? UIFont.systemFont(ofSize: size, weight: .heavy)
		
		let str = NSMutableAttributedString(string: string)
			str.addAttribute(.font, value: font, range: NSRange(location: 0, length: str.length))
			str.addAttribute(.foregroundColor, value: color, range: NSRange(location: 0, length: str.length))
			str.add(Image: icon, WithOffset: offset)
		
		return str
	}
}

// MARK: Change / Retrieve Current Theme

extension Theme {
	static func currentTheme() -> String {
		guard let currentTheme = UserDefaults.standard.string(forKey: "theme") else {
			UserDefaults.standard.set("Purpink", forKey: "theme")
			return "Purpink"
		}
		
		return currentTheme
	}
	
	static func changeTheme(_ themeName: String) -> Bool {
		if Theme.unlocked().contains(themeName) { UserDefaults.standard.set(themeName, forKey: "theme"); return true }
		else { return false }
	}
}

// MARK: Purchase / Unlock Themes

extension Theme {
	static let themeCost = 250
	
	static func purchase(_ themeName: String) -> UnlockableStatus {
		if (Theme.unlocked().contains(themeName)) { print("[WARNING] User Has Already Unlocked \(themeName) Theme."); return .alreadyUnlocked }
		if !(Theme.themeCost > Currency.currentBubbleBalance()) { print("[WARNING] User Does Not Have Enough Bubbles To Purchase This Theme."); return .notEnoughBubbles }
		
		Currency.subtractBubbles(Amount: Theme.themeCost)
		Theme.unlock(themeName)
		
		return .success
	}
	
	static func unlock(_ themeName: String) {
		var newUnlockedThemes = Theme.unlocked()
			newUnlockedThemes.append(themeName)
		
		UserDefaults.standard.set(newUnlockedThemes, forKey: "unlockedThemes")
		print("[INFO] \(themeName) Theme Unlocked!")
	}
	
	// -----
	
	static func unlocked() -> [String] {
		guard let unlockedThemes = UserDefaults.standard.array(forKey: "unlockedThemes") as? [String] else {
			UserDefaults.standard.set(["Purpink"], forKey: "unlockedThemes"); return ["Purpink"]
		}
		
		return unlockedThemes
	}
}
