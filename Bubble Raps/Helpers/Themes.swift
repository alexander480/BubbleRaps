//
//  Themes.swift
//  Bubble Raps
//
//  Created by Alexander Lester on 9/8/21.
//  Copyright © 2021 Delta Vel. All rights reserved.
//

import Foundation
import UIKit

struct Themes {
	
	// Variables
	// -------------------------
	
	var unlocked: [String] {
		get { return self.unlockedThemes() }
	}
	
	var current: String {
		get { return self.currentTheme() }
		
		/// Update In User Defaults & Reload Topics
		set(newTheme) {
			self.current = self.updateCurrentTheme(newTheme)
			self.assets = self.assetsFor(newTheme)
		}
	}
	
	var assets = ThemeAssets()
	
	// Methods
	// -------------------------
	
	private func unlockedThemes() -> [String] {
		if let unlockedThemes = UserDefaults.standard.array(forKey: "unlockedThemes") as? [String] {
			print("[INFO] Unlocked Themes: \(unlockedThemes).")
			return unlockedThemes
		} else {
			print("[WARNING] Failed To Validate Unlocked Themes. [INFO] Updating User Defaults Now.")
			UserDefaults.standard.set(["Purpink"], forKey: "unlockedThemes")
			return ["Purpink"]
		}
	}
	
	private func currentTheme() -> String {
		if let currentTheme = UserDefaults.standard.string(forKey: "theme") {
			print("[INFO] Current Theme: \(currentTheme).")
			return currentTheme
		} else {
			print("[WARNING] Failed To Validate Current Theme. [INFO] Updating User Defaults Now.")
			UserDefaults.standard.set("Purpink", forKey: "theme")
			return "Purpink"
		}
	}
	
	private func updateCurrentTheme(_ newTheme: String) -> String {
		if (self.unlocked.contains(newTheme)) {
			UserDefaults.standard.set(newTheme, forKey: "theme")
			print("[INFO] Theme Updated: \(newTheme)")
			return newTheme
		} else {
			print("[WARNING] Failed To Update Current Theme. [MESSAGE] Theme Has Not Been Unlocked.")
			print("[INFO] Reverting To Default Theme.")
			UserDefaults.standard.set("Purpink", forKey: "theme")
			return "Purpink"
		}
	}
	
	private func assetsFor(_ currentTheme: String) -> ThemeAssets {
		if (self.unlocked.contains(currentTheme)) {
			let assets = ThemeAssets(currentTheme: currentTheme)
			return assets
		} else {
			print("[WARNING] Failed To Update Assets. [MESSAGE] Theme Has Not Been Unlocked.")
			print("[INFO] Reverting To Default Assets.")
			let assets = ThemeAssets(currentTheme: "Purpink")
			return assets
		}
	}
}

struct ThemeAssets {
	
	// Struct Variables
	// -----------------------
	
	let primaryColor: UIColor
	let secondaryColor: UIColor
	
	let bubbleImage: UIImage
	let currencyImage: UIImage
	
	let logoImage: UIImage
	let tabImage: UIImage
	
	
	// Stored Variables
	// ------------------------
	
