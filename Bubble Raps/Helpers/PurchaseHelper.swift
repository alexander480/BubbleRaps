//
//  PurchaseHelper.swift
//  RhymingBubbles
//
//  Created by Alexander Lester on 9/26/19.
//  Copyright © 2019 Delta Vel. All rights reserved.
//

import Foundation
import StoreKit
import SwiftyStoreKit

// Maybe Allow People To Purchase Hints or Additional Time

class PurchaseHelper: NSObject {
	func purchase(Product: SKProduct, BubbleAmount: Int, vc: UIViewController) {
		SwiftyStoreKit.purchaseProduct(Product, quantity: 1, atomically: true) { result in
			switch result {
			case .success(let product):
				if product.needsFinishTransaction {
					SwiftyStoreKit.finishTransaction(product.transaction)
				}
				else {
					let currentBubbles = UserDefaults.standard.integer(forKey: "bubbles")
					UserDefaults.standard.set(currentBubbles + BubbleAmount, forKey: "bubbles")
					
					print("[SUCCESS] Bubble Purchase Completed")
					vc.presentAlert(title: "Purchase Complete!", message: "\(BubbleAmount) bubbles have been added to your account", actions: nil)
				}
				
			case .error(let error):
				vc.presentAlert(title: "Could Not Complete Purchase", message: "Please try again", actions: nil)
				switch error.code {
				case .unknown: print("[ERROR] Unknown error. Please contact support")
				case .clientInvalid: print("[ERROR] Not allowed to make the payment")
				case .paymentCancelled: break
				case .paymentInvalid: print("[ERROR] The purchase identifier was invalid")
				case .paymentNotAllowed: print("[ERROR] The device is not allowed to make the payment")
				case .storeProductNotAvailable: print("[ERROR] The product is not available in the current storefront")
				case .cloudServicePermissionDenied: print("[ERROR] Access to cloud service information is not allowed")
				case .cloudServiceNetworkConnectionFailed: print("[ERROR] Could not connect to the network")
				case .cloudServiceRevoked: print("[ERROR] User has revoked permission to use this cloud service")
				default: print((error as NSError).localizedDescription)
				}
			}
		}
	}
	
	func productFor(BubbleAmount: Int) -> SKProduct? {
		var finalResult: SKProduct? = nil
		
		SwiftyStoreKit.retrieveProductsInfo(["com.deltavel.bubbleraps.\(BubbleAmount)bubbles"]) { result in
			if let product = result.retrievedProducts.first {
				let priceString = product.localizedPrice!
				print("[INFO] Product Name: \(product.localizedDescription)")
				print("[INFO] Product Price: \(priceString)")
				
				finalResult = product
			}
			else if let invalidProductId = result.invalidProductIDs.first {
				print("[ERROR] Invalid Product Identifier: \(invalidProductId)")
				finalResult = nil
			}
			else if let error = result.error {
				print("[ERROR] Error Retrieving Products Info [PurchaseHelper.retrieveProductsInfo]")
				print("Error Message: \(error)")
				finalResult = nil
			}
		}
		
		return finalResult
	}
}
