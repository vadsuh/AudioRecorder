//
//  RealmController.swift
//  AudioRecorder
//
//  Created by Вадим Суходольский on 10/04/2018.
//  Copyright © 2018 Вадим Суходольский. All rights reserved.
//

import Foundation
import RealmSwift

var mainRealm: Realm!

class RealmController {
        
    static func setup() {
        do {
            mainRealm = try Realm()
        } catch let error as NSError {
            assertionFailure("Realm loading error: \(error)")
        }
    }
    
    
}


