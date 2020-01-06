
//
//  MenuVC.swift
//  RhymingBubbles
//
//  Created by Alexander Lester on 7/31/19.
//  Copyright © 2019 Delta Vel. All rights reserved.
//

import UIKit
import GoogleMobileAds

// MARK: Uncomment The Following Import To Test Crashlytics (Step One)
// import Crashlytics

class MenuVC: UIViewController {
	
	// MARK: Class Variables
	
	let unlockable = UnlockableHelper()
	var rewardedAd: GADRewardedAd!
	
	var selectedPack = "Standard"
	var selectedPackIndex = 0
	
	// MARK: Storyboard Outlets
	
	@IBOutlet weak var highScoreMenuView: UIView!
	@IBOutlet weak var timerMenuView: UIView!
	@IBOutlet weak var wordPackMenuView: UIView!
	
	@IBOutlet weak var wordPackButton: UIButton!
	@IBAction func wordPackButtonAction(_ sender: Any) {
		if let wordPackVC = self.storyboard?.instantiateViewController(withIdentifier: "WordPackVC") as? WordPackVC {
			self.present(wordPackVC, animated: true, completion: nil)
		}
	}
	
	@IBOutlet weak var themeButton: UIButton!
	@IBAction func themeButtonAction(_ sender: Any) {
		if let themeVC = self.storyboard?.instantiateViewController(withIdentifier: "ThemeVC") as? ThemeVC {
			self.present(themeVC, animated: true, completion: nil)
		}
	}
	
	@IBOutlet weak var adButton: UIButton!
	@IBAction func adButtonAction(_ sender: Any) {
		self.adRequestAlert()
	}
	
	@IBOutlet weak var coinButton: UIButton!
	@IBAction func coinButtonAction(_ sender: Any) {
		if let coinVC = self.storyboard?.instantiateViewController(withIdentifier: "CoinVC") as? CoinVC {
			self.present(coinVC, animated: true, completion: nil)
		}
	}
	
	@IBOutlet weak var scoreLabel: UILabel!
	@IBOutlet weak var timerLabel: UILabel!
	@IBOutlet weak var packLabel: UILabel!
	
	@IBOutlet weak var beginButton: UIButton!
	@IBAction func beginAction(_ sender: Any) {
		if ReachabilityHelper.isConnectedToNetwork() {
			// MARK: Segue Often Crashes App For Some Reason
			self.performSegue(withIdentifier: "BeginSegue", sender: self)
		}
		else { self.presentAlert(title: "No Internet Connection!", message: "Please connect to the internet", actions: nil) }
	}
	
	@IBOutlet weak var logoImage: UIImageView!
	@IBOutlet var logoTap: UITapGestureRecognizer!
	@IBAction func logoTapAction(_ sender: Any) {
		// self.toggleDarkMode()
	}

	@IBOutlet var scorePress: UILongPressGestureRecognizer!
	@IBAction func scorePressAction(_ sender: Any) { self.resetHighScore() }
	
	@IBOutlet var timerTap: UITapGestureRecognizer!
	@IBAction func timerTapAction(_ sender: Any) {
		if let currentTimer = self.timerLabel.text {
			if currentTimer == "Easy" {
				self.timerLabel.text = "Medium"
				UserDefaults.standard.set(7, forKey: "roundTime")
			}
			else if currentTimer == "Medium" {
				self.timerLabel.text = "Hard"
				UserDefaults.standard.set(5, forKey: "roundTime")
			}
			else if currentTimer == "Hard" {
				self.timerLabel.text = "Easy"
				UserDefaults.standard.set(9, forKey: "roundTime")
			}
		}
	}
	
