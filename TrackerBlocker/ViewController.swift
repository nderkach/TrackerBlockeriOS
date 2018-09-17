//
//  ViewController.swift
//  TrackerBlocker
//
//  Created by Nikolay Derkach on 9/17/18.
//  Copyright © 2018 Nikolay Derkach. All rights reserved.
//

import UIKit
import SafariServices

class ViewController: UIViewController {
	override func viewDidLoad() {
		super.viewDidLoad()

		TrackerListParser.fetchAndParseTrackerList() { trackers in
			guard let jsonData = try? JSONSerialization.data(withJSONObject: trackers, options: .prettyPrinted) else {
				return
			}

			let documentFolder = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.trackerblocker")

			guard let jsonURL = documentFolder?.appendingPathComponent(Constants.blockerListFilename) else {
				return
			}

			do {
				try jsonData.write(to: jsonURL)
			} catch {
				print("error")
			}

			SFContentBlockerManager.reloadContentBlocker(withIdentifier: "ch.derka.TrackerBlocker.TrackerBlockerExtension", completionHandler: { error in
				print(error)
			})
		}
	}
}
