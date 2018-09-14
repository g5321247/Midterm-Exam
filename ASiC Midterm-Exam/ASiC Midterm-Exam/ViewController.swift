//
//  ViewController.swift
//  ASiC Midterm-Exam
//
//  Created by George Liu on 2018/9/14.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var searchBot: UIButton!
    @IBOutlet weak var searchTxF: UITextField!

    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    
    @IBOutlet weak var videoView: UIView!
    
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
            return
        }
        
        playVideo(address: searchTxF.text!)
        playerLayer.frame = videoView.bounds
        videoView.isHidden = false
        player.play()
        
    }
    
    func playVideo(address: String) {
        
        guard let url = URL(string: address) else {
            
            print("URL is invalid")
            return
            
        }
        
        player = AVPlayer(url: url)
        
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resize
        
        videoView.layer.addSublayer(playerLayer)
    }

    func setView() {
       
        searchBot.layer.borderWidth = 1.0
        searchBot.layer.borderColor = UIColor.lightGray.cgColor
        searchBot.layer.cornerRadius = 4
        
    }
}

