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
	func purchase(Product: SKProduct, BubbleAmount: Int, Completion: @escaping (Bool) -> Void) {
		SwiftyStoreKit.purchaseProduct(Product, quantity: 1, atomically: true) { result in
			switch result {
			case .success(let product):
				if product.needsFinishTransaction {
					SwiftyStoreKit.finishTransaction(product.transaction)
				}
				else {
					Currency.addBubbles(Amount: BubbleAmount)
					print("[SUCCESS] Bubble Purchase Completed")
					Completion(true)
				}
				
			case .error(let error):
				// vc.presentAlert(title: "Could Not Complete Purchase", message: "Please try again", actions: nil)
				switch error.code {
				case .unknown: print("[ERROR] Unknown error. Please contact support"); Completion(false);
				case .clientInvalid: print("[ERROR] Not allowed to make the payment"); Completion(false);
				case .paymentCancelled: print("[ERROR] Payment Cancelled."); break
				case .paymentInvalid: print("[ERROR] The purchase identifier was invalid"); Completion(false);
				case .paymentNotAllowed: print("[ERROR] The device is not allowed to make the payment"); Completion(false);
				case .storeProductNotAvailable: print("[ERROR] The product is not available in the current storefront"); Completion(false);
				case .cloudServicePermissionDenied: print("[ERROR] Access to cloud service information is not allowed"); Completion(false);
				case .cloudServiceNetworkConnectionFailed: print("[ERROR] Could not connect to the network"); Completion(false);
				case .cloudServiceRevoked: print("[ERROR] User has revoked permission to use this cloud service"); Completion(false);
				default: print((error as NSError).localizedDescription); Completion(false);
				}
			}
		}
	}
	
	func productFor(BubbleAmount: Int, Completion: @escaping (SKProduct?) -> Void) {
		let productId = "\(BubbleAmount)bubbles" /* "com.deltavel.bubbleraps.\(BubbleAmount)bubbles" */
		SwiftyStoreKit.retrieveProductsInfo([productId]) { result in
			if let product = result.retrievedProducts.first {
				let priceString = product.localizedPrice!
				print("[INFO] Product Name: \(product.localizedTitle)")
				print("[INFO] Product Price: \(priceString)")
				
				Completion(product)
			}
			else if let invalidProductId = result.invalidProductIDs.first {
				print("[ERROR] Invalid Product Identifier: \(invalidProductId)")
				Completion(nil)
			}
			else if let error = result.error {
				print("[ERROR] Error Retrieving Products Info [PurchaseHelper.retrieveProductsInfo]")
				print("Error Message: \(error)")
				Completion(nil)
			}
		}
	}
}
