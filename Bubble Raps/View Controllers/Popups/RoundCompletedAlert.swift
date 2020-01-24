//
//  RoundCompletedAlert.swift
//  RhymingBubbles
//
//  Created by Alexander Lester on 8/28/19.
//  Copyright © 2019 Delta Vel. All rights reserved.
//

import Foundation
import UIKit

protocol RoundCompletedAlertDelegate: class {
	func nextRoundClicked()
	func gameOverClicked()
}

class RoundCompletedAlert: UIViewController {

	// MARK: IBOutlets
	
	@IBOutlet weak var backgroundImageView: UIImageView!
	@IBOutlet weak var coinLabel: UILabel!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var subtitleLabel: UILabel!
	@IBOutlet weak var nextButton: UIButton!
	@IBAction func nextButtonAction(_ sender: Any) {
		if isGameOver { self.dismiss(animated: true) { self.delegate?.gameOverClicked() } }
		else { self.dismiss(animated: true) { self.delegate?.nextRoundClicked() } }
	}
	
	// MARK: Class Variables
	
	let unlockable = UnlockableHelper()
	var delegate: RoundCompletedAlertDelegate?
	
	var isHighScore = false
	var isGameOver = false
	var currentScore = 0
	
	// MARK: Override Functions
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.setupUserInterface()
	}
	
	// MARK: User Interface Functions
	
	private func setupUserInterface() {
		let coinsEarned = self.coinsEarned()
		
		if self.isGameOver {
			self.backgroundImageView.image = #imageLiteral(resourceName: "Game Over Popup Background")
			self.nextButton.setBackgroundImageForAllStates(image: #imageLiteral(resourceName: "Game Over Button"))
			
			if self.isHighScore { self.titleLabel.text = "New High Score!!"; self.subtitleLabel.text = "\(self.currentScore) Correct Answers" }
			else { self.titleLabel.text = "Game Over"; self.subtitleLabel.text = "\(self.currentScore) Correct Answers" }
			
			self.coinLabel.attributedText = self.coinsEarnedString(Number: coinsEarned)
			self.unlockable.addBubbles(Amount: coinsEarned)
		}
		else {
			self.backgroundImageView.image = #imageLiteral(resourceName: "Next Round Popup Background")
			self.nextButton.setBackgroundImageForAllStates(image: #imageLiteral(resourceName: "Next Round Button"))
			
			self.titleLabel.text = "Round Completed!"
			self.subtitleLabel.text = "\(self.currentScore) Correct Answers"
			
			self.coinLabel.attributedText = self.coinsEarnedString(Number: coinsEarned)
		}
		
		let blurEffect = UIBlurEffect(style: .dark)
		let blurEffectView = UIVisualEffectView(effect: blurEffect)
			blurEffectView.frame = self.view.frame
		
		self.view.insertSubview(blurEffectView, at: 0)
	}
	
	private func coinsEarnedString(Number: Int) -> NSMutableAttributedString {
		let str = NSMutableAttributedString(string: "+\(Number) ")
		let style = NSMutableParagraphStyle()
			style.alignment = NSTextAlignment.center
		
		if let font = UIFont(name: "AvenirNext-Heavy", size: 22.0) {
			str.addAttribute(.font, value: font, range: NSRange(location: 0, length: str.length))
			str.addAttribute(.foregroundColor, value: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), range: NSRange(location: 0, length: str.length))
			str.addAttribute(.paragraphStyle, value: style, range: NSRange(location: 0, length: str.length))
			str.add(Image: #imageLiteral(resourceName: "Bubble Currency Small"), WithOffset: -4.25)
		}
		
		return str
	}
	
	// MARK: Utility Functions
	
	private func coinsEarned() -> Int {
		let roundTime = UserDefaults.standard.integer(forKey: "roundTime")
		let coinsEarnedDict = [9: 1, 7: 2, 5: 3]
		return (self.currentScore / 5) * (coinsEarnedDict[roundTime] ?? 1)
	}
}
