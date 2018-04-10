//
//  AudioModel .swift
//  AudioRecorder
//
//  Created by Вадим Суходольский on 10/04/2018.
//  Copyright © 2018 Вадим Суходольский. All rights reserved.
//

import Foundation
import RealmSwift

final class AudioEntity: Object {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var title: String = ""
    @objc dynamic var duration: Double = 0
    @objc dynamic var data: Data = Data()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
