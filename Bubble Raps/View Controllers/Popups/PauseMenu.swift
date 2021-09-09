//
//  PauseMenu.swift
//  RhymingBubbles
//
//  Created by Alexander Lester on 9/1/19.
//  Copyright © 2019 Delta Vel. All rights reserved.
//

import Foundation
import UIKit

protocol PauseMenuDelegate: AnyObject {
	func resumeFromPause()
	func endFromPause()
}

class PauseMenu: UIViewController {
	
	// MARK: Storyboard Outlets
	
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var subtitleLabel: UILabel!
	@IBOutlet weak var pauseView: UIView!
	
	@IBOutlet weak var resumeButton: UIButton!
	@IBAction func resumeButtonAction(_ sender: Any) { self.dismiss(animated: true) { self.delegate?.resumeFromPause() } }
	
	@IBOutlet weak var backButton: UIButton!
	@IBAction func backButtonAction(_ sender: Any) { self.dismiss(animated: true) { self.delegate?.endFromPause() } }
	
	// MARK: Class Variables
	
	let unlockable = UnlockableHelper()
	
	var delegate: PauseMenuDelegate?
	var currentScore = 0
	
	// MARK: Override Functions
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let blurEffect = UIBlurEffect(style: .light)
		let blurEffectView = UIVisualEffectView(effect: blurEffect)
			blurEffectView.frame = self.view.frame
		
		self.view.insertSubview(blurEffectView, at: 0)
		
		self.titleLabel.text = String(describing: self.currentScore)
		self.subtitleLabel.text = "Correct Answers"
		
		self.pauseView.backgroundColor = theme.assets.primary
	}
}
