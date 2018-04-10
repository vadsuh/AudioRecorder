//
//  Realm + realmWrite.swift
//  AudioRecorder
//
//  Created by Вадим Суходольский on 10/04/2018.
//  Copyright © 2018 Вадим Суходольский. All rights reserved.
//

import Foundation
import RealmSwift

extension Realm {
    public func realmWrite(_ block: (() -> Void)) {
        if isInWriteTransaction {
            block()
        } else {
            do {
                try write(block)
            } catch {
                assertionFailure("Realm write error: \(error)")
            }
        }
    }
}

func realmWrite(realm: Realm = mainRealm, _ block: (() -> Void)) {
    realm.realmWrite(block)
}
