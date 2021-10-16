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

	// -- Theme Colors
	let primary = Theme.primary()
	let secondary = Theme.secondary()
	
	// -- Views
	var interstitial: GADInterstitialAd?
	var loadingView: LoadingView?
	
	// -- Helpers
	let rhymeHelper = RhymeHelper()
	
	// -- Rhymes
	var wordPack: WordPack?
	var topicWords = Packs.standard.shuffled()
	
	// -- Game Variables
	var isHighscore = false
	var score = 0
	var round = 0
	var correctAnswers = 0
	var incorrectAnswers = 0
	
	var timer = Timer()
	var roundTime = 0
	var timeLeft = 0

	// MARK: Starting New 'WordPack Struct' Integration
	
	// We Wait For Both Of These To Become True Before Starting Game (Timer)
	var isReady = false {
		didSet { if (isReady && shouldStart) { self.startTimer(fromPause: false); self.isReady = false; self.shouldStart = false; } }
	}
	
	var shouldStart = false {
		didSet { if (shouldStart && isReady) { self.startTimer(fromPause: false); self.isReady = false; self.shouldStart = false; } }
	}
	
	// MARK: viewDidLoad
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.titleLabel.text = "Please Wait..."
		
		// MARK: Setup LoadingView
		let loadingView = LoadingView(frame: self.view.frame)
		self.loadingView = loadingView
		
		// MARK: Make Bubbles Bounce Off Edges
		let bubbleBounds = UIBezierPath(rect: UIScreen.main.bounds)
		self.bubblesView.collisionBehavior.addBoundary(withIdentifier: "ScreenBounds" as NSCopying, for: bubbleBounds)
		
		// MARK: Setup Timer
		self.roundTime = UserDefaults.standard.integer(forKey: "roundTime")
		self.timeLeft = roundTime
		
		// MARK: Handle Theme
		self.themeHandler()
		
		// MARK: Setup Ads
		self.loadInterstitial()
		
		// MARK: Start First Round
		self.loadNextRound()
		self.shouldStart = true
    }
	
	// MARK: Start Round Function
	
	private func loadNextRound(isFirstRound: Bool = false) {
		self.round += 1
		self.correctAnswers = 0
		
		let newTopic = self.topicWords.popLast()
		self.rhymeHelper.createWordPack(topicWord: newTopic) { (newPack) in
			self.wordPack = newPack
			self.titleLabel.text = self.wordPack?.topic
			
			self.bubblesView.removeBubbles()
			self.bubblesView.reload()
			self.isReady = true
		}
	}
	
	// MARK: Start Timer
	
	private func startTimer(fromPause: Bool) {
		if fromPause == false { self.timeLeft = self.roundTime }
		
		self.timerLabel.text = String(describing: self.timeLeft)
		self.timerLabel.backgroundColor = self.primary
		self.timerLabel.borderColor = self.secondary
		self.timerLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
		
		self.timer = Timer.init(timeInterval: 1.0, repeats: true, block: { (timr) in
			self.timeLeft -= 1
			self.timerLabel.text = String(describing: self.timeLeft)
			
			if self.timeLeft <= 0 { self.roundCompleted(isGameOver: true) }
//			else if self.timeLeft <= 5 {
//				self.timerLabel.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//				self.timerLabel.borderColor = #colorLiteral(red: 1, green: 0, blue: 0.06575310382, alpha: 1)
//				self.timerLabel.textColor = #colorLiteral(red: 1, green: 0, blue: 0.06575310382, alpha: 1)
//			}
			else {
				self.timerLabel.backgroundColor = self.primary
				self.timerLabel.borderColor = self.secondary
				self.timerLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
			}
		})
		
		RunLoop.current.add(timer, forMode: .common)
	}
	
	// MARK: Handle Live Counter
	
	private func handleLiveCounter() {
		if self.incorrectAnswers == 0 {
			let str = NSMutableAttributedString(string: "● ● ●")
				str.addAttribute(.foregroundColor, value: self.primary, range: NSRange(location: 0, length: 1))
				str.addAttribute(.foregroundColor, value: self.primary, range: NSRange(location: 2, length: 1))
				str.addAttribute(.foregroundColor, value: self.primary, range: NSRange(location: 4, length: 1))
			self.livesLabel.attributedText = str
		}
		else if self.incorrectAnswers == 1 {
			let str = NSMutableAttributedString(string: "● ● ○")
				str.addAttribute(.foregroundColor, value: self.primary, range: NSRange(location: 0, length: 1))
				str.addAttribute(.foregroundColor, value: self.primary, range: NSRange(location: 2, length: 1))
				str.addAttribute(.foregroundColor, value: #colorLiteral(red: 1, green: 0, blue: 0.06575310382, alpha: 1), range: NSRange(location: 4, length: 1))
			self.livesLabel.attributedText = str
		}
		else if self.incorrectAnswers == 2 {
			let str = NSMutableAttributedString(string: "● ○ ○")
				str.addAttribute(.foregroundColor, value: self.primary, range: NSRange(location: 0, length: 1))
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
		let str = NSMutableAttributedString(string: "● ● ●")
		str.addAttribute(.foregroundColor, value: self.primary, range: NSRange(location: 0, length: 1))
			str.addAttribute(.foregroundColor, value: self.primary, range: NSRange(location: 2, length: 1))
			str.addAttribute(.foregroundColor, value: self.primary, range: NSRange(location: 4, length: 1))
		
		self.livesLabel.attributedText = str
		
		self.pauseButton.backgroundColor = self.primary
		self.pauseButton.borderColor = self.secondary
		
		self.timerLabel.backgroundColor = self.primary
		self.timerLabel.borderColor = self.secondary
		
		self.titleView.backgroundColor = self.primary
		self.titleView.borderColor = self.secondary
	}
	
	private func cleanup() {
		self.timer.invalidate()
		self.bubblesView.removeBubbles()
	}
}

// MARK: ContentBubblesViewDelegate Protocol Stubs

extension MainVC: ContentBubblesViewDelegate {
    func minimalSizeForBubble(in view: ContentBubblesView) -> CGSize { return CGSize(width: 80, height: 80) }
    func maximumSizeForBubble(in view: ContentBubblesView) -> CGSize { return CGSize(width: 160, height: 160) }
    func contentBubblesView(_ view: ContentBubblesView, didSelectItemAt index: Int) {
		guard let wordPack = self.wordPack else { print("[ERROR] Unable To Validate Current WordPack."); return }
		let wordSelected = wordPack.allWords[index]
		
		guard let isCorrect = wordPack.rhymeDictionary[wordSelected] else { print("[ERROR] Unable To Find Selected Word: \(wordSelected) In Rhyme Dictionary."); return }
		
		if isCorrect { self.correctAnswer(view: view, index: index) } else { self.incorrectAnswer(view: view, index: index) }
    }
	
	private func correctAnswer(view: ContentBubblesView, index: Int) {
		self.score += 1
		self.correctAnswers += 1
		
		// Disable Already Selected Bubble
		view.bubbleViews[index].isUserInteractionEnabled = false
		
		self.bubblesView.changeBubble(isCorrect: true, index: index)
		if self.correctAnswers == 5 { self.roundCompleted(isGameOver: false) }
	}
	
	private func incorrectAnswer(view: ContentBubblesView, index: Int) {
		self.incorrectAnswers += 1
		
		// Disable Already Selected Bubble
		view.bubbleViews[index].isUserInteractionEnabled = false
		
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
		let rhymeWord = wordPack.allWords[index]
		
		let font = UIFont.systemFont(ofSize: 17.0)
		if let labelView = UINib(nibName: "LabelBubbleView", bundle: nil).instantiate(withOwner: nil, options: nil).first as? LabelBubbleView  {
			labelView.label.font = font
			labelView.label.text = rhymeWord
			labelView.imageView.image = Theme.bubbleImage()
			labelView.imageView.isHidden = false
			view = labelView
		}
		
		// Spawn Bubbles From Random Location
		let randomOrigin = CGPoint(x: CGFloat(drand48() * Double(self.view.frame.width * 2 / 3)), y: CGFloat(drand48() * Double(self.view.frame.height * 2 / 3)))
		view.frame = CGRect(origin: randomOrigin, size: .zero)
		
		// Adjust Size of Bubble if Character Count is Greater Than 8
		var textWidth = UILabel.textWidth(font: font, text: rhymeWord) + 20 /* extra space for bubble border */
		if textWidth < 80 { textWidth = 80 }
		view.frame.size = CGSize(width: textWidth, height: textWidth)
		
		return view
	}
}

// MARK: RoundCompletedAlertDelegate Protocol Stubs

extension MainVC: RoundCompletedAlertDelegate {
	func nextRoundClicked() {
		self.shouldStart = true
	}
	
	private func roundCompleted(isGameOver: Bool) {
		self.timer.invalidate()
		
		if (isGameOver) {
			// Add Coins
			Currency.addBubbles(Amount: self.score)
			
			// Update High Score
			self.updateHighScore()
			
			// MARK: Present Interstatial After Game Over
			self.presentInterstitial()
		}
		else {
			self.loadNextRound()
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
	func endFromPause() { Currency.addBubbles(Amount: self.score); self.performSegue(withIdentifier: "BackToMenu", sender: self) }
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

extension MainVC {
	private func showLoadingView() {
		if let loadingView = self.loadingView { self.view.addSubview(loadingView); self.view.bringSubviewToFront(loadingView) }
		else { print("[ERROR] Failed To Validate LoadingView.") }
	}
	
	private func hideLoadingView() { self.loadingView?.removeFromSuperview() }
}
