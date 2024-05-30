//
//  Rhyme.swift
//  Bubble Raps
//
//  Created by Alexander Lester on 12/17/20.
//  Copyright © 2020 Delta Vel. All rights reserved.
//

import Foundation

struct Rhyme: CustomStringConvertible {
	let word: String
	let score: Double
	let numSyllables: Int
	
	var description: String {
		return "Word: \(word) Score: \(score). Syllables: \(numSyllables)"
	}
	
	init(word: String, score: Double, numSyllables: Int) {
		self.word = word
		self.score = score
		self.numSyllables = numSyllables
	}
}

extension Rhyme: Decodable {
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: RhymeKeys.self) // defining our (keyed) container
		let word: String = try container.decode(String.self, forKey: .word) // extracting the data
		let score: Double = try container.decode(Double.self, forKey: .score) // extracting the data
		let numSyllables: Int = try container.decode(Int.self, forKey: .numSyllables) // extracting the data
		
		self.init(word: word, score: score, numSyllables: numSyllables)
	}
	
	enum RhymeKeys: String, CodingKey {
		case word = "word"
		case score = "score"
		case numSyllables = "numSyllables"
	  }
}

