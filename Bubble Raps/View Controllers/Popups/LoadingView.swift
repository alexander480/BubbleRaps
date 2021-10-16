//
//  LoadingView.swift
//  LoadingView
//
//  Created by Alexander Lester on 9/23/21.
//  Copyright © 2021 Delta Vel. All rights reserved.
//

import UIKit

class LoadingView: UIView {
	
	var container: UIView
	var label: UILabel

	override init(frame: CGRect) {
		self.container = UIView()
		self.label = UILabel()
		
		super.init(frame: frame)
		
		let blurEffect = UIBlurEffect(style: .regular)
		let blurEffectView = UIVisualEffectView(effect: blurEffect)
			blurEffectView.frame = self.frame
		self.addSubview(blurEffectView)
		
		let containerSize = CGSize(width: 270, height: 85)
		let containerOrigin = CGPoint(x: (self.frame.size.width - 270) / 2, y: (self.frame.size.height - 85) / 2)
		self.container.frame = CGRect(origin: containerOrigin, size: containerSize)
		self.container.backgroundColor = Theme.primary()
		self.container.layer.cornerRadius = 22
		
		let labelSize = CGSize(width: 270, height: 85)
		let labelOrigin = CGPoint(x: 0, y: 0)
		self.label.frame = CGRect(origin: labelOrigin, size: labelSize)
		self.label.textColor = .white
		self.label.font = UIFont(name: "Avenir Next Heavy Italic", size: 22.0)
		self.label.text = "Loading..."
		self.label.textAlignment = .center
		
		self.container.addSubview(self.label)
		self.addSubview(self.container)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
