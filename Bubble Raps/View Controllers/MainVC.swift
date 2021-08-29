//
//  MainVC.swift
//  RhymingBubbles
//
//  Created by Delta Vel on 6/24/19.
//  Copyright © 2019 Delta Vel. All rights reserved.
//

import UIKit
import AmazingBubbles
import GoogleMobileAds

let numRhymes = 5

class MainVC: UIViewController {
	
	// MARK: Storyboard Outlets
	
	@IBOutlet weak var bubblesView: ContentBubblesView! { didSet { bubblesView.delegate = self; bubblesView.dataSource = self } }
	
	@IBOutlet weak var titleView: UIView!
	@IBOutlet weak var titleLabel: UILabel!
	
	@IBOutlet weak var timerLabel: UILabel!
	@IBOutlet weak var livesLabel: UILabel!
	
	@IBOutlet weak var pauseButton: UIButton!
	@IBAction func pauseAction(_ sender: Any) { self.presentPauseMenu() }
	
	// MARK: Class Variables
	
	var interstitial: GADInterstitialAd?
	
	let rhymeHelper = RhymeHelper()
	let unlockable = UnlockableHelper()
	
	var isHighscore = false
	var score = 0
	var round = 0
	var correctAnswers = 0
	var incorrectAnswers = 0
	
	var timer = Timer()
	var roundTime = 0
	var timeLeft = 0
	
	var rhyme:RhymeHelper!
	var potentialRhymesDictionary:[String:Bool]!
	var potentialRhymesArray:[String]!
	
	var wordsToRhyme = [String]()
	
	// MARK: Starting New 'WordPack Struct' Integration
	
	var wordPack: WordPack?
	
	// MARK: viewDidLoad
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.titleLabel.text = "Please Wait..."
		
		// MARK: Make Bubbles Bounce Off Edges
		let bubbleBounds = UIBezierPath(rect: UIScreen.main.bounds)
		self.bubblesView.collisionBehavior.addBoundary(withIdentifier: "ScreenBounds" as NSCopying, for: bubbleBounds)
		
		// MARK: Setup Timer
		self.roundTime = UserDefaults.standard.integer(forKey: "roundTime")
		self.timeLeft = roundTime
		
		// MARK: Handle Themes
		self.themeHandler()
		
		// MARK: Setup Ads
		self.loadInterstitial()
		
		let loadingAlert = self.loadingAlert()
		self.present(loadingAlert, animated: true, completion: nil)
		
