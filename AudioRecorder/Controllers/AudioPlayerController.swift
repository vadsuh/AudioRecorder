//
//  AudioPlayerController.swift
//  AudioRecorder
//
//  Created by Вадим Суходольский on 10/04/2018.
//  Copyright © 2018 Вадим Суходольский. All rights reserved.
//

import Foundation
import AVFoundation

class AudioPlayerController {
    
    var player: AVAudioPlayer?
    
    var isPlaying: Bool {
        return player?.isPlaying ?? false
    }
    
    func playSound(data: Data) {
        player?.numberOfLoops = 1
        player = try? AVAudioPlayer(data: data)
        player?.play()
    }
    
}
