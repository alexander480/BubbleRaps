//
//  LargeMenuView.swift
//  RhymingBubbles
//
//  Created by Alexander Lester on 9/4/19.
//  Copyright © 2019 Delta Vel. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class LargeMenuView: UIView {
	@IBOutlet weak var backgroundImage: UIImageView!
	@IBOutlet weak var title: UILabel!
	@IBOutlet weak var value: UILabel!
	
	@IBOutlet var tapRecognizer: UITapGestureRecognizer!
	
	/*
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	*/
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}
	
	func commonInit() {
		let bundle = Bundle.init(for: LargeMenuView.self)
		if let viewsToAdd = bundle.loadNibNamed("LargeMenuView", owner: self, options: nil), let contentView = viewsToAdd.first as? UIView {
			addSubview(contentView)
			contentView.frame = self.bounds
			contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
		}
	}
}
