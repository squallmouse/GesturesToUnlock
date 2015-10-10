//
//  GesturesToUnlockView.swift
//  GesturesToUnlock
//
//  Created by 袁昊 on 15/10/9.
//  Copyright © 2015年 squallmouse. All rights reserved.
//

import UIKit

let s_width = UIScreen.mainScreen().bounds.size.width;
let s_height = UIScreen.mainScreen().bounds.size.height;

class GesturesToUnlockView: UIView {
    let backgroundImageStr = "zzf_password_bg";
//    未选中的图片名
    let normalChoosePicName = "zzf_password_btn_normal";
//    选中的图片名
    let clickChoosePicName = "zzf_password_btn_click";
//  按钮行列数
    let btnNum : Int = 3;
//    存多少个密码
    let secretCodeNum = 4;
//    存密码的数组
    var secretArray:NSMutableArray!;
    
    
//    ////////////////////////////
    var pointValue : NSValue!;
    var dotView : NSMutableArray!;
 
//    初始化
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.putBtnsOnTheView();
        self.backgroundColor = UIColor.clearColor();
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
//    按钮摆放
    func putBtnsOnTheView(){
        let btnWidth = CGFloat(70);
        let xline : CGFloat = CGFloat((s_width-20)/CGFloat(btnNum*2));
        let normalImage = UIImage(named: normalChoosePicName);
        let clickImage = UIImage(named: clickChoosePicName);
        
        for(var i = 0; i < btnNum ; i++){
            for(var j = 0; j < btnNum;j++){
                let pic = UIImageView(image: normalImage, highlightedImage: clickImage);
                pic.frame = CGRectMake(0, 0, btnWidth, btnWidth);
                pic.center = CGPointMake((10+xline*CGFloat(2*j+1)),s_height/3+10+xline*CGFloat(2*i+1));
                pic.userInteractionEnabled = true;
                self.addSubview(pic);
                pic.tag = 5001+i*btnNum+j;
            }
        }
    }
    
//    MARK:2- 点击事件
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if(secretArray == nil){
//            初始化
            secretArray = NSMutableArray(capacity: secretCodeNum);
        }
    }
    
    
//  5
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
    }
    
    
//   2
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        当前手指按到的坐标
        let pt = (touches as NSSet).anyObject()?.locationInView(self);
//        判断此时手指碰到了那个View
        let touchView = self.hitTest(pt!, withEvent: event);
        pointValue = NSValue.init(CGPoint: pt!);
//        绘图
        self.setNeedsDisplay();
        
        if(touchView?.tag > 5000 && touchView?.tag <= 5000+(btnNum*btnNum)){
            var found = false;
            
            if(secretArray.count > 0){
                for temp in secretArray{
//                    判断是不是重复点击了View
                   found = (temp.integerValue == touchView?.tag)
                    if(found){
                        break;
                    }
                }
            }
        }
//        
//        if()
        
    }
    
}
