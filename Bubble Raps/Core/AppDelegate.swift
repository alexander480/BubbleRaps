//
//  AppDelegate.swift
//  RhymingBubbles
//
//  Created by Delta Vel on 6/24/19.
//  Copyright © 2019 Delta Vel. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import GoogleMobileAds
import SwiftyStoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// MARK: Handle Uncompleted Purchases
		SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
			for purchase in purchases {
				switch purchase.transaction.transactionState {
				case .purchased, .restored:
					if purchase.needsFinishTransaction {
						// Deliver content from server, then:
						SwiftyStoreKit.finishTransaction(purchase.transaction)
					}
					// Unlock content
				case .failed:
					print("[ERROR] Transaction Failed [didFinishLaunchingWithOptions] [SwiftyStoreKit.completeTransactions()]")
					break
				case .deferred:
					print("[WARNING] Transaction Has Been Deferred [didFinishLaunchingWithOptions] [SwiftyStoreKit.completeTransactions()]")
					break
				case .purchasing:
					print("[INFO] Currently Processing Transaction [didFinishLaunchingWithOptions] [SwiftyStoreKit.completeTransactions()]")
					break
				@unknown default:
					print("[ERROR] Unknown Error Occured In [didFinishLaunchingWithOptions] [SwiftyStoreKit.completeTransactions()] [] ")
					break
				}
			}
		}
		
		// MARK: Initialize Firebase
		FirebaseApp.configure()
		
		// MARK: Initialize Google AdMobs
		GADMobileAds.sharedInstance().start(completionHandler: nil)
		
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
		// MARK: Save Data Before Termination
		self.saveContext()
    }
	
	// MARK: Setup Persistent Container For Core Data
	lazy var persistentContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "BubbleRaps")
		container.loadPersistentStores(completionHandler: { (storeDescription, error) in
			if let error = error as NSError? {
				// Replace this implementation with code to handle the error appropriately.
				// fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
				
				/*
				Typical reasons for an error here include:
				* The parent directory does not exist, cannot be created, or disallows writing.
				* The persistent store is not accessible, due to permissions or data protection when the device is locked.
				* The device is out of space.
				* The store could not be migrated to the current model version.
				Check the error message to determine what the actual problem was.
				*/
				
				// TODO: Remove Fatal Error Before Releasing App
				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		})
		
		return container
	}()
	
	func saveContext() {
		let context = persistentContainer.viewContext
		if context.hasChanges {
			do { try context.save() }
			catch {
				// Replace this implementation with code to handle the error appropriately.
				// fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
				
				// TODO: Remove Fatal Error Before Releasing App
				
				let nserror = error as NSError
				fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
			}
		}
	}

}
