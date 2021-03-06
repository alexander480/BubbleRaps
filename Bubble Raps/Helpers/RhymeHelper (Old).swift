//
//  Rhyming.swift
//  RhymingBubbles
//
//  Created by Delta Vel on 6/26/19.
//  Copyright © 2019 Delta Vel. All rights reserved.
//

import Foundation
import Alamofire

struct WordPack {
	var topic: String
	var rhymes: [String]
	var notRhymes: [String]
	var allWords: [String]
	var rhymeDictionary: [String: Bool]
}

// MARK: TODO: Validate Word To Rhyme

class RhymeHelper {
	
	func createWordPack(completion: @escaping (WordPack) -> ()) {
		var topicWord = ""
		var rhymes = [String]()
		var notRhymes = [String]()
		var rhymeDictionary = [String: Bool]()
		
		self.fetchRandomTopicWord { (randomWord) in
			self.createRhymesFor(Topic: randomWord) { (validatedTopic, rhymesArray) in
				print("[SUCCESS] Successfully Validated A New Topic: \(validatedTopic)")
				topicWord = validatedTopic
				
				print("[SUCCESS] Successfully Fetched Rhyme Array: \(rhymesArray)")
				rhymes = rhymesArray
				
				self.fetchNotRhymes { (notRhymesArray) in
					print("[SUCCESS] Successfully Fetched Not Rhymes Array: \(notRhymesArray)")
					notRhymes = notRhymesArray
					
					let dict = self.createRhymeDictionary(rhymes: rhymes, notRhymes: notRhymes)
					
					print("[SUCCESS] Created Rhyme Dictionary. [INFO] \(dict)")
					rhymeDictionary = dict
					
					let allWords = Array(rhymeDictionary.keys)
					let pack = WordPack(topic: topicWord, rhymes: rhymes, notRhymes: notRhymes, allWords: allWords, rhymeDictionary: rhymeDictionary)
					
					print("[SUCCESS] Created Word Pack. [INFO] \(pack)")
					completion(pack)
				}
			}
		}
		
		/*
		// MARK: Step One
		// Generate A Random Word and Confirm That Word Contains At Least 5 Rhymes
		self.fetchValidatedTopic { (word) in
			print("[SUCCESS] Successfully Validated A New Word To Rhyme. [WORD] \(word)")
			wordToRhyme = word
			
			// MARK: Step Two
			// Fetch
			self.fetchRhymes(word: word) { (rhymesArray) in
				print("[SUCCESS] Successfully Fetched Array of Rhymes. [DATA] \(rhymesArray)")
				rhymes = rhymesArray
				
				self.fetchNotRhymes { (notRhymesArray) in
					print("[SUCCESS] Successfully Fetched Array of Not Rhymes. [DATA] \(notRhymesArray)")
					notRhymes = notRhymesArray
					
					self.createRhymeDictionary(rhymes: rhymes, notRhymes: notRhymes) { (dictionary) in
						print("[SUCCESS] Successfully Created Rhyme Dictionary.")
						rhymeDictionary = dictionary
						
						let wordPack = WordPack(wordToRhyme: wordToRhyme, rhymes: rhymes, notRhymes: notRhymes, rhymeDictionary: rhymeDictionary)
						completion(wordPack)
					}
				}
			}
		}
		*/
	}
	
	// MARK: Function To Return A Validated Topic Word and Its Rhymes
	/*
	func ValidateTopicAndReturnRhymes(completion: @escaping (String, [String]) -> ()) {
		AF.request("https://random-word-api.herokuapp.com/word?number=1", method: .get).validate().responseJSON { (JSONResponse) in
			switch JSONResponse.result {
			case .success(let json):
				guard let wordArray = json as? [String] else { print("[ERROR] Unable To Convert JSON Response Into String Array."); return }
				guard let word = wordArray.first else { print("[ERROR] Unable To Retrieve Topic Word From JSON Response."); return }
				self.fetchRhymes(word: word) { (rhymes) in
					if rhymes.count >= 5 {
						print("[SUCCESS] Successfully Found Rhymes For: \(word)")
						completion(word, rhymes)
					}
					else {
						print("[WARNING] No Rhymes Found For: \(word). Trying Again.")
						self.ValidateTopicAndReturnRhymes { (validatedWord, rhymes) in completion(validatedWord, rhymes) }
					}
				}
			case .failure(let error):
				print("[ERROR] Unable To Fetch Random Words From API. [MESSAGE] \(error.localizedDescription)")
				return
			}
		}
	}
*/
	
