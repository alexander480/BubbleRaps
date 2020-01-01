//: A UIKit based Playground for presenting user interface

import Foundation
import PlaygroundSupport

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










