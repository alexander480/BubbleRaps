
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

// TODO: Save Last Chosen Word Pack

var theme = Themes()
var packs = Packs()

class MenuVC: UIViewController {
	
	// MARK: Class Variables

	var selectedPack = "Standard" {
		didSet { packs.current = self }
	}
	var packIndex = 0 // Used For Cycling Through Word Packs On Menu //

	var rewardedAd: GADRewardedAd?
	
	var loadingAlert: UIAlertController!
	
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
		if let themesVC = self.storyboard?.instantiateViewController(withIdentifier: "ThemesVC") as? ThemesVC {
			self.present(themesVC, animated: true, completion: nil)
		}
	}
	
	@IBOutlet weak var adButton: UIButton!
	@IBAction func adButtonAction(_ sender: Any) {
		self.adRequestAlert()
	}
	
	@IBOutlet weak var bubbleButton: UIButton!
	@IBAction func bubbleButtonAction(_ sender: Any) {
		if let BubbleVC = self.storyboard?.instantiateViewController(withIdentifier: "BubbleVC") as? BubbleVC {
			self.present(BubbleVC, animated: true, completion: nil)
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
		
		// MARK: Uncomment The Following Line To Add 250 Bubbles To Account
		UnlockableHelper.addBubbles(Amount: 250)
		
		// Update Displayed Bubbles Balance
		self.bubbleButton.setAttributedTitleForAllStates(title: UnlockableHelper.bubbleBalanceWithIcon())
		
		print("[DEV] Manually Added Bubble Currency.")
		print("[INFO] Current Bubble Balance: \(UnlockableHelper.currentBubbleBalance())")
		
		// MARK: Uncomment Following Lines To Reset Currently Unlocked Packs
		// UserDefaults.standard.set(["Standard"], forKey: "unlockedPacks")
		// print("[INFO] Unlocked Word Packs: \(UnlockableHelper.currentlyUnlockedPacks())")
		
		// MARK: Uncomment Following Lines To Reset Currently Unlocked Themes
		// UserDefaults.standard.set(["Purpink"], forKey: "unlockedThemes")
		// print("[INFO] Unlocked Themes: \(UnlockableHelper.unlockedThemes())")
	}
	
	@IBOutlet weak var packDecreaseArrow: UIButton!
	@IBAction func packDecrease(_ sender: Any) {
		self.packIndex -= 1
		if (self.packIndex == 0) {
			self.selectedPack = packs.unlocked[self.packIndex]
			self.packLabel.text = self.selectedPack
			self.packIndex = packs.unlocked.count - 1
		}
		else {
			self.selectedPack = packs.unlocked[self.packIndex]
			self.packLabel.text = self.selectedPack
		}
	}
	
	@IBOutlet weak var packIncreaseArrow: UIButton!
	@IBAction func packIncrease(_ sender: Any) {
		self.packIndex += 1
		if (self.packIndex == (packs.unlocked.count - 1)) {
			self.selectedPack = packs.unlocked[self.packIndex]
			self.packLabel.text = self.selectedPack
			self.packIndex = 0
		}
		else {
			self.selectedPack = packs.unlocked[self.packIndex]
			self.packLabel.text = self.selectedPack
		}
	}
	
	// MARK: Class Functions
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.loadingAlert = self.loadingAlert()
		
		// Setup Theme Related UI Elements
		self.themeButton.setImageForAllStates(image: theme.assets.tabImage)
		self.logoImage.image = theme.assets.logoImage)
		
		// Display High Score
		self.scoreLabel.text = String(describing: UserDefaults.standard.integer(forKey: "highScore"))
		
		// Recover Previous Timer Setting
		let roundTime = UserDefaults.standard.integer(forKey: "roundTime")
		if roundTime == 0 { self.timerLabel.text = "Medium"; UserDefaults.standard.set(7, forKey: "roundTime") }
		else if roundTime == 5 { self.timerLabel.text = "Hard" }
		else if roundTime == 7 { self.timerLabel.text = "Medium" }
		else if roundTime == 9 { self.timerLabel.text = "Easy" }
		
		self.loadRewardedAd()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		self.bubbleButton.setAttributedTitleForAllStates(title: UnlockableHelper.bubbleBalanceWithIcon())
	}

	private func resetHighScore() {
		self.scoreLabel.text = "0"
		UserDefaults.standard.set(0, forKey: "highScore")
		print("[WARNING] High Score Reset")
	}
	
	// MARK: Prepare For Segue
	/*
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "BeginSegue" {
			if let vc = segue.destination as? MainVC /*, let packName = self.packLabel.text*/ {
				// vc.wordsToRhyme = UnlockableHelper.getShuffledWordPack(Named: packName)
				
				// MARK: Starting New Integration
				rhymeHelper.createWordPack { (wordPack) in
					vc.wordPack = wordPack
				}
			}
		}
	}
	*/
}

// MARK: Setup Rewarded Ad

extension MenuVC: GADFullScreenContentDelegate {
	
	private func loadRewardedAd(completion: (() -> ())? = nil) {
		// self.present(self.loadingAlert, animated: true, completion: nil)
		
		let adID = "ca-app-pub-6543648439575950/6863943940"
		let adRequest = GADRequest()
		
		GADRewardedAd.load(withAdUnitID: adID, request: adRequest) { ad, error in
			if let error = error {
				print("[ERROR] Failed To Load Rewarded Ad. [MESSAGE] \(error.localizedDescription).")
				return
			}
			
			self.rewardedAd = ad
			self.rewardedAd?.fullScreenContentDelegate = self
			
			completion?()
		}
	}
	
	private func presentRewardedAd() {
		// self.loadingAlert.dismiss(animated: true, completion: nil)
		
		if let ad = self.rewardedAd {
			ad.present(fromRootViewController: self, userDidEarnRewardHandler: {
				print("[INFO] User Earned Reward.");
				UnlockableHelper.addBubbles(Amount: 10)
				self.adCompletedAlert()
			})
		} else {
			print("[WARNING] Rewarded Ad Not Ready To Present.")
			self.presentAlert(title: "Oops!", message: "Rewarded Ad Not Ready To Present.", actions: nil)
		}
	}
	
	func rewardedAd(_ rewardedAd: GADRewardedAd, didFailToPresentWithError error: Error) {
		print("[ERROR] Could Not Load Rewarded Ad. [MESSAGE] \(error.localizedDescription)")
	}
	
	private func adRequestAlert() {
		let alert = UIAlertController(title: "Earn Free Bubbles!!", message: "Watch A Short Video To Earn 10 Free Bubbles", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Watch Video", style: .default) { (action) in
			alert.dismiss(animated: true, completion: nil)
			self.loadRewardedAd {
				self.presentRewardedAd()
			}
		});
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
			alert.dismiss(animated: true, completion: nil)
		}));
		
		self.present(alert, animated: true, completion: nil)
	}
	
	private func adCompletedAlert() {
		let alert = UIAlertController(title: "Thanks For Watching!!", message: "10 bubbles have been awarded to your account (unless the ad was closed early)", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Watch Another", style: .default) { (action) in
			alert.dismiss(animated: true) {
				self.loadRewardedAd {
					self.presentRewardedAd()
				}
			}
		});
		alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: { (action) in
			alert.dismiss(animated: true) {
				self.loadRewardedAd()
			}
		}));
		
		self.present(alert, animated: true, completion: nil)
	}
}
