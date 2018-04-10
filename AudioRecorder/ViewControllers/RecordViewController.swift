//
//  ViewController.swift
//  AudioRecorder
//
//  Created by Вадим Суходольский on 09/04/2018.
//  Copyright © 2018 Вадим Суходольский. All rights reserved.
//

import UIKit

final class RecordViewController: UIViewController {
    
    var audioRecorderController: AudioRecorderController!
    var microphoneActivityIndicatorView = MicrophoneActivityIndicatorView()
    var recordAudioButton = RecordAudioButton()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        setupAudioRecorderController()
        recordAudioButton.addTarget(self, action: #selector(recordAudioButtonTapped(_:)), for: .touchUpInside)
    }

    private func setupAudioRecorderController() {
        audioRecorderController = AudioRecorderController()
        audioRecorderController.finishRecordingHandler = { [weak self] recorder, isSuccessfully in
            //Handle case when recording was canceled
            if isSuccessfully != true {
                self?.audioRecorderController.stopRecording()
            }
        }
    }
    
    @objc func recordAudioButtonTapped(_ sender: RecordAudioButton) {
        sender.isSelected ? startRecording() : stopRecording()
    }
    
    func startRecording() {
        if audioRecorderController.isAudioFeaturesEnabled {
            microphoneActivityIndicatorView.starAnimating()
            audioRecorderController.startRecordingWith { [weak self] level in
                self?.microphoneActivityIndicatorView.react(to: level)
            }
        }
    }
    
    func stopRecording() {
        microphoneActivityIndicatorView.stopAnimating()
        audioRecorderController.stopRecording()
        guard let audioURL = audioRecorderController.audioURL,
            let audioData = try? Data(contentsOf: audioURL) else {
                return
        }
        
        saveRecord(duration: audioRecorderController.audioDuration, audioData: audioData)
    }
    
    func saveRecord(duration: Double, audioData: Data) {
        let alert = UIAlertController(title: "Save audio",
                                      message: "Enter name", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] _ in
            guard let textfield = alert.textFields?.first, var nameToSave = textfield.text else {
                return
            }
            if nameToSave.isEmpty {
                nameToSave = "Default name"
            }
            
            AudioRecorderController.addToRealm(title: nameToSave,
                                               duration: self.audioRecorderController.audioDuration,
                                               audioData: audioData)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    

    

    
    private func setupConstraints() {
        //microphoneActivityIndicatorView
        view.addSubview(microphoneActivityIndicatorView)
        microphoneActivityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11, *) {
            microphoneActivityIndicatorView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            microphoneActivityIndicatorView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
            microphoneActivityIndicatorView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        } else {
            microphoneActivityIndicatorView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            microphoneActivityIndicatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            microphoneActivityIndicatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        }
        //recordingButton
        view.addSubview(recordAudioButton)
        recordAudioButton.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11, *) {
            recordAudioButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40).isActive = true
        } else {
            recordAudioButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        }
        recordAudioButton.topAnchor.constraint(equalTo: microphoneActivityIndicatorView.bottomAnchor, constant: 40).isActive = true
        recordAudioButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    


}

