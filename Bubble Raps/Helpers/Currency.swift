//
//  Currency.swift
//  Currency
//
//  Created by Alexander Lester on 9/23/21.
//  Copyright © 2021 Delta Vel. All rights reserved.
//

import Foundation

struct Currency {
	static func currentBubbleBalance() -> Int {
		return UserDefaults.standard.integer(forKey: "bubbles")
	}
	
	static func addBubbles(Amount: Int) {
		let currentBubbles = UserDefaults.standard.integer(forKey: "bubbles")
		UserDefaults.standard.set(currentBubbles + Amount, forKey: "bubbles")
	}
	
	static func subtractBubbles(Amount: Int) {
		let currentBubbles = UserDefaults.standard.integer(forKey: "bubbles")
		UserDefaults.standard.set(currentBubbles - Amount, forKey: "bubbles")
	}
	
	static func doesUserHaveEnoughBubbles(Cost: Int) -> Bool {
		let currentBubbles = UserDefaults.standard.integer(forKey: "bubbles")
		let remainingBubbles = currentBubbles - Cost
		if remainingBubbles >= 0 { return true } else { return false }
	}
	
	static func bubbleBalanceWithIcon() -> NSMutableAttributedString {
		return Theme.addBubbleIconTo("\(Currency.currentBubbleBalance())", color: .white, size: 14.0, offset: -4.15)
	}
}