	private let allPrimaryColors: [String: UIColor] = ["Purpink": #colorLiteral(red: 0.937254902, green: 0.7607843137, blue: 1, alpha: 1), "Dark Purpink": #colorLiteral(red: 0.937254902, green: 0.5058823529, blue: 0.862745098, alpha: 1), "Purple": #colorLiteral(red: 0.7843137255, green: 0.6039215686, blue: 1, alpha: 1), "Dark Purple": #colorLiteral(red: 0.6235294118, green: 0.3960784314, blue: 0.8941176471, alpha: 1), "Blue": #colorLiteral(red: 0.5725490196, green: 0.7254901961, blue: 1, alpha: 1), "Dark Blue": #colorLiteral(red: 0.337254902, green: 0.5529411765, blue: 0.937254902, alpha: 1), "Gray": #colorLiteral(red: 0.6941176471, green: 0.6941176471, blue: 0.6941176471, alpha: 1), "Dark Gray": #colorLiteral(red: 0.431372549, green: 0.431372549, blue: 0.431372549, alpha: 1), "White": #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
	private let allSecondaryColors: [String: UIColor] = ["Purpink": #colorLiteral(red: 0.9529411765, green: 0.8196078431, blue: 1, alpha: 1), "Dark Purpink": #colorLiteral(red: 1, green: 0.6392156863, blue: 0.937254902, alpha: 1), "Purple": #colorLiteral(red: 0.8470588235, green: 0.7215686275, blue: 1, alpha: 1), "Dark Purple": #colorLiteral(red: 0.7490196078, green: 0.5411764706, blue: 1, alpha: 1), "Blue": #colorLiteral(red: 0.7215686275, green: 0.8196078431, blue: 1, alpha: 1), "Dark Blue": #colorLiteral(red: 0.4941176471, green: 0.6705882353, blue: 0.9803921569, alpha: 1), "Gray": #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), "Dark Gray": #colorLiteral(red: 0.5490196078, green: 0.5490196078, blue: 0.5490196078, alpha: 1)]
	
	private let allBubbleImages: [String: UIImage] = ["Purpink": #imageLiteral(resourceName: "Selection Bubble"), "Dark Purpink": #imageLiteral(resourceName: "Dark Pink Bubble"), "Purple": #imageLiteral(resourceName: "Light Purple Bubble"), "Dark Purple": #imageLiteral(resourceName: "Dark Purple Bubble"), "Blue": #imageLiteral(resourceName: "Light Blue Bubble"), "Dark Blue": #imageLiteral(resourceName: "Dark Blue Bubble"), "Gray": #imageLiteral(resourceName: "Light Gray Bubble"), "Dark Gray": #imageLiteral(resourceName: "Dark Gray Bubble")]
	private let allCurrencyImages: [String: UIImage] = ["Purpink": #imageLiteral(resourceName: "Purpink Icon"), "Dark Purpink": #imageLiteral(resourceName: "Dark Purpink Icon"), "Purple": #imageLiteral(resourceName: "Light Purple Icon"), "Dark Purple": #imageLiteral(resourceName: "Dark Purple Icon"), "Blue": #imageLiteral(resourceName: "Light Blue Icon"), "Dark Blue": #imageLiteral(resourceName: "Dark Blue Icon"), "Gray": #imageLiteral(resourceName: "Light Gray Icon"), "Dark Gray": #imageLiteral(resourceName: "Dark Gray Icon"), "White": #imageLiteral(resourceName: "Bubble Currency Small (White)")]
	
	private let allLogoImages: [String: UIImage] = ["Purpink": #imageLiteral(resourceName: "Purpink Logo"), "Dark Purpink": #imageLiteral(resourceName: "Dark Purpink Logo"), "Purple": #imageLiteral(resourceName: "Light Purple Logo"), "Dark Purple": #imageLiteral(resourceName: "Dark Purple Logo"), "Blue": #imageLiteral(resourceName: "Light Blue Logo"), "Dark Blue": #imageLiteral(resourceName: "Dark Blue Logo"), "Gray": #imageLiteral(resourceName: "Light Gray Logo"), "Dark Gray": #imageLiteral(resourceName: "Dark Gray Logo")]
	private let allTabImages: [String: UIImage] = ["Purpink": #imageLiteral(resourceName: "Theme Tab"), "Dark Purpink": #imageLiteral(resourceName: "Dark Purpink Theme Tab"), "Purple": #imageLiteral(resourceName: "Light Purple Theme Tab"), "Dark Purple": #imageLiteral(resourceName: "Dark Purple Theme Tab"), "Blue": #imageLiteral(resourceName: "Light Blue Theme Tab"), "Dark Blue": #imageLiteral(resourceName: "Dark Blue Theme Tab"), "Gray": #imageLiteral(resourceName: "Light Gray Theme Tab"), "Dark Gray": #imageLiteral(resourceName: "Dark Gray Theme Tab")]
	
	init(currentTheme: String = "Purpink") {
		self.primaryColor = self.allPrimaryColors[currentTheme] ?? #colorLiteral(red: 0.937254902, green: 0.7607843137, blue: 1, alpha: 1)
		self.secondaryColor = self.allSecondaryColors[currentTheme] ?? #colorLiteral(red: 0.9529411765, green: 0.8196078431, blue: 1, alpha: 1)
		self.bubbleImage = self.allBubbleImages[currentTheme] ?? #imageLiteral(resourceName: "Selection Bubble")
		self.currencyImage = self.allCurrencyImages[currentTheme] ?? #imageLiteral(resourceName: "Purpink Icon")
		self.logoImage = self.allLogoImages[currentTheme] ?? #imageLiteral(resourceName: "Purpink Logo")
		self.tabImage = self.allTabImages[currentTheme] ?? #imageLiteral(resourceName: "Theme Tab")
	}
}
