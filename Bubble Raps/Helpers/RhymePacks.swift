//
//  RhymePacks.swift
//  Bubble Raps
//
//  Created by Alexander Lester on 6/26/24.
//  Copyright © 2024 Delta Vel. All rights reserved.
//

import Foundation

struct RhymePacks {
	private var data: [RhymePack]
	private var currentIndex = 0
	
	init(_ category: String = "Standard") {
		let fileName = WordPacks.keyToFileNameDict[category]
		
		guard let jsonFile = Bundle.main.url(forResource: fileName, withExtension: "json") else {
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
	
	mutating func next() -> RhymePack? {
		guard currentIndex + 1 < data.count else {
			print("[INFO] Went Through Entire RhymePack Array. Starting Again From The Beginning.")
			self.currentIndex = 0
			
			return self.data[0]
		}
		
		self.currentIndex = currentIndex + 1

		return self.data[self.currentIndex]
	}
}

struct RhymePack: Codable {
	let topic: String
	let rhymes: [String]
	let notRhymes: [String]
	let rhymeDictionary: [String: Bool]
	let allWords: [String]
}
