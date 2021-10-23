//
//  LoadingScreen.swift
//  Bubble Raps
//
//  Created by Alexander Lester on 9/9/21.
//  Copyright © 2021 Delta Vel. All rights reserved.
//

import UIKit

class LoadingScreenVC: UIViewController {
	@IBOutlet weak var containerView: UIView!
	@IBOutlet weak var titleLabel: UILabel!
	
	// MARK: Override Functions
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let blurEffect = UIBlurEffect(style: .light)
		let blurEffectView = UIVisualEffectView(effect: blurEffect)
		blurEffectView.frame = self.view.frame
		
		self.view.insertSubview(blurEffectView, at: 0)
		
		self.containerView.backgroundColor = Theme.primary()
		self.titleLabel.text = "Loading..."
	}
}
