//
//  Packs.swift
//  Packs
//
//  Created by Alexander Lester on 9/23/21.
//  Copyright © 2021 Delta Vel. All rights reserved.
//

import Foundation

struct Packs {
	static let keys = ["Standard", "Football", "Fashion", "Jewelry", "Money", "Cars"]
	
	static let allPacks = ["Standard": Packs.standard, "Fashion": Packs.fashion, "Football": Packs.football, "Money": money, "Jewelry": Packs.jewelry, "Cars": Packs.cars]
	
	static let standard = ["shine", "made", "trust", "grand", "shed", "dance", "shape", "vapor", "fight", "cold", "grapple", "unicorn", "automobile", "cigarette", "sunny", "extension", "amaze", "focus", "noise", "scent", "shave", "control", "human", "crown", "shuffle", "amazing", "rhyme", "grind", "chance", "grand"]
	
	static let fashion = ["supreme", "leather", "louis", "tailor", "style", "footwear", "brand", "lingerie", "swagger", "dolce", "timberlands", "clothes", "vogue", "designer", "couture", "vuitton", "armani", "menswear", "prada", "trend", "escada", "versace", "glamour", "gucci"]
	
	static let football = ["fullback", "quarterback", "pigskin", "league", "punter", "tackle", "kick", "touchdown", "rusher", "championship", "coach", "fans", "center", "snapper", "kickoff", "player", "season", "game", "playoffs", "SuperBowl", "rings", "Lombardi", "packers", "lions", "cowboys", "bears", "browns", "seahawks", "colts", "chiefs", "bills", "redskins", "jets", "rams", "buccaneers", "jaguars", "Crews", "Brady", "Manning", "Favre", "Jackson", "Newton", "Brees", "Romo", "Bradshaw", "Montana", "Rice", "Fitzgerald", "Luck"]
	
	static let money = ["cash", "fund", "dime", "penny", "coffer", "pay", "amount", "sum", "loot", "paid", "amounts", "financing", "finance", "dough", "payoff", "monetary", "revenue", "wealth", "quid", "lucre", "payment", "investment", "spending", "dollar", "contributions", "income", "purse", "payroll", "stash", "appropriation", "buck", "expensive", "cost", "bet", "wherewithal", "liquidity", "wallet", "aid", "pocket", "salary", "bribe", "allocation", "coin", "fee", "credit", "hay", "means", "booty", "ticket", "expense", "profit", "loan", "retraining", "recycle", "denarii", "contribution", "reward", "treasure", "wash", "gravy", "bread", "pecuniary", "fiscal", "scratch", "gold", "stock", "washing", "price", "are", "popcorn", "mandate", "grubbing", "dear", "muni", "profitability"]
	
	static let jewelry = ["jeweler", "necklace", "jewels", "gemstone", "bling", "gold", "decoration", "gem", "jewel", "jeweller", "gun", "junk", "baby", "puppy", "fork", "whistle", "brooch", "beadwork", "jewelers", "antiques", "gemstones", "handbags", "baubles", "bangle", "pendant", "pendants", "tableware", "bangles", "dinnerware", "bead", "kitchenware", "bridal", "lockets", "ceramics", "cosmetics", "perfumes", "furs", "flatware", "cookware", "jadeite", "jade", "oroide", "rhinestone", "lingerie"]
	
	static let cars = ["automobile", "motorcar", "auto", "railcar", "machine", "gondola", "automobiles", "trucks", "sedans", "vans", "buses", "autos", "motor", "lorries", "motors", "trains", "wheels", "carts", "wagons", "automotive", "wagon", "tanks", "machines", "carloads", "boxcars", "crates", "rail", "bombs", "coaches", "grain", "blasts", "trials", "injunctions", "writs", "makers", "automakers", "railcars", "motorcycles", "bikes", "junkers", "wheelers", "scooters", "coupes", "garages", "minivan", "cruisers", "lamborghini", "tractors", "tires", "drivers", "jeeps", "pickups", "limousines", "boats", "cabs", "taxicabs", "hatchback"]
}

extension Packs {
	func getShuffledWordPack(Named: String?) -> [String] {
		return Packs.allPacks[Named ?? "Standard"]?.shuffled() ?? Packs.standard.shuffled()
	}
	
	func getShuffledWordPack(FromIndex: Int) -> [String] {
		let named = Packs.keys[FromIndex]
		return Packs.allPacks[named]?.shuffled() ?? Packs.standard.shuffled()
	}
	
	func getWordPackKey(FromIndex: Int) -> String {
		return Packs.keys[FromIndex]
	}
}

extension Packs {
	static let packCost = 750
	
	static func purchase(_ packName: String) -> UnlockableStatus {
		if (Packs.unlocked().contains(packName)) { print("[WARNING] User Has Already Unlocked \(packName) Word Pack."); return .alreadyUnlocked }
		if (Packs.packCost > Currency.currentBubbleBalance()) { print("[WARNING] User Does Not Have Enough Bubbles To Purchase This Word Pack."); return .notEnoughBubbles }
		
		Currency.subtractBubbles(Amount: Packs.packCost)
		Packs.unlock(packName)
		
		return .success
	}
	
	static func unlock(_ packName: String) {
		var newUnlockedPacks = Packs.unlocked()
		newUnlockedPacks.append(packName)
		
		UserDefaults.standard.set(newUnlockedPacks, forKey: "unlockedPacks")
		print("[INFO] \(packName) Word Pack Unlocked!")
	}
	
	static func unlocked() -> [String] {
		guard let unlockedPacks = UserDefaults.standard.array(forKey: "unlockedPacks") as? [String] else {
			UserDefaults.standard.set(["Standard"], forKey: "unlockedPacks"); return ["Standard"]
		}
		
		return unlockedPacks
	}
}
