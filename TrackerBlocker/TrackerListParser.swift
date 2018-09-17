//
//  TrackerListParser.swift
//  TrackerBlocker
//
//  Created by Nikolay Derkach on 9/17/18.
//  Copyright © 2018 Nikolay Derkach. All rights reserved.
//

import Alamofire

class TrackerListParser {

	typealias BlockerList = [[String: [String: String]]]

	// MARK: - Private

	private static func generateBlacklistJSON(from trackerList: [String]) -> BlockerList {
		var blacklist: BlockerList = []
		for tracker in trackerList {
			blacklist.append([
				"action": ["type": "block"],
				"trigger": ["url-filter": String(format: "https?://(www.)?%@.*", tracker)]
			])
		}

		return blacklist
	}

	// MARK: - Public

	static func fetchAndParseTrackerList(completion: @escaping (BlockerList) -> Void ) {
		var parsedLines: [String] = []

		// Fetch JSON file containing the list of trackers to block
		Alamofire.request(Constants.trackerListURL).responseData { response in
			if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
				let lines = utf8Text.components(separatedBy: .newlines)

				for line in lines {
					if line.starts(with: "#") || line.isEmpty {
						continue
					}

					if let domainName = line.components(separatedBy: .whitespaces).first {
						parsedLines.append(domainName)
					}
				}

				completion(TrackerListParser.generateBlacklistJSON(from: parsedLines))
			}
		}
	}
}
