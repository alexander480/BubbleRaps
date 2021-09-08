//
//  Packs.swift
//  Bubble Raps
//
//  Created by Alexander Lester on 9/8/21.
//  Copyright © 2021 Delta Vel. All rights reserved.
//

import Foundation

struct Packs {
	// Variables
	// -------------------------
	
	var unlocked: [String] {
		get { return self.unlockedPacks() }
	}
	
	var current: String {
		get { return self.currentPack() }
		
		/// Update In User Defaults & Reload Topics
		set(newPack) {
			self.current = self.updateCurrentPack(newPack)
			self.currentTopics = self.topicsFor(newPack)
		}
	}
	
	var currentTopics = [String]()
	
	// Methods
	// -------------------------
	
	private func unlockedPacks() -> [String] {
		if let unlockedPacks = UserDefaults.standard.array(forKey: "unlockedPacks") as? [String] {
			print("[INFO] Unlocked Word Packs: \(unlockedPacks).")
			return unlockedPacks
		} else {
			print("[WARNING] Failed To Validate Unlocked Packs. [INFO] Updating User Defaults Now.")
			UserDefaults.standard.set(["Standard"], forKey: "unlockedPacks")
			return ["Standard"]
		}
	}
	
	private func currentPack() -> String {
		if let currentPack = UserDefaults.standard.string(forKey: "pack") {
			print("[INFO] Current Pack: \(currentPack).")
			return currentPack
		} else {
			print("[WARNING] Failed To Validate Current Pack. [INFO] Updating User Defaults Now.")
			UserDefaults.standard.set("Standard", forKey: "pack")
			return "Standard"
		}
	}
	
	private func updateCurrentPack(_ newPack: String) -> String {
		if (self.unlocked.contains(newPack)) {
			UserDefaults.standard.set(newPack, forKey: "pack")
			print("[INFO] Pack Updated: \(newPack)")
			return newPack
		} else {
			print("[WARNING] Failed To Update Current Pack. [MESSAGE] Pack Has Not Been Unlocked.")
			print("[INFO] Reverting To Default Pack.")
			UserDefaults.standard.set("Standard", forKey: "pack")
			return "Standard"
		}
	}
	
	private func topicsFor(_ packName: String = "Standard") -> [String] {
		let packs: [String: [String]] = [
			"Standard": ["shine", "made", "trust", "grand", "shed", "dance", "shape", "vapor", "fight", "cold", "grapple", "unicorn", "automobile", "cigarette", "sunny", "extension", "amaze", "focus", "noise", "scent", "shave", "control", "human", "crown", "shuffle", "amazing", "rhyme", "grind", "chance", "grand"],
			
			"Fashion": ["supreme", "leather", "louis", "tailor", "style", "footwear", "brand", "lingerie", "swagger", "dolce", "timberlands", "clothes", "vogue", "designer", "couture", "vuitton", "armani", "menswear", "prada", "trend", "escada", "versace", "glamour", "gucci"],
			
			"Football": ["fullback", "quarterback", "pigskin", "league", "punter", "tackle", "kick", "touchdown", "rusher", "championship", "coach", "fans", "center", "snapper", "kickoff", "player", "season", "game", "playoffs", "SuperBowl", "rings", "Lombardi", "packers", "lions", "cowboys", "bears", "browns", "seahawks", "colts", "chiefs", "bills", "redskins", "jets", "rams", "buccaneers", "jaguars", "Crews", "Brady", "Manning", "Favre", "Jackson", "Newton", "Brees", "Romo", "Bradshaw", "Montana", "Rice", "Fitzgerald", "Luck"],
			
			"Money": ["cash", "fund", "dime", "penny", "coffer", "pay", "amount", "sum", "loot", "paid", "amounts", "financing", "finance", "dough", "payoff", "monetary", "revenue", "wealth", "quid", "lucre", "payment", "investment", "spending", "dollar", "contributions", "income", "purse", "payroll", "stash", "appropriation", "buck", "expensive", "cost", "bet", "wherewithal", "liquidity", "wallet", "aid", "pocket", "salary", "bribe", "allocation", "coin", "fee", "credit", "hay", "means", "booty", "ticket", "expense", "profit", "loan", "retraining", "recycle", "denarii", "contribution", "reward", "treasure", "wash", "gravy", "bread", "pecuniary", "fiscal", "scratch", "gold", "stock", "washing", "price", "are", "popcorn", "mandate", "grubbing", "dear", "muni", "profitability"],
			
			"Jewelry": ["jeweler", "necklace", "jewels", "gemstone", "bling", "gold", "decoration", "gem", "jewel", "jeweller", "gun", "junk", "baby", "puppy", "fork", "whistle", "brooch", "beadwork", "jewelers", "antiques", "gemstones", "handbags", "baubles", "bangle", "pendant", "pendants", "tableware", "bangles", "dinnerware", "bead", "kitchenware", "bridal", "lockets", "ceramics", "cosmetics", "perfumes", "furs", "flatware", "cookware", "jadeite", "jade", "oroide", "rhinestone", "lingerie"],
			
			"Cars": ["automobile", "motorcar", "auto", "railcar", "machine", "gondola", "automobiles", "trucks", "sedans", "vans", "buses", "autos", "motor", "lorries", "motors", "trains", "wheels", "carts", "wagons", "automotive", "wagon", "tanks", "machines", "carloads", "boxcars", "crates", "rail", "bombs", "coaches", "grain", "blasts", "trials", "injunctions", "writs", "makers", "automakers", "railcars", "motorcycles", "bikes", "junkers", "wheelers", "scooters", "coupes", "garages", "minivan", "cruisers", "lamborghini", "tractors", "tires", "drivers", "jeeps", "pickups", "limousines", "boats", "cabs", "taxicabs", "hatchback"]
		]
		
		if (self.unlocked.contains(packName)) {
			let topics = packs[packName] ?? packs["Standard"]!
			return topics
		} else {
			print("[WARNING] Failed To Update Topics. [MESSAGE] Pack Has Not Been Unlocked.")
			print("[INFO] Reverting To Default Topics.")
			let topics = packs["Standard"]!
			return topics
		}
	}
}
