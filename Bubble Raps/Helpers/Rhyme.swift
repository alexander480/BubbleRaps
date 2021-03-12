//
//  Rhyme.swift
//  Bubble Raps
//
//  Created by Alexander Lester on 12/17/20.
//  Copyright © 2020 Delta Vel. All rights reserved.
//

import Foundation

struct Rhyme {
	let word: String
	let score: Double
	let numSyllables: Int
	
	init(word: String, score: Double, numSyllables: Int) {
		self.word = word
		self.score = score
		self.numSyllables = numSyllables
	}
}

extension Rhyme: Decodable {
	enum RhymeKeys: String, CodingKey { // declaring our keys
		case word = "word"
		case score = "score"
		case numSyllables = "numSyllables"
	  }
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: RhymeKeys.self) // defining our (keyed) container
		let word: String = try container.decode(String.self, forKey: .word) // extracting the data
		let score: Double = try container.decode(Double.self, forKey: .score) // extracting the data
		let numSyllables: Int = try container.decode(Int.self, forKey: .numSyllables) // extracting the data
		
		self.init(word: word, score: score, numSyllables: numSyllables)
	}
}

