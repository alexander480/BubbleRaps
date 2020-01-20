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

func validateWord(Pack: [String]) -> [String] {
	var validatedArr = [String]()
	for word in Pack {
		if canFindRhymesFor(Topic: word) { validatedArr.append(word) }
		else { print("[WARNING] Could Not Find Enough Rhymes For \(word).") }
	}
	return validatedArr
}

func canFindRhymesFor(Topic: String) -> Bool { if rhymesFor(Topic: Topic).count >= 5 { return true } else { return false } }
func rhymesFor(Topic: String) -> [String] {
	var rhymes = [String]()
	let urlString = "https://api.datamuse.com/words?rel_rhy=" + Topic
	guard let url = URL(string: urlString) else { print("[ERROR] Could Not Validate URL"); return [String]() }
	do {
		let json = try JSONSerialization.jsonObject(with: Data(contentsOf: url), options: .mutableContainers) as! [[String: Any]]
		for result in json {
			if let rhymeWord = result["word"] as? String {
				if rhymeWord.contains(" ") { /* print("[WARNING] Removing Multi-Word Rhyme") */ }
				else if rhymeWord.contains(Topic) { /* print("[WARNING] Removing Rhyme That Contains Original Word") */ }
				else { rhymes.append(rhymeWord) }
			}
		}
	}
	catch { print("[ERROR] Could Not Create JSON Object From URL"); return [String]() }
	
	return rhymes
}

// MARK: Fetch Word Pack

func createWordPackFrom(Topic: String) -> [String] {
	let str = Topic.replacingOccurrences(of: " ", with: "+")
	
	guard let url = URL(string: "https://api.datamuse.com/words?ml=\(str)") else { print("[ERROR] Could Not Validate URL."); return [String]() }
	guard let data = url.syncFetch() else { print("[ERROR] Could Not Fetch Data From Datamuse API."); return [String]() }
	
	let cleanedPack = clean(Array: data.parseFromJSON())
	let validatedPack = validateWord(Pack: cleanedPack)
	
	return validatedPack
}

// let pack = createWordPackFrom(Topic: "movies")
// print(pack)

let validated = validateWord(Pack: ["shine", "made", "trust", "grand", "shed", "dance", "shape", "vapor", "fight", "cold", "grapple", "unicorn", "automobile", "cigarette", "sunny", "extension", "amaze", "focus", "noise", "scent", "shave", "control", "human", "crown", "shuffle", "amazing", "rhyme", "grind", "chance", "grand"])

print(validated)


