//
//  ImageRecord+CoreDataProperties.swift
//  EstateApp
//
//  Created by Chunpo Chan on 2020/12/10.
//  Copyright © 2020 ChunPo Chan. All rights reserved.
//
//

import Foundation
import CoreData


extension ImageRecord {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageRecord> {
        return NSFetchRequest<ImageRecord>(entityName: "ImageRecord")
    }

    @NSManaged public var url: String?
    @NSManaged public var image_base64: String?

}
