//
//  AudioRecorderController.swift
//  AudioRecorder
//
//  Created by Вадим Суходольский on 09/04/2018.
//  Copyright © 2018 Вадим Суходольский. All rights reserved.
//

import Foundation
import AVFoundation

final class AudioRecorderController: NSObject, AVAudioRecorderDelegate {
    
    private var audioRecorder: AVAudioRecorder!
    private var recordingSession: AVAudioSession!
    private var timer: Timer?
    private var levelsHandler: ((Float)->Void)?
    private(set) var audioDuration: TimeInterval = 0
    private let settings = [
        AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
        AVSampleRateKey: 12000,
        AVNumberOfChannelsKey: 1,
        AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
    ]
    
    var isAudioFeaturesEnabled: Bool = false
    var finishRecordingHandler: ((AVAudioRecorder, Bool) -> ())?
    var audioURL: URL? {
        return audioRecorder.url
    }
    
    override init() {
        super.init()
        self.setupRecordingSession()
    }
    
    private func setupRecordingSession() {
        recordingSession = AVAudioSession.sharedInstance()
        if recordingSession.recordPermission() != .granted {
            recordingSession.requestRecordPermission { [weak self] allowed in
                self?.isAudioFeaturesEnabled = allowed
            }
        } else {
            isAudioFeaturesEnabled = true
        }
        
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
        } catch {
            print("Error when trying to initialize recording session")
        }
    }
    
    func startRecordingWith(levelsHandler: ((Float) -> Void)?) {
        let audioFileName = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        do {
            audioRecorder = try AVAudioRecorder(url: audioFileName, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.isMeteringEnabled = true
            self.levelsHandler = levelsHandler
            timer = Timer.scheduledTimer(timeInterval: 0.02,
                                         target: self, selector: #selector(self.handleMicLevel(_:)),
                                         userInfo: nil, repeats: true)
            audioRecorder.record()
        } catch {
            print("Error when trying to setup audioSession")
        }
    }
    
    func stopRecording() {
        levelsHandler = nil
        timer?.invalidate()
        audioDuration = audioRecorder.currentTime
        audioRecorder.stop()
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        finishRecordingHandler?(recorder, flag)
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    static func addToRealm(title: String, duration: Double, audioData: Data) {
        let audio = AudioEntity()
        let id = (mainRealm.objects(AudioEntity.self).max(ofProperty: "id") as Int? ?? 0) + 1
        audio.id = id
        audio.title = title
        audio.duration = duration
        audio.data = audioData
        
        realmWrite {
            mainRealm.add(audio)
        }
    }
    
    @objc private func handleMicLevel(_ timer: Timer) {
        audioRecorder.updateMeters()
        levelsHandler?(audioRecorder.averagePower(forChannel: 0))
    }
    
    deinit {
        stopRecording()
    }
    
}