		// MARK: Start First Round
		self.startNextRound(isFirstRound: true) {
			loadingAlert.dismiss(animated: true, completion: nil)
		}
    }
	
	// MARK: Start Round Function
	
	private func startNextRound(isFirstRound: Bool, completion: (() -> ())?) {
		self.round += 1
		self.correctAnswers = 0
		
		self.rhymeHelper.createWordPack { (newPack) in
			self.bubblesView.removeBubbles()
			self.wordPack = newPack
			self.titleLabel.text = newPack.topic
			self.bubblesView.reload()
			self.startTimer(fromPause: false)
			completion?()
		}
	}
	
	// MARK: Start Timer
	
	private func startTimer(fromPause: Bool) {
		if fromPause == false { self.timeLeft = self.roundTime }
		
		let currentTheme = self.unlockable.currentTheme()
		let mainColor = self.unlockable.colorFor(Theme: currentTheme)
		let borderColor = self.unlockable.borderColorFor(Theme: currentTheme)
		
		self.timerLabel.text = String(describing: self.timeLeft)
		self.timerLabel.backgroundColor = mainColor
		self.timerLabel.borderColor = borderColor
		self.timerLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
		
		self.timer = Timer.init(timeInterval: 1.0, repeats: true, block: { (timr) in
			self.timeLeft -= 1
			self.timerLabel.text = String(describing: self.timeLeft)
			if self.timeLeft <= 0 {
				self.roundCompleted(isGameOver: true)
			}
//			else if self.timeLeft <= 5 {
//				self.timerLabel.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//				self.timerLabel.borderColor = #colorLiteral(red: 1, green: 0, blue: 0.06575310382, alpha: 1)
//				self.timerLabel.textColor = #colorLiteral(red: 1, green: 0, blue: 0.06575310382, alpha: 1)
//			}
			else {
				self.timerLabel.backgroundColor = mainColor
				self.timerLabel.borderColor = borderColor
				self.timerLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
			}
		})
		
		RunLoop.current.add(timer, forMode: .common)
	}
	
	// MARK: Handle Live Counter
	
	private func handleLiveCounter() {
		let mainColor = self.unlockable.colorForCurrentTheme()
		
		if self.incorrectAnswers == 0 {
			let str = NSMutableAttributedString(string: "● ● ●")
				str.addAttribute(.foregroundColor, value: mainColor, range: NSRange(location: 0, length: 1))
				str.addAttribute(.foregroundColor, value: mainColor, range: NSRange(location: 2, length: 1))
				str.addAttribute(.foregroundColor, value: mainColor, range: NSRange(location: 4, length: 1))
			self.livesLabel.attributedText = str
		}
		else if self.incorrectAnswers == 1 {
			let str = NSMutableAttributedString(string: "● ● ○")
				str.addAttribute(.foregroundColor, value: mainColor, range: NSRange(location: 0, length: 1))
				str.addAttribute(.foregroundColor, value: mainColor, range: NSRange(location: 2, length: 1))
				str.addAttribute(.foregroundColor, value: #colorLiteral(red: 1, green: 0, blue: 0.06575310382, alpha: 1), range: NSRange(location: 4, length: 1))
			self.livesLabel.attributedText = str
		}
		else if self.incorrectAnswers == 2 {
			let str = NSMutableAttributedString(string: "● ○ ○")
				str.addAttribute(.foregroundColor, value: mainColor, range: NSRange(location: 0, length: 1))
				str.addAttribute(.foregroundColor, value: #colorLiteral(red: 1, green: 0, blue: 0.06575310382, alpha: 1), range: NSRange(location: 2, length: 1))
				str.addAttribute(.foregroundColor, value: #colorLiteral(red: 1, green: 0, blue: 0.06575310382, alpha: 1), range: NSRange(location: 4, length: 1))
			self.livesLabel.attributedText = str
		}
		else if self.incorrectAnswers == 3 {
			let str = NSMutableAttributedString(string: "○ ○ ○")
				str.addAttribute(.foregroundColor, value: #colorLiteral(red: 1, green: 0, blue: 0.06575310382, alpha: 1), range: NSRange(location: 0, length: 1))
				str.addAttribute(.foregroundColor, value: #colorLiteral(red: 1, green: 0, blue: 0.06575310382, alpha: 1), range: NSRange(location: 2, length: 1))
				str.addAttribute(.foregroundColor, value: #colorLiteral(red: 1, green: 0, blue: 0.06575310382, alpha: 1), range: NSRange(location: 4, length: 1))
			self.livesLabel.attributedText = str
		}
	}
	
	// MARK: Theme Handler
	
	private func themeHandler() {
		let currentTheme = self.unlockable.currentTheme()
		let mainColor = self.unlockable.colorFor(Theme: currentTheme)
		let borderColor = self.unlockable.borderColorFor(Theme: currentTheme)
				
		let str = NSMutableAttributedString(string: "● ● ●")
		str.addAttribute(.foregroundColor, value: mainColor, range: NSRange(location: 0, length: 1))
			str.addAttribute(.foregroundColor, value: mainColor, range: NSRange(location: 2, length: 1))
			str.addAttribute(.foregroundColor, value: mainColor, range: NSRange(location: 4, length: 1))
		
		self.livesLabel.attributedText = str
		
		self.pauseButton.backgroundColor = mainColor
		self.pauseButton.borderColor = borderColor
		
		self.timerLabel.backgroundColor = mainColor
		self.timerLabel.borderColor = borderColor
		
		self.titleView.backgroundColor = mainColor
		self.titleView.borderColor = borderColor
	}
	
	private func cleanup() {
		self.timer.invalidate()
		self.bubblesView.removeBubbles()
	}
}

// MARK: ContentBubblesViewDelegate Protocol Stubs

extension MainVC: ContentBubblesViewDelegate {
    func minimalSizeForBubble(in view: ContentBubblesView) -> CGSize { return CGSize(width: 80, height: 80) }
    func maximumSizeForBubble(in view: ContentBubblesView) -> CGSize { return CGSize(width: 130, height: 130) }
    func contentBubblesView(_ view: ContentBubblesView, didSelectItemAt index: Int) {
		guard let wordPack = self.wordPack else { print("[ERROR] Unable To Validate Current WordPack."); return }
		let wordSelected = wordPack.allWords[index]
		guard let isCorrect = wordPack.rhymeDictionary[wordSelected] else { print("[ERROR] Unable To Find Selected Word: \(wordSelected) In Rhyme Dictionary."); return }
		if isCorrect { self.correctAnswer(view: view, index: index) } else { self.incorrectAnswer(view: view, index: index) }
    }
	
	private func correctAnswer(view: ContentBubblesView, index: Int) {
		self.score += 1
		self.correctAnswers += 1
		self.bubblesView.changeBubble(isCorrect: true, index: index)
		if self.correctAnswers == 5 { self.roundCompleted(isGameOver: false) }
	}
	
	private func incorrectAnswer(view: ContentBubblesView, index: Int) {
		self.incorrectAnswers += 1
		self.bubblesView.changeBubble(isCorrect: false, index: index)
		self.handleLiveCounter()
		
		if self.incorrectAnswers == 3 { self.roundCompleted(isGameOver: true) }
	}
}

// MARK: ContentBubblesViewDataSource Protocol Stubs

extension MainVC: ContentBubblesViewDataSource {
	func numberOfItems(in view: ContentBubblesView) -> Int {
		guard let wordPack = self.wordPack else { print("[ERROR] Unable To Validate Current WordPack."); return 0 }
		return wordPack.allWords.count
	}
	
    func countOfSizes(in view: ContentBubblesView) -> Int { return 3 }
    func addOrUpdateBubbleView(forItemAt index: Int, currentView: BubbleView?) -> BubbleView {
		var view: BubbleView! = currentView
		guard let wordPack = self.wordPack else { print("[ERROR] Unable to Validate Current WordPack."); return view }
		if let labelView = UINib(nibName: "LabelBubbleView", bundle: nil).instantiate(withOwner: nil, options: nil).first as? LabelBubbleView {
			labelView.label.text = wordPack.allWords[index]
			labelView.imageView.image = self.unlockable.bubbleImageFor(Theme: self.unlockable.currentTheme())
			labelView.imageView.isHidden = false
			view = labelView
		}
		
		// Spawn Bubbles From Random Location
		let randomOrigin = CGPoint(x: CGFloat(drand48() * Double(self.view.frame.width * 2 / 3)), y: CGFloat(drand48() * Double(self.view.frame.height * 2 / 3)))
		view.frame = CGRect(origin: randomOrigin, size: .zero)
		
		// Adjust Size of Bubble if Character Count is Greater Than 8
		if wordPack.allWords[index].count > 8 { view.frame.size = CGSize(width: 110, height: 110) }
		
		return view
    }
}

// MARK: RoundCompletedAlertDelegate Protocol Stubs

extension MainVC: RoundCompletedAlertDelegate {
	private func roundCompleted(isGameOver: Bool) {
		self.timer.invalidate()
		if isGameOver {
			// Add Coins
			self.unlockable.addBubbles(Amount: self.score)
			
			// Update High Score
			self.updateHighScore()
			
			// MARK: Present Interstatial After Game Over
			self.presentInterstitial()
		}
		
		// Present Round Completed Popup To Proceed To Next Round
		self.presentRoundCompletedPopup(isGameOver: isGameOver)
	}
	
	private func presentRoundCompletedPopup(isGameOver: Bool) {
		let roundCompletedPopup = self.storyboard?.instantiateViewController(withIdentifier: "RoundCompletedAlert") as! RoundCompletedAlert
			roundCompletedPopup.providesPresentationContextTransitionStyle = true
			roundCompletedPopup.definesPresentationContext = true
			roundCompletedPopup.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
			roundCompletedPopup.modalTransitionStyle = UIModalTransitionStyle.crossDissolve

			roundCompletedPopup.delegate = self
			roundCompletedPopup.isGameOver = isGameOver
			roundCompletedPopup.isHighScore = self.isHighscore
			roundCompletedPopup.currentScore = self.score
		
		self.present(roundCompletedPopup, animated: true, completion: nil)
	}
	
	// Update High Score
	private func updateHighScore() {
		let currentHighScore = UserDefaults.standard.integer(forKey: "highScore")
		if self.score > currentHighScore {
			self.isHighscore = true;
			UserDefaults.standard.set(self.score, forKey: "highScore")
		}
	}
	
	// Proceed To Next Screen
	func nextRoundClicked() {
		let loadingAlert = self.loadingAlert()
		self.present(loadingAlert, animated: true, completion: nil)
		
		self.startNextRound(isFirstRound: false) {
			loadingAlert.dismiss(animated: true, completion: nil)
		}
	}
	
	func gameOverClicked() { self.performSegue(withIdentifier: "BackToMenu", sender: self) }
}

// MARK: PauseMenuDelegate Protocol Stubs

extension MainVC: PauseMenuDelegate {
	private func presentPauseMenu() {
		self.timer.invalidate()
		if let menu = self.storyboard?.instantiateViewController(withIdentifier: "PauseMenu") as? PauseMenu {
			menu.providesPresentationContextTransitionStyle = true
			menu.definesPresentationContext = true
			menu.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
			menu.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
			
			menu.delegate = self
			menu.currentScore = self.score
			
			self.present(menu, animated: true, completion: nil)
		}
	}
	
	func resumeFromPause() { self.startTimer(fromPause: true) }
	func endFromPause() { self.unlockable.addBubbles(Amount: self.score); self.performSegue(withIdentifier: "BackToMenu", sender: self) }
}

// MARK: GADInterstitialDelegate Protocol Stubs

extension MainVC: GADFullScreenContentDelegate {
	
	private func loadInterstitial() {
		let adID = "ca-app-pub-8123415297019784/4985798738"
		let adReq = GADRequest()
		
		GADInterstitialAd.load(withAdUnitID: adID, request: adReq, completionHandler: { (ad, error) in
			if let error = error {
				print("[ERROR] Failed To Load Interstitial Ad. [MESSAGE] \(error.localizedDescription).")
				return
			}
			
			self.interstitial = ad
			self.interstitial?.fullScreenContentDelegate = self
		})
	}
							   
	private func presentInterstitial() {
		if let ad = self.interstitial {
			print("[INFO] Presenting Interstitial Ad.")
			ad.present(fromRootViewController: self)
			
		} else {
			print("[WARNING] Interstitial Ad Not Ready.")
			self.presentRoundCompletedPopup(isGameOver: true)
		}
	}
							   
	func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
		print("[ERROR] Failed To Present Ad. [MESSAGE] \(error.localizedDescription).")
	}
							   
	func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
		print("[INFO] Did Dismiss Ad.")
		self.loadInterstitial()
		self.presentRoundCompletedPopup(isGameOver: true)
	}
}
