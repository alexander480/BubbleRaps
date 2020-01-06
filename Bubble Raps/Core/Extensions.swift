//
//  Extensions.swift
//  RhymingBubbles
//
//  Created by Delta Vel on 6/29/19.
//  Copyright © 2019 Delta Vel. All rights reserved.
//

import Foundation
import UIKit
import AmazingBubbles
import GoogleMobileAds
import Crashlytics

// MARK: UIViewController Extensions

extension UIViewController {
	func presentAlert(title: String, message: String?, actions: [UIAlertAction]?) {
		if let alertActions = actions {
			let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
			for action in alertActions { alert.addAction(action) }
			
			self.present(alert, animated: true, completion: nil)
		}
		else {
			let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action) in alert.dismiss(animated: true, completion: nil) }))
			
			self.present(alert, animated: true, completion: nil)
		}
	}
	
	func present(Interstatial: GADInterstitial) {
		if Interstatial.isReady { Interstatial.present(fromRootViewController: self) }
		else { print("Ad wasn't ready") }
	}
}

// MARK: UIView IBDesignables Extensions

@IBDesignable extension UIView {
	@IBInspectable var isCircular: Bool {
		set { self.layer.cornerRadius = self.frame.size.width/2; self.clipsToBounds = true }
		get { if self.layer.cornerRadius == self.frame.size.width/2 { return true } else { return false } }
	}
    @IBInspectable var borderColor: UIColor? {
        set { layer.borderColor = newValue!.cgColor }
        get { if let color = layer.borderColor { return UIColor(cgColor:color) } else { return nil } }
    }
    @IBInspectable var borderWidth: CGFloat {
        set { layer.borderWidth = newValue }
        get { return layer.borderWidth }
    }
    @IBInspectable var cornerRadius: CGFloat {
        set { layer.cornerRadius = newValue; clipsToBounds = newValue > 0 }
        get { return layer.cornerRadius }
    }
	@IBInspectable var shadowPathEqualsFrame: Bool {
		set { layer.shadowPath = UIBezierPath(rect: self.frame).cgPath }
		get { if let path = layer.shadowPath { if path.isEmpty { return false } else { return true } } else { return false } }
	}
    @IBInspectable var shadowColor: UIColor? {
        set { layer.shadowColor = newValue!.cgColor }
        get { if let color = layer.borderColor { return UIColor(cgColor: color) } else { return nil } }
    }
    @IBInspectable var shadowOpacity: Float {
        set { layer.shadowOpacity = newValue }
        get { return layer.shadowOpacity }
    }
    @IBInspectable var shadowOffset: CGSize {
        set { layer.shadowOffset = newValue }
        get { return layer.shadowOffset }
    }
    @IBInspectable var shadowBlur: CGFloat {
        set { layer.shadowRadius = newValue }
        get { return layer.shadowRadius }
    }
}

// MARK: UIButton Extensions

extension UIButton {
	func setImageForAllStates(image: UIImage) {
		self.setImage(image, for: .normal)
		self.setImage(image, for: .selected)
		self.setImage(image, for: .highlighted)
		self.setImage(image, for: .disabled)
	}
	
	func setBackgroundImageForAllStates(image: UIImage) {
		self.setBackgroundImage(image, for: .normal)
		self.setBackgroundImage(image, for: .selected)
		self.setBackgroundImage(image, for: .highlighted)
		self.setBackgroundImage(image, for: .disabled)
	}
	
	func setTitleForAllStates(title: String) {
		self.setTitle(title, for: .normal)
		self.setTitle(title, for: .selected)
		self.setTitle(title, for: .highlighted)
		self.setTitle(title, for: .disabled)
	}
	
	func setAttributedTitleForAllStates(title: NSAttributedString) {
		self.setAttributedTitle(title, for: .normal)
		self.setAttributedTitle(title, for: .selected)
		self.setAttributedTitle(title, for: .highlighted)
		self.setAttributedTitle(title, for: .disabled)
	}
}

// MARK: ContentBubblesView Extensions

extension ContentBubblesView {
	func changeBubble(isCorrect: Bool, index: Int) {
		if isCorrect {
			if let labelView = self.bubbleViews[index] as? LabelBubbleView {
				
				// Just Change Bubble Color
				labelView.imageView.image = #imageLiteral(resourceName: "Correct Bubble (No Icon) ")
				
				// Display Checkmark Symbol
				// labelView.label.isHidden = true
				// labelView.imageView.image = #imageLiteral(resourceName: "Correct Bubble")
				// labelView.imageView.isHidden = false
			}
		}
		else {
			if let labelView = self.bubbleViews[index] as? LabelBubbleView {
				
				// Just Change Bubble Color
				labelView.imageView.image = #imageLiteral(resourceName: "Incorrect Bubble (No Icon) ")
				
				// Display Minus Symbol
				// labelView.label.isHidden = true
				// labelView.imageView.image = #imageLiteral(resourceName: "Incorrect Bubble")
				//labelView.imageView.isHidden = false
			}
		}
	}
	
	func removeBubbles() {
		if self.bubbleViews.isEmpty == false {
			for bubble in self.bubbleViews {
				self.removeBehaviors(for: bubble)
				bubble.removeFromSuperview()
			}
			self.bubbleViews.removeAll()
		}
	}
}

// MARK: Reachability Extensions

import SystemConfiguration

public class ReachabilityHelper {
	class func isConnectedToNetwork() -> Bool {
		var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
		zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
		zeroAddress.sin_family = sa_family_t(AF_INET)
		
		let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
			$0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
				SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
			}
		}
		
		var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
		if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
			return false
		}
		
		// Working for Cellular and WIFI
		let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
		let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
		let ret = (isReachable && !needsConnection)
		
		return ret
	}
}

// MARK: Crashlytics Extensions

extension Crashlytics {
	func testCrashlyticsAlert() -> UIAlertController {
		let alert = UIAlertController(title: "Test Crashlytics", message: "Pressing The 'Crash' Button Will Immediatly Crash The App. Should Only Be Used To Test Crashlytics Monitoring.", preferredStyle: .actionSheet)
		let crashAction = UIAlertAction(title: "Crash", style: .destructive, handler: { (action) in
			Crashlytics.sharedInstance().setUserIdentifier("000000000")
			Crashlytics.sharedInstance().crash()
			
			alert.dismiss(animated: true, completion: nil)
		})
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
			alert.dismiss(animated: true, completion: nil)
		}
		
		alert.addAction(crashAction)
		alert.addAction(cancelAction)
		
		return alert
	}
}

// MARK: NSAttributedString Extensions

extension NSMutableAttributedString {
	func add(Image: UIImage, WithOffset: CGFloat?) {
		let imageAttachment =  NSTextAttachment()
		imageAttachment.image = Image
		
		let fontHeight = self.height(withConstrainedWidth: 83.0) / 1.25
		
		let imageOffsetY:CGFloat = WithOffset ?? -4.0
		imageAttachment.bounds = CGRect(x: 0, y: imageOffsetY, width: fontHeight, height: fontHeight)
		
		let attachmentString = NSAttributedString(attachment: imageAttachment)
		self.append(attachmentString)
	}
	
	func height(withConstrainedWidth width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)

        return ceil(boundingBox.height)
    }
}
