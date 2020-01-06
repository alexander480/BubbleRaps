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
	
	@IBOutlet weak var backgroundImageView: UIImageView!
	
	@IBOutlet weak var coinLabel: UILabel!
	
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var subtitleLabel: UILabel!
	
	@IBOutlet weak var nextButton: UIButton!
	@IBAction func nextButtonAction(_ sender: Any) {
		if isGameOver { self.dismiss(animated: true) { self.delegate?.gameOverClicked() } }
		else { self.dismiss(animated: true) { self.delegate?.nextRoundClicked() } }
	}
	
	let unlockable = UnlockableHelper()
	
	var delegate: RoundCompletedAlertDelegate?
	
	var isHighScore = false
	var isGameOver = false
	
	var currentScore = 0
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let blurEffect = UIBlurEffect(style: .light)
		let blurEffectView = UIVisualEffectView(effect: blurEffect)
			blurEffectView.frame = self.view.frame
		
		self.view.insertSubview(blurEffectView, at: 0)
		
		if isGameOver {
			self.backgroundImageView.image = #imageLiteral(resourceName: "Game Over Popup Background")
			self.nextButton.setBackgroundImageForAllStates(image: #imageLiteral(resourceName: "Game Over Button"))
			
			let coinsEarned = self.currentScore / 5
			
			self.coinLabel.attributedText = self.coinsEarnedString(Number: coinsEarned)
			
			let currentCoins = self.unlockable.currentCoinBalance()
			UserDefaults.standard.set(currentCoins + coinsEarned, forKey: "coins")

			if isHighScore {
				self.titleLabel.text = "New High Score!"
				self.subtitleLabel.text = "\(self.currentScore) Correct Answers"
			}
			else {
				self.titleLabel.text = "Game Over"
				self.subtitleLabel.text = "\(self.currentScore) Correct Answers"
			}
		}
		else {
			self.backgroundImageView.image = #imageLiteral(resourceName: "Next Round Popup Background")
			self.nextButton.setBackgroundImageForAllStates(image: #imageLiteral(resourceName: "Next Round Button"))
			self.titleLabel.text = "Round Completed!"
			self.subtitleLabel.text = "\(self.currentScore) Correct Answers"
			
			self.coinLabel.attributedText = self.coinsEarnedString(Number: 1)
		}
	}
	
	private func coinsEarnedString(Number: Int) -> NSMutableAttributedString {
		let str = NSMutableAttributedString(string: "+ \(Number) ")
		if let font = UIFont(name: "AvenirNext-Heavy", size: 26.0) {
			str.addAttribute(.font, value: font, range: NSRange(location: 0, length: str.length))
			str.addAttribute(.foregroundColor, value: #colorLiteral(red: 0.3767357171, green: 0.6819834709, blue: 1, alpha: 1), range: NSRange(location: 0, length: str.length))
			
			str.add(Image: #imageLiteral(resourceName: "Bubble Currency Small"), WithOffset: -5.25)
		}
		
		return str
	}
	
}
