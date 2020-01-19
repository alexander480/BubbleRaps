//
//  Rhyming.swift
//  RhymingBubbles
//
//  Created by Delta Vel on 6/26/19.
//  Copyright © 2019 Delta Vel. All rights reserved.
//

import Foundation

class RhymeHelper {
    var word: String
    var howMany: Int
    
    init(word: String, howMany: Int) {
        self.word = word
        self.howMany = howMany
        
        print("[INFO] Initialized RhymeHelper For \(word)")
    }
	
	func rhymes() -> [String] {
		var rhymes = [String]()
		let urlString = "https://api.datamuse.com/words?rel_rhy=" + self.word
		guard let url = URL(string: urlString) else { print("[ERROR] Could Not Validate URL"); return [String]() }
		do {
			let json = try JSONSerialization.jsonObject(with: Data(contentsOf: url), options: .mutableContainers) as! [[String: Any]]
			for result in json {
				if let rhymeWord = result["word"] as? String {
					if rhymeWord.contains(" ") { print("[WARNING] Removing Multi-Word Rhyme") }
					else if rhymeWord.contains(self.word) { print("[WARNING] Removing Rhyme That Contains Original Word") }
					else { rhymes.append(rhymeWord) }
				}
			}
		}
		catch { print("[ERROR] Could Not Create JSON Object From URL");  return [String]() }
		
		// print("[INFO] All Rhymes For \(word): \(rhymes)")
		
		let randomizedArray = Array(rhymes.shuffled().prefix(through: (howMany/2) - 1))
		print("[INFO] Five Rhymes For \(word): \(randomizedArray)")
		
		return randomizedArray
	}
	
	// MARK: Needs Work (Make Synchronous)
	
	func getRandomWord(completion: @escaping (String) -> ()) {
		let url = URL(string: "https://wordsapiv1.p.rapidapi.com/words/?random=true")!
		var request = URLRequest(url: url)
		request.addValue("wordsapiv1.p.rapidapi.com", forHTTPHeaderField: "x-rapidapi-host")
		request.addValue("764084a202msh2f0775947fe53c3p1c195djsn6daa3abe9336", forHTTPHeaderField: "x-rapidapi-key")
		
		let urlTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
			if let data = data {
				do {
					if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
						if let randomWord = json["word"] as? String {
							completion(randomWord)
						}
					}
				}
				catch {
					print("[ERROR] Could Not Parse JSON Data From WordsAPI")
				}
			}
		}
		
		urlTask.resume()
	}

    func notRhymes() -> [String] {
        
		// TODO: Grab the rhymes from another word
        
        var doesNotRhyme = [String]()
        
        let string = "relaxation cupboard trust call fling sale iron established ton ethics digital clash cunning opera iron exile senior award tile where random thoughts come from mum tries cool saying that she likes all same things rhymes another negative negate craft short split suffix prefix nothing string potential array variable skin hair store reciepes spoon mixture sister brother banana republic"
        
        let stringArray = string.split(separator: " ")
        let rhymeWordSuffix = word.suffix(2)
        
        for word in stringArray {
            let randomWordSuffix = word.suffix(2)
            if rhymeWordSuffix != randomWordSuffix { doesNotRhyme.append(String(word)) }
            else { print("[INFO] Removed '\(word)' From notRhymes Array") }
        }
		
		var notRhymesArray = [String]()
        let buffer = stringArray.shuffled().prefix(howMany/2)
		for notRhyme in buffer { notRhymesArray.append(String(notRhyme)) }
		
        print("[INFO] Five Random Words For \(word): \(notRhymesArray)")
        
        return notRhymesArray
    }
    
	func potentialRhymes() -> [String: Bool] {
        var potentialArray = [String: Bool]()
        
        for x in self.rhymes() { potentialArray.updateValue(true, forKey: x) }
        for y in self.notRhymes() { potentialArray.updateValue(false, forKey: y) }
        
        print("[INFO] Potential Rhymes Array: \(potentialArray)")
        
        return potentialArray
    }
	
	/*
	func createWordPackFrom(topic: String, completion: @escaping ([String]?) -> Void) {
		guard let url = URL(string: "https://api.datamuse.com/words?ml=\(topic.urlFormat())") else { return }
		URLSession.shared.dataTask(with: url) { (result) in
			switch result {
				case .success(let response, let data):
					print(response.description)
					break
				case .failure(let error):
					// Handle Error
					break
			 }
		}
	}
	*/
}

extension URLSession {
    func dataTask(with url: URL, result: @escaping (Result<(URLResponse, Data), Error>) -> Void) -> URLSessionDataTask {
		return dataTask(with: url) { (data, response, error) in
			if let error = error {
				result(.failure(error))
				return
			}
			guard let response = response, let data = data else {
				let error = NSError(domain: "error", code: 0, userInfo: nil)
				result(.failure(error))
				return
			}
			result(.success((response, data)))
		}
	}
}
