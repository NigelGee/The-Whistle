//
//  Helper.swift
//  The Whistle
//
//  Created by Nigel Gee on 19/04/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import Foundation

class Helper {
    class func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    class func getWhistleURL() -> URL {
        return getDocumentsDirectory().appendingPathComponent("whistle.m4a")
    }
}
