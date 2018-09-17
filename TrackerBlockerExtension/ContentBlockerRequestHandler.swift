//
//  ContentBlockerRequestHandler.swift
//  TrackerBlockerExtension
//
//  Created by Nikolay Derkach on 9/17/18.
//  Copyright © 2018 Nikolay Derkach. All rights reserved.
//

import UIKit

class ContentBlockerRequestHandler: NSObject, NSExtensionRequestHandling {

    func beginRequest(with context: NSExtensionContext) {
//        let attachment = NSItemProvider(contentsOf: Bundle.main.url(forResource: "blockerList", withExtension: "json"))!

		let documentFolder = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.trackerblocker")

		guard let jsonURL = documentFolder?.appendingPathComponent(Constants.blockerListFilename) else {
			return
		}

		print(jsonURL)

		let attachment = NSItemProvider(contentsOf: jsonURL)

        let item = NSExtensionItem()
        item.attachments = [attachment]
        
        context.completeRequest(returningItems: [item], completionHandler: nil)
    }
    
}
