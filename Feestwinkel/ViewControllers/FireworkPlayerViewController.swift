//
//  FireworkPlayerViewController.swift
//  Feestwinkel
//
//  Created by Jeremie Van de Walle on 20/12/17.
//  Copyright © 2017 Jeremie Van de Walle. All rights reserved.
//

import AVFoundation
import AVKit

class FireworkPlayerViewController : AVPlayerViewController {
    
    var code : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let videoURL = URL(fileURLWithPath: Bundle.main.path(forResource: code!, ofType: "mp4")!)
        let player = AVPlayer(url: videoURL)
        self.player = player
        self.player!.play()
    }
    

}
