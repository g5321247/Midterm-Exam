//
//  ViewController.swift
//  ASiC Midterm-Exam
//
//  Created by George Liu on 2018/9/14.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit
import AVFoundation

enum PlayType {
    
    case play
    case pause
    
}

class ViewController: UIViewController {

    @IBOutlet weak var searchBot: UIButton!
    @IBOutlet weak var searchTxF: UITextField!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var playBot: UIButton!
    @IBOutlet weak var backgroundLbl : UILabel!
    @IBOutlet weak var currentTimeLbl: UILabel!
    @IBOutlet weak var totalTimeLbl: UILabel!
    
    
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    
    var playType: PlayType = .play
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func searchBot(_ sender: UIButton) {
        
        guard  searchTxF.text != "" else {
            
            videoView.isHidden = true
            playType = .pause
            return
        }
        
        playVideo(address: searchTxF.text!)
        videoView.isHidden = false
        
    }
    
    func playVideo(address: String) {
        
        guard let url = URL(string: address) else {
            
            print("URL is invalid")
            return
            
        }
        
        player = AVPlayer(url: url)
        
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resize
        
//        guard let duartion =  player.currentItem?.duration as? String else {
//
//            print("no duration")
//            return
//        }
        
//        currentTimeLbl.text = duartion
        
        typeChanging()
        
        videoView.layer.addSublayer(playerLayer)
        playerLayer.frame = videoView.bounds

    }

    func setView() {
       
        searchBot.layer.borderWidth = 1.0
        searchBot.layer.borderColor = UIColor.lightGray.cgColor
        searchBot.layer.cornerRadius = 4
        
    }
    
    @IBAction func playBot(_ sender: UIButton) {
        
        typeChanging()
        player.currentItem?.duration
        
    }
    
    @IBAction func forwardPress(_ sender: UIButton) {
        
        guard let duartion = player.currentItem?.duration else {
            return
        }
        
        let currentTime = CMTimeGetSeconds(player.currentTime())
        let newTime = currentTime + 10
        
        if newTime < (CMTimeGetSeconds(duartion) - 10) {
            let time: CMTime = CMTimeMake(Int64(newTime * 1000), 1000)
            player.seek(to: time)
        }
    }
    
    @IBAction func backwardBot(_ sender: UIButton) {
        
        let currentTime = CMTimeGetSeconds(player.currentTime())
        var newTime = currentTime - 10
        
        if newTime < 0 {
            newTime = 0
        }
        
        let time: CMTime = CMTimeMake(Int64(newTime * 1000), 1000)
        player.seek(to: time)

    }
    
    
    func typeChanging() {
        
        switch playType {
            
        case .play:
            
            playBot.imageView?.image = #imageLiteral(resourceName: "btn_stop")
            backgroundLbl.isHidden = true
            
            player.play()
            playType = .pause
            
        case .pause:
            
            playBot.imageView?.image = #imageLiteral(resourceName: "btn_play")
            player.pause()
            playType = .play
            
        }

    }
    
}

