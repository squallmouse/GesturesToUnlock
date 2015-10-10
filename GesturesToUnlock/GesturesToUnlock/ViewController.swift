//
//  ViewController.swift
//  GesturesToUnlock
//
//  Created by 袁昊 on 15/10/9.
//  Copyright © 2015年 squallmouse. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let btnView = GesturesToUnlockView(frame: CGRectMake(0, 0, s_width, s_height));
        self.view.addSubview(btnView);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

