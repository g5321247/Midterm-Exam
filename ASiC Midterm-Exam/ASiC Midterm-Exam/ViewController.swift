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
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var playBot: UIButton!
    @IBOutlet weak var backgroundLbl : UILabel!
    @IBOutlet weak var currentTimeLbl: UILabel!
    @IBOutlet weak var totalTimeLbl: UILabel!
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var soundBot: UIButton!
    
    @IBOutlet weak var fullSzieBot: UIButton!
    @IBOutlet weak var forwardBot: UIButton!
    @IBOutlet weak var backBot: UIButton!
    @IBOutlet weak var sizeConstrait: NSLayoutConstraint!
    
    var isTaping: Bool = false
    var isRoating: Bool = false
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setView()
        rotateView()

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override var shouldAutorotate: Bool {
        return true
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        super.viewWillTransition(to: size, with: coordinator)
        rotateView()
        
        coordinator.animate(alongsideTransition: { (context) in
        }) { (context) in
            
            guard self.playerLayer != nil else { return }
            self.playerLayer.frame.size = self.videoView.bounds.size
        }
    }

    func rotateView() {
        
        if UIDevice.current.orientation.isLandscape {
            
            UIApplication.shared.isStatusBarHidden = true
            navigationController?.isNavigationBarHidden = true
            searchBot.isHidden = true
            searchTxF.isHidden = true
            
            // 無法使用
            
//            #imageLiteral(resourceName: "btn_volume_off").withRenderingMode(.alwaysTemplate)
//            #imageLiteral(resourceName: "btn_play_rewind").withRenderingMode(.alwaysTemplate)
//            #imageLiteral(resourceName: "btn_play").withRenderingMode(.alwaysTemplate)
//            #imageLiteral(resourceName: "btn_fullScreen_exit").withRenderingMode(.alwaysTemplate)
//            #imageLiteral(resourceName: "btn_stop").withRenderingMode(.alwaysTemplate)
//            #imageLiteral(resourceName: "btn_volume_up").withRenderingMode(.alwaysTemplate)
//            #imageLiteral(resourceName: "btn_fullScreen").withRenderingMode(.alwaysTemplate)
//            #imageLiteral(resourceName: "btn_play_forward").withRenderingMode(.alwaysTemplate)
        
            playBot.tintColor = UIColor.white
            soundBot.tintColor = UIColor.white
            backBot.tintColor = UIColor.white
            forwardBot.tintColor = UIColor.white
            fullSzieBot.tintColor = UIColor.white
            currentTimeLbl.textColor = UIColor.white
            totalTimeLbl.textColor = UIColor.white
            
            videoView.isHidden = false
            
            let tap = UITapGestureRecognizer(target: self, action: #selector (handleTap(sender:)))
            
            tap.delegate = self as? UIGestureRecognizerDelegate
            videoView.addGestureRecognizer(tap)
            
        } else {
            
            
            UIApplication.shared.isStatusBarHidden = false
            navigationController?.isNavigationBarHidden = false
            searchBot.isHidden = false
            searchTxF.isHidden = false
            
            playBot.tintColor = UIColor.black
            soundBot.tintColor = UIColor.black
            backBot.tintColor = UIColor.black
            forwardBot.tintColor = UIColor.black
            fullSzieBot.tintColor = UIColor.black
            currentTimeLbl.textColor = UIColor.black
            totalTimeLbl.textColor = UIColor.black
            
            videoView.isHidden = true

        }

        
    }
    
    @IBAction func searchBot(_ sender: UIButton) {
        
        guard  searchTxF.text != "" else {
            
            return
        }
        
        playVideo(address: searchTxF.text!)
        
    }
    
    func addTimeObserver() {
        
        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        
        player.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main) {[weak self] (time) in
            
            guard let currentItem = self?.player.currentItem else { return }
            
            self?.timeSlider.maximumValue = Float(currentItem.duration.seconds)
            self?.timeSlider.minimumValue = 0
            self?.timeSlider.value = Float(currentItem.currentTime().seconds)
            
            self?.currentTimeLbl.text = self?.getTimeString(time: currentItem.currentTime())
        }
        
    }
    
    func playVideo(address: String) {
        
        guard let url = URL(string: address) else {
            
            print("URL is invalid")
            return
            
        }
        
        let playerItem = AVPlayerItem.init(url: url)
        
        player = AVPlayer(playerItem: playerItem)
       
        addTimeObserver()
        
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resize
        
        player.currentItem?.addObserver(self, forKeyPath: "duration", options: [.new, .initial], context: nil)
        
        player.currentItem?.addObserver(self, forKeyPath: "duration", options: [.new, .initial], context: nil)
        
        videoView.backgroundColor = UIColor(displayP3Red: 0/255, green: 0/255, blue: 0/255, alpha: 1)

        player.play()
        
        playBot.isSelected = true
        

        videoView.layer.addSublayer(playerLayer)
        playerLayer.frame = videoView.bounds

    }

    func setView() {
       
        searchBot.layer.borderWidth = 1.0
        searchBot.layer.borderColor = UIColor.lightGray.cgColor
        searchBot.layer.cornerRadius = 4
        
    }
    
    @IBAction func playBot(_ sender: UIButton) {
        
        guard player != nil else {
            return
        }
        
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            
            player.play()
            
        } else {
            
            player.pause()
            
        }
        

    }
    
    @IBAction func forwardPress(_ sender: UIButton) {
        
        guard player != nil else {
            return
        }
        
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
        
        guard player != nil else {
            return
        }
        
        let currentTime = CMTimeGetSeconds(player.currentTime())
        var newTime = currentTime - 10
        
        if newTime < 0 {
            newTime = 0
        }
        
        let time: CMTime = CMTimeMake(Int64(newTime * 1000), 1000)
        player.seek(to: time)

    }
    
    @IBAction func timeSlider(_ sender: UISlider) {
        
        guard player != nil else {
            return
        }
        
        player.seek(to: CMTimeMake(Int64(sender.value * 1000), 1000))
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "duration", let duration = player.currentItem?.duration.seconds, duration > 0.0 {
            
            totalTimeLbl.text = getTimeString(time: player.currentItem!.duration)
            
        }
    }
    
    func getTimeString(time: CMTime) -> String {
        
        let totalSecond = CMTimeGetSeconds(time)
        
        let hours = Int(totalSecond / 3600)
        let mins = Int(totalSecond / 60) % 60
        let seconds = Int(totalSecond.truncatingRemainder(dividingBy: 60))
        
        if hours > 0 {
            
            return String(format: "%i:%02i:%02i:", hours,mins,seconds)
            
        } else {
            
            return String(format: "%02i:%02i", mins,seconds)
            
        }
    }
    
    @IBAction func soundBot(_ sender: UIButton) {
        
        guard player != nil else {
            return
        }
        
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            
            player.isMuted = true
            
        } else {
            
            player.isMuted = false
            
        }
        
    }
    
    @IBAction func fullSize(_ sender: UIButton) {
        
        isRoating = !isRoating
        
        
        if isRoating {
            
            let value = UIInterfaceOrientation.landscapeLeft.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")

            
        } else {
            
            let value = UIInterfaceOrientation.portrait.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")

        }
        
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer? = nil) {
        
        isTaping = !isTaping
        
        playBot.isHidden = isTaping
        soundBot.isHidden = isTaping
        backBot.isHidden = isTaping
        forwardBot.isHidden = isTaping
        fullSzieBot.isHidden = isTaping
        totalTimeLbl.isHidden = isTaping
        currentTimeLbl.isHidden = isTaping
        timeSlider.isHidden = isTaping
        
    }
    
}

