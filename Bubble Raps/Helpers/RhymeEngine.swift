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

struct RhymeEngine {
	
	func fetchRhymesFor(_ topic: String, rhymeType: RhymeType = .perfect, completion: @escaping ([Rhyme]) -> ()) {
		let param = "?\(rhymeType.rawValue)=\(topic)"
		AF.request("https://api.datamuse.com/words\(param)", method: .get).validate().responseDecodable(of: [Rhyme].self) { response in
			print(response)
		}
	}
}
