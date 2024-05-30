//
//  RhymeEngine.swift
//  Bubble Raps
//
//  Created by Alexander Lester on 12/17/20.
//  Copyright © 2020 Delta Vel. All rights reserved.
//

import Foundation
import Alamofire

enum RhymeType: String {
	case perfect = "rel_rhy"
	case approximate = "rel_nry"
	case homophone = "rel_hom"
	case consonant = "rel_cns"
}

enum RandomWordAPI {
	case randomWordAPI
	case datamuse
	case local
}

struct RhymeEngine {
	
	var topicWords: [String]?
	
	var currentWordPack: WordPack?
	var nextWordPack: WordPack?
	
	init() {
		self.topicWords = self.fetchRandomWordsLocally(count: 100)
		
		
	}
	
	mutating func createWordPack(topic: String?, completion: @escaping (WordPack?) -> ()) {
		guard let randomTopicWord = self.topicWords?.removeFirst() else {
			print("[ERROR] Failed To Create WordPack. [MESSAGE] Failed To Validate RhymeEngine.topicWords.")
			completion(nil)
			return
		}
		
		// Fetch 20 Random Words + 1 Extra To Replenish RhymeEngine.topicWords.
		guard var randomWords = self.fetchRandomWordsLocally(count: 21) else {
			print("[ERROR] Failed To Create WordPack. [MESSAGE] Failed To Fetch Random Words.")
			completion(nil)
			return
		}
		
		// Replenish RhymeEngine.topicWords
		if let extraRandomWord = randomWords.popLast() {
			self.topicWords?.append(extraRandomWord)
		}
		
		// Create Topic Word
		let topicWord = topic ?? randomTopicWord
		
		// -- Fetch Rhymes
		self.fetchRhymesFor(topicWord) { rhymes in
			let rhymeWords = rhymes.map { $0.word }
			
			// Create rhymeDictionary
			var rhymeDictionary = [String: Bool]()
			randomWords.forEach { rhymeDictionary[$0] = false }
			rhymeWords.forEach { rhymeDictionary[$0] = true }
			
			// Create allWords
			var allWords = [String]()
			allWords.append(contentsOf: rhymeWords)
			allWords.append(contentsOf: randomWords)
			
			// Create WordPack
			let wordPack = WordPack(topic: topicWord, rhymes: rhymeWords, notRhymes: randomWords, allWords: allWords, rhymeDictionary: rhymeDictionary)
			completion(wordPack)
		}
	}
	
	fileprivate func fetchRandomWordsLocally(count: Int = 100) -> [String]? {
		var randomWords: [String] = []
		
		guard let allRandomWordsPath = Bundle.main.path(forResource: "allRandomWords", ofType: "json") else {
			print("[ERROR] Failed To Fetch Random Words. [MESSAGE] Failed To Validate Path To allRandomWords.json.")
			return nil
		}
		
		do {
			let data = try Data(contentsOf: URL(fileURLWithPath: allRandomWordsPath))
			let allWords = try JSONDecoder().decode([String].self, from: data)
			let shuffledWords = allWords.shuffled()
			
			randomWords = Array(shuffledWords.prefix(count))
		}
		catch {
			print("[ERROR] Failed To Fetch Random Words. [MESSAGE] Failed To Decode allRandomWords.json: \(error)")
			return nil
		}
		
		return randomWords
	}
	
	fileprivate func fetchRandomWords(count: Int = 21, _ api: RandomWordAPI = .randomWordAPI, completion: @escaping ([String]) -> ()) {
		switch api {
			case .datamuse:
				AF.request("https://random-word-api.herokuapp.com/word?number=\(count)", method: .get).validate().responseJSON { (JSONResponse) in
					switch JSONResponse.result {
						case .success(let json):
							guard let randomWords = json as? [String] else { print("[ERROR] Unable To Convert JSON Response Into String Array."); return }
							completion(randomWords)
						case .failure(let error):
							print("[ERROR] Unable To Fetch Random Words From API. [MESSAGE] \(error.localizedDescription)")
							return
					}
				}
			case .randomWordAPI:
				AF.request("https://random-word-api.herokuapp.com/word?number=\(count)", method: .get).validate().responseJSON { (JSONResponse) in
					switch JSONResponse.result {
						case .success(let json):
							guard let randomWords = json as? [String] else { print("[ERROR] Unable To Convert JSON Response Into String Array."); return }
							completion(randomWords)
						case .failure(let error):
							print("[ERROR] Unable To Fetch Random Words From API. [MESSAGE] \(error.localizedDescription)")
							return
					}
				}
			case .local:
				var randomWords: [String] = []
				
				guard let allRandomWordsPath = Bundle.main.path(forResource: "allRandomWords", ofType: "json") else {
					print("[ERROR] Failed To Fetch Random Words. [MESSAGE] Failed To Validate Path To allRandomWords.json.")
					return
				}
				
				do {
					let data = try Data(contentsOf: URL(fileURLWithPath: allRandomWordsPath))
					let allWords = try JSONDecoder().decode([String].self, from: data)
					let shuffledWords = allWords.shuffled()
					
					randomWords = Array(shuffledWords.prefix(count))
				}
				catch {
					print("[ERROR] Failed To Fetch Random Words. [MESSAGE] Failed To Decode allRandomWords.json: \(error)")
				}
				
				completion(randomWords)
		}
	}
	
	fileprivate func fetchRhymesFor(_ word: String, rhymeType: RhymeType = .perfect, completion: @escaping ([Rhyme]) -> ()) {
		let param = "?\(rhymeType.rawValue)=\(word)"
		AF.request("https://api.datamuse.com/words\(param)", method: .get).validate().responseDecodable(of: [Rhyme].self) { response in
			print(response)
		}
	}
}
