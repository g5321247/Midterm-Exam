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
        playerLayer.frame = videoView.bounds
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
        
        typeChanging()
        
        videoView.layer.addSublayer(playerLayer)
    }

    func setView() {
       
        searchBot.layer.borderWidth = 1.0
        searchBot.layer.borderColor = UIColor.lightGray.cgColor
        searchBot.layer.cornerRadius = 4
        
    }
    
    @IBAction func playBot(_ sender: UIButton) {
        
        typeChanging()
        
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

