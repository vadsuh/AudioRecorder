//
//  AudioRecordCell.swift
//  AudioRecorder
//
//  Created by Вадим Суходольский on 10/04/2018.
//  Copyright © 2018 Вадим Суходольский. All rights reserved.
//

import UIKit

class AudioRecordCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var randomPhotoImageView: UIImageView! {
        didSet {
            randomPhotoImageView.layer.cornerRadius = 49
            randomPhotoImageView.layer.masksToBounds = true
        }
    }
    
    var imageURL = URL(string: "https://picsum.photos/200/300/?random")!
    
    var audioRecord: AudioEntity? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        let audioDuration = String(format: "%.3f", (audioRecord?.duration ?? 0))
        titleLabel.text = audioRecord?.title
        durationLabel.text = "\(audioDuration) seconds"
       
        let task = URLSession.shared.dataTask(with: imageURL) { [weak self] data, _, _ in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.randomPhotoImageView.image = image
                }
            }
        }
        
        task.resume()
    }
    
    
}
