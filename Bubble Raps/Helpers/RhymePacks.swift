//
//  RhymeBundle.swift
//  Bubble Raps
//
//  Created by Alexander Lester on 6/26/24.
//  Copyright © 2024 Delta Vel. All rights reserved.
//

import Foundation

struct RhymePacks {
	var data: [RhymePack]
	
	init() {
		guard let jsonFile = Bundle.main.url(forResource: "daleChallRhymeBundles", withExtension: "json") else {
			print("[ERROR] Failed To Convert JSON File To RhymePack Array.");
			self.data = [RhymePack]()
			return
		}
		
		do {
			let jsonData = try Data(contentsOf: jsonFile)
			let decoder = JSONDecoder()
			let rhymePacks = try decoder.decode([RhymePack].self, from: jsonData)
			print("[SUCCESS] Successfully Decoded RhymePacks.")
			
			self.data = rhymePacks.shuffled()
		}
		catch {
			print("[ERROR] Failed To Decode JSON File. [MESSAGE] \(error.localizedDescription)")
			self.data = [RhymePack]()
		}
	}
}

struct RhymePack: Codable {
	let topic: String
	let rhymes: [String]
	let notRhymes: [String]
	let rhymeDictionary: [String: Bool]
	let allWords: [String]
}
