//
//  ViewController.swift
//  ASiC Midterm-Exam
//
//  Created by George Liu on 2018/9/14.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var searchBot: UIButton!
    @IBOutlet weak var searchTxF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func searchBot(_ sender: UIButton) {
    }
    
    
    func setView() {
       
        searchBot.layer.borderWidth = 1.0
        searchBot.layer.borderColor = UIColor.lightGray.cgColor
        searchBot.layer.cornerRadius = 4
        
    }
}