	@IBOutlet weak var timerDecreaseArrow: UIButton!
	@IBAction func timerDecrease(_ sender: Any) {
		if let currentTimer = self.timerLabel.text {
			if currentTimer == "Hard" {
				self.timerLabel.text = "Medium"
				UserDefaults.standard.set(7, forKey: "roundTime")
			}
			else if currentTimer == "Medium" {
				self.timerLabel.text = "Easy"
				UserDefaults.standard.set(9, forKey: "roundTime")
			}
			else if currentTimer == "Easy" {
				self.timerLabel.text = "Hard"
				UserDefaults.standard.set(5, forKey: "roundTime")
			}
		}
	}
	
	@IBOutlet weak var timerIncreaseArrow: UIButton!
	@IBAction func timerIncrease(_ sender: Any) {
		if let currentTimer = self.timerLabel.text {
			if currentTimer == "Hard" {
				self.timerLabel.text = "Easy"
				UserDefaults.standard.set(9, forKey: "roundTime")
			}
			else if currentTimer == "Medium" {
				self.timerLabel.text = "Hard"
				UserDefaults.standard.set(5, forKey: "roundTime")
			}
			else if currentTimer == "Easy" {
				self.timerLabel.text = "Medium"
				UserDefaults.standard.set(7, forKey: "roundTime")
			}
		}
	}
	
	@IBOutlet var packTap: UITapGestureRecognizer!
	@IBAction func packTapAction(_ sender: Any) {
		// MARK: Uncomment The Following Lines To Test Crashlytics (Step Two)
		// let crashlyticsAlert = Crashlytics.sharedInstance().testCrashlyticsAlert()
		// self.present(crashlyticsAlert, animated: true, completion: nil)
		
		// MARK: Uncomment The Following Line To Add 250 Coins To Account
		self.unlockable.addCoins(Amount: 250)
		
		// Update Displayed Coin Balance
		self.coinButton.setAttributedTitleForAllStates(title: self.unlockable.coinBalanceWithIcon())
		
		// self.coinButton.setTitleForAllStates(title: "\(self.unlockable.currentCoinBalance()) 🅒")
		// self.coinButton.attributedTitle(for: .normal)
		
		print("[INFO] Current Coin Balance: \(self.unlockable.currentCoinBalance())")
		
		// MARK: Uncomment Following Lines To Reset Currently Unlocked Packs
		UserDefaults.standard.set(["Standard"], forKey: "unlockedPacks")
		self.unlockable.validateUnlockedPacks()
		print("[INFO] Unlocked Word Packs: \(self.unlockable.currentlyUnlockedPacks())")
		
		// MARK: Uncomment Following Lines To Reset Currently Unlocked Themes
		UserDefaults.standard.set(["Purpink"], forKey: "unlockedThemes")
		self.unlockable.validateUnlockedThemes()
		print("[INFO] Unlocked Themes: \(self.unlockable.currentlyUnlockedThemes())")
	}
	
	@IBOutlet weak var packDecreaseArrow: UIButton!
	@IBAction func packDecrease(_ sender: Any) {
		let unlockedPacks = self.unlockable.currentlyUnlockedPacks()
		var nextPack = "nil"
		
		if self.selectedPackIndex <= 0 { self.selectedPackIndex = unlockedPacks.count - 1; nextPack = unlockedPacks[self.selectedPackIndex] }
		else { self.selectedPackIndex -= 1; nextPack = unlockedPacks[self.selectedPackIndex] }
		
		self.packLabel.text = nextPack
	}
	
	@IBOutlet weak var packIncreaseArrow: UIButton!
	@IBAction func packIncrease(_ sender: Any) {
		let unlockedPacks = self.unlockable.currentlyUnlockedPacks()
		
		self.selectedPackIndex += 1
		if self.selectedPackIndex > unlockedPacks.count - 1 { self.selectedPackIndex = 0 }
		self.packLabel.text = unlockedPacks[self.selectedPackIndex]
	}
	
	// MARK: Class Functions
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Validate unlockedThemes and unlockedPacks
		self.unlockable.validateUnlockedThemes()
		self.unlockable.validateUnlockedPacks()
		
