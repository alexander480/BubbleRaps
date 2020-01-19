//: A UIKit based Playground for presenting user interface

import Foundation
import PlaygroundSupport

// MARK: Create Word Pack

extension URL {
	func syncFetch() -> Data? {
		let semaphore = DispatchSemaphore(value: 0)
		var result: Data?
		
		let task = URLSession.shared.dataTask(with: self) {(data, response, error) in
			guard let data = data else { print("[ERROR] Could Not Fetch Data From API."); return }
			result = data
			semaphore.signal()
		}
		
		task.resume()
		semaphore.wait()
		
		return result
	}
}
extension Data {
	func parseFromJSON() -> [String] {
		var array = [String]()
		
		do {
			let json = try JSONSerialization.jsonObject(with: self, options: .mutableContainers) as! [[String: Any]]
			for result in json { if let rhymeWord = result["word"] as? String { array.append(rhymeWord) } }
		}
		catch { print("[ERROR] Could Not Parse JSON From Datamuse API.") }
		
		return array
	}
}

// MARK: Filter Vulgar Words

func fetchVulgarArray() -> [String]? {
	var words: [String]?
	
	if let url = Bundle.main.url(forResource: "vulgar", withExtension: ".txt") {
		do {
			let str = try String(contentsOf: url, encoding: String.Encoding.utf8)
			let arr = str.components(separatedBy: NSCharacterSet.newlines)
			words = arr
		}
		catch {
			print("[ERROR] Could Not Convert vulgar.txt Into String.")
		}
	}
	else {
		print("[ERROR] Could Not Find vulgar.txt File.")
	}
	
	return words
}

func clean(Array: [String]) -> [String] {
	// var arr = Array
	
	guard let vulgarArr = fetchVulgarArray() else { print("[ERROR] Could Not Fetch Vulgar Array."); return Array }
	let cleanedArr = Array.filter { !vulgarArr.contains($0); }
	let formattedArr = cleanedArr.filter { !$0.contains(" "); }

	return formattedArr
}

// MARK: Fetch Word Pack

func createWordPackFrom(Topic: String) -> [String] {
	let str = Topic.replacingOccurrences(of: " ", with: "+")
	var pack = [String]()
	
	guard let url = URL(string: "https://api.datamuse.com/words?ml=\(str)") else { print("[ERROR] Could Not Validate URL."); return pack }
	guard let data = url.syncFetch() else { print("[ERROR] Could Not Fetch Data From Datamuse API."); return pack }
	
	pack = data.parseFromJSON()
	pack = clean(Array: data.parseFromJSON())
	
	return pack
}

let pack = createWordPackFrom(Topic: "Cars")
print(pack)




/*

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

// MARK: Create Word Pack Function

func createWordPackFrom(topic: String, completion: @escaping ([String]) -> Void) {
	var pack = [String]()
	
	guard let url = URL(string: "https://api.datamuse.com/words?ml=\(replaceSpaces(str: topic))") else {
		print(error: nil, description: "Could Not Validate Datamuse URL.")
		completion(pack)
		return
	}
	
	URLSession.shared.dataTask(with: url) { (result) in
		switch result {
			case .success(let response, let data):
				print(response: response)
				do {
					let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [[String: Any]]
					for result in json { if let rhymeWord = result["word"] as? String { pack.append(rhymeWord) } }
					completion(pack)
				}
				catch {
					print(error: nil, description: "Could Not Parse JSON From Datamuse API.")
					completion(pack)
				}
				break
			case .failure(let error):
				print(error: error, description: "Error Fetching Words Related To Topic: \(topic)")
				completion(pack)
				break
		}
	}.resume()
}

createWordPackFrom(topic: "Football") { (pack) in
	if !pack.isEmpty {
		
	}
}



// MARK: Filter Out Any Vulgar Words

let standard = ["shine", "made", "trust", "grand", "shed", "dance", "shape", "vapor", "fight", "cold", "grapple", "unicorn", "automobile", "cigarette", "sunny", "extension", "amaze", "noise", "scent", "shave", "control", "human", "crown", "shuffle", "amazing", "rhyme", "grind", "chance", "grand"]
let fashion = ["supreme", "leather", "louis", "tailor", "style", "footwear", "brand", "lingerie", "swagger", "dolce", "timberlands", "clothes", "vogue", "designer", "couture", "vuitton", "armani", "menswear", "prada", "trend", "escada", "versace", "glamour", "gucci"]
let football = ["fullback","quarterback","pigskin","league","punter","tackle","kick","touchdown","rusher","championship","coach","collegiate","fans","pre-season","center","snapper","kickoff","player","season","champion","downfield","game","post-season","playoffs","SuperBowl","rings","Lombardi","patriots","packers","steelers","lions","cowboys","eagles","raiders","bears","giants","browns","seahawks","vikings","colts","chiefs","broncos","texans","bills","dolphins","saints","redskins","jets","cardinals","ravens","panthers","rams","chargers","falcons","buccaneers","titans","jaguars","bengals","stallions","Simpson","Crews","Brady","Kaepernick","Rodgers","Manning","TeBow","Hernandez","Favre","Jackson","Newton","Brees","Romo","Peterson","Bradshaw","Montana","Rice","Lewis","Fitzgerald","Luck"]

let packs = [standard, fashion, football]

func detectWordsToRemoveIn(wordPack: [String]) -> [String] {
	var wordsToRemove = [String]()
	
	for word in wordPack {
		var rhymes = [String]()
		let urlString = "https://api.datamuse.com/words?rel_rhy=" + word
		guard let url = URL(string: urlString) else { print("[ERROR] Could Not Validate URL"); wordsToRemove.append(word); continue }
		do {
			let json = try JSONSerialization.jsonObject(with: Data(contentsOf: url), options: .mutableContainers) as! [[String: Any]]
			for result in json {
				if let rhymeWord = result["word"] as? String {
					if !rhymeWord.contains(" ") && !rhymeWord.contains(word) { rhymes.append(rhymeWord) }
				}
			}
		}
		catch { print("[ERROR] Could Not Create JSON Object From URL"); wordsToRemove.append(word) }
		
		if rhymes.count < 10 { wordsToRemove.append(word) }
	}
	
	return wordsToRemove
}

func removeWordsWithoutRhymes(wordPack: [String], invalidWords: [String]) -> [String] {
	var validWordPack = wordPack

	for invalidWord in invalidWords {
		validWordPack.removeAll { $0 == invalidWord }
	}
	
	return validWordPack
}

var validStandard = standard
var validFashion = fashion
var validFootball = football

let invalidWordsForStandard = detectWordsToRemoveIn(wordPack: standard)
if invalidWordsForStandard.isEmpty == false {
	validStandard = removeWordsWithoutRhymes(wordPack: validStandard, invalidWords: invalidWordsForStandard)
}

let invalidWordsForFashion = detectWordsToRemoveIn(wordPack: fashion)
if invalidWordsForFashion.isEmpty == false {
	validFashion = removeWordsWithoutRhymes(wordPack: validFashion, invalidWords: invalidWordsForFashion)
}

let invalidWordsForFootball = detectWordsToRemoveIn(wordPack: football)
if invalidWordsForFootball.isEmpty == false {
	validFootball = removeWordsWithoutRhymes(wordPack: validFootball, invalidWords: invalidWordsForFootball)
}

print("[VALID] \(validStandard)")
print("[VALID] \(validFashion)")
print("[VALID] \(validFootball)")

*/










