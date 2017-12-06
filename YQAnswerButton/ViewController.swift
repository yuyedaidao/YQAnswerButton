//
//  ViewController.swift
//  YQRadioButton
//
//  Created by Wang on 2017/11/2.
//  Copyright © 2017年 Wang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let button = YQAnswerButton()
        button.text = "Hello, your sister"
        button.flagLabel = "C"
        button.sizeToFit()
        var frame  = button.frame
        frame.origin = CGPoint(x: 10, y: 80)
        frame.size = CGSize(width: 100, height: 30)
        button.frame = frame
        view.addSubview(button)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

