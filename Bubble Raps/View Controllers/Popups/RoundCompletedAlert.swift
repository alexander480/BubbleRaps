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
	
	@IBOutlet weak var coinView: UIView!
	@IBOutlet weak var coinLabel: UILabel!
	
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var subtitleLabel: UILabel!
	
	@IBOutlet weak var nextButton: UIButton!
	@IBAction func nextButtonAction(_ sender: Any) {
		if isGameOver { self.dismiss(animated: true) { self.delegate?.gameOverClicked() } }
		else { self.dismiss(animated: true) { self.delegate?.nextRoundClicked() } }
	}
	
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
			
			self.coinView.isHidden = false
			self.coinLabel.text = "+\(coinsEarned) 🅒"
			
			let currentCoins = UserDefaults.standard.integer(forKey: "coins")
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
			self.coinView.isHidden = true
			self.backgroundImageView.image = #imageLiteral(resourceName: "Next Round Popup Background")
			self.nextButton.setBackgroundImageForAllStates(image: #imageLiteral(resourceName: "Next Round Button"))
			self.titleLabel.text = "Round Completed!"
			self.subtitleLabel.text = "\(self.currentScore) Correct Answers"
		}
	}
}