		// Setup Theme Related UI Elements
		let currentTheme = self.unlockable.currentTheme()
		self.themeButton.setImageForAllStates(image: self.unlockable.tabImageFor(Theme: currentTheme))
		self.logoImage.image = self.unlockable.logoImageFor(Theme: currentTheme)
		
		// Display High Score
		self.scoreLabel.text = String(describing: UserDefaults.standard.integer(forKey: "highScore"))
		
		// Recover Previous Timer Setting
		let roundTime = UserDefaults.standard.integer(forKey: "roundTime")
		if roundTime == 0 { self.timerLabel.text = "Medium"; UserDefaults.standard.set(7, forKey: "roundTime") }
		else if roundTime == 5 { self.timerLabel.text = "Hard" }
		else if roundTime == 7 { self.timerLabel.text = "Medium" }
		else if roundTime == 9 { self.timerLabel.text = "Easy" }
	}
	
	override func viewWillAppear(_ animated: Bool) {
		// Display Coins
		self.coinButton.setAttributedTitleForAllStates(title: self.unlockable.coinBalanceWithIcon())
	}

	private func resetHighScore() {
		self.scoreLabel.text = "0"
		UserDefaults.standard.set(0, forKey: "highScore")
		print("[WARNING] High Score Reset")
	}
	
	// MARK: Prepare For Segue
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "BeginSegue" {
			if let vc = segue.destination as? MainVC, let packName = self.packLabel.text {
				vc.wordsToRhyme = self.unlockable.getShuffledWordPack(Named: packName)
			}
		}
	}
}

// MARK: Setup Rewarded Ad

extension MenuVC: GADRewardedAdDelegate {
	private func createAndLoadRewardedAd() -> GADRewardedAd {
		let rewardedAd = GADRewardedAd(adUnitID: "ca-app-pub-3940256099942544/1712485313")
		rewardedAd.load(GADRequest()) { error in
			if let error = error {
				print("[ERROR] Rewarded Ad Failed To Load. [MESSAGE] \(error.localizedDescription)")
			}
			else {
				print("[INFO] Rewarded Ad Loaded Successfully.")
				self.presentRewardedAd()
			}
		}
	  return rewardedAd
	}
	
	private func presentRewardedAd() {
		if rewardedAd!.isReady { rewardedAd?.present(fromRootViewController: self, delegate: self) }
		else { print("[WARNING] Rewarded Ad Not Ready To Present.") }
	}
	
	func rewardedAdDidDismiss(_ rewardedAd: GADRewardedAd) {
		self.adCompletedAlert()
	}
	
	func rewardedAd(_ rewardedAd: GADRewardedAd, didFailToPresentWithError error: Error) {
		print("[ERROR] Could Not Load Rewarded Ad. [MESSAGE] \(error.localizedDescription)")
	}

	func rewardedAd(_ rewardedAd: GADRewardedAd, userDidEarn reward: GADAdReward) {
		unlockable.addCoins(Amount: 10)
	}
	
	private func adRequestAlert() {
		let alert = UIAlertController(title: "Earn Free Bubbles!!", message: "Watch A Short Video To Earn 10 Free Bubbles", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Watch Video", style: .default) { (action) in
			alert.dismiss(animated: true, completion: nil)
			self.rewardedAd = self.createAndLoadRewardedAd()
		});
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
			alert.dismiss(animated: true, completion: nil)
		}));
		
		self.present(alert, animated: true, completion: nil)
	}
	
	private func adCompletedAlert() {
		let alert = UIAlertController(title: "Thanks For Watching!!", message: "10 bubbles have been awarded to your account (unless the ad was closed early)", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Watch Another", style: .default) { (action) in
			alert.dismiss(animated: true, completion: nil)
			self.rewardedAd = self.createAndLoadRewardedAd()
		});
		alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: { (action) in
			alert.dismiss(animated: true, completion: nil)
		}));
		
		self.present(alert, animated: true, completion: nil)
	}
}