	private func fetchRandomTopicWord(completion: @escaping (String) -> ()) {
		AF.request("https://random-word-api.herokuapp.com/word?number=1", method: .get).validate().responseJSON { (JSONResponse) in
			switch JSONResponse.result {
			case .success(let json):
				guard let wordArray = json as? [String] else { print("[ERROR] Unable To Convert JSON Response Into String Array."); return }
				guard let word = wordArray.first else { print("[ERROR] Unable To Retrieve Topic Word From JSON Response."); return }
				completion(word)
			case .failure(let error):
				print("[ERROR] Unable To Fetch Random Words From API. [MESSAGE] \(error.localizedDescription)")
				return
			}
		}
	}
	
	private func createRhymesFor(Topic: String, completion: @escaping (String, [String]) -> ()) {
		self.fetchRhymes(word: Topic) { (rhymesArray) in
			if rhymesArray.count >= 5 {
				print("[SUCCESS] Successfully Validated New Topic Word: \(Topic)")
				let shuffledArray = rhymesArray.shuffled()
				let shortenedArray = Array(shuffledArray[0...4])
				completion(Topic, shortenedArray)
			}
			else {
				print("[WARNING] Invalid Rhyme Count For Topic: \(Topic)")
				print("[INFO] Generating New Topic Word.")
				
				self.fetchRandomTopicWord { (newTopic) in
					self.createRhymesFor(Topic: newTopic) { (newTopic, rhymesArray) in
						completion(newTopic, rhymesArray)
					}
				}
			}
		}
	}
	
	private func fetchRhymes(word: String, completion: @escaping ([String]) -> ()) {
		let urlString = "https://api.datamuse.com/words?rel_rhy=" + word
		AF.request(urlString, method: .get).validate().responseJSON { (JSONResponse) in
			switch JSONResponse.result {
			case .success(let json):
				guard let data = json as? [[String: Any]] else { print("[ERROR] Unable To Convert JSON Response Into [[String: Any]]."); return }
				var rhymes = [String]()
				for rhymeObject in data {
					if let rhymeWord = rhymeObject["word"] as? String {
						if rhymeWord.contains(" ") { print("[WARNING] Removing Multi-Word Rhyme") }
						else if rhymeWord.contains(word) { print("[WARNING] Removing Rhyme That Contains Original Word") }
						else { rhymes.append(rhymeWord) }
					}
				}
				
				completion(rhymes)
			case .failure(let error):
				print("[ERROR] Error Fetching Rhymes From API. [MESSAGE] \(error.localizedDescription)")
				
				return
			}
		}
	}
	
	func fetchNotRhymes(completion: @escaping ([String]) -> ()) {
		AF.request("https://random-word-api.herokuapp.com/word?number=20", method: .get).validate().responseJSON { (JSONResponse) in
			switch JSONResponse.result {
			case .success(let json):
				guard let array = json as? [String] else { print("[ERROR] Unable To Convert JSON Response Into String Array."); return }
				let shuffledArray = array.shuffled()
				let shortenedArray = Array(shuffledArray[0...4])
				completion(shortenedArray)
			case .failure(let error):
				print("[ERROR] Unable To Fetch Random Words From API. [MESSAGE] \(error.localizedDescription)")
				return
			}
		}
	}
	
	func createRhymeDictionary(rhymes: [String], notRhymes: [String]) -> [String: Bool] {
		var dict = [String: Bool]()
		
		for x in rhymes { dict.updateValue(true, forKey: x) }
		for y in notRhymes { dict.updateValue(false, forKey: y) }
        
        return dict
	}
}
