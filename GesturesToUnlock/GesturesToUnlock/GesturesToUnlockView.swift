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
    var shapepath : CAShapeLayer!;
    var backView : UIView!;
    
//    初始化
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        self.backgroundColor = UIColor.clearColor();
        self.layer.contents = UIImage(named: backgroundImageStr)?.CGImage;
//        用第一种画线方法时不需要这个backView
        backView = UIView(frame: frame);
        self.addSubview(backView);
        
        self.putBtnsOnTheView();
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
        
        self.clearDotViews();
        for temp in self.subviews{
            if(temp is UIImageView){
                let tempImageView = temp as! UIImageView;
                tempImageView.highlighted = false;
            }
        }
//        画图
//        self.setNeedsDisplay();
        self.attachment();
    }
    
    
//   2
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        当前手指按到的坐标
        let pt = (touches as NSSet).anyObject()?.locationInView(self);
//        判断此时手指碰到了那个View
        let touchView = self.hitTest(pt!, withEvent: event);
        pointValue = NSValue.init(CGPoint: pt!);
//        绘图
//        self.setNeedsDisplay(); //第一种方法
        self.attachment();//第2种方法
//      判断是否是9个按钮之一
        if(touchView?.tag > 5000 && touchView?.tag <= 5000+(btnNum*btnNum)){
            var found = false;
            
            if(secretArray.count > 0){
                for temp in secretArray{
//                    判断是不是重复点击了已有的View
                   found = (temp.integerValue == touchView?.tag)
                    if(found){
                        break;
                    }
                }
            }
//            重复点击就返回
            if(found){
                return;
            }
//            
            secretArray.addObject(NSNumber(int: Int32((touchView?.tag)!)));
            self.addDotView(touchView!);
            let tempImageView = touchView as! UIImageView;
            tempImageView.highlighted = true;
            
        }
//          思路：手指在屏幕上面划过，判断这时候手指的有没有按在设置的9个按钮上。如果碰到了9个按钮中得一个，那么从数组中取出已经点击过的按钮，根据tag值判断是不是重复点击了。如果是重复点击的，那么久返回；如果是没有点击过的按钮，那么就把就把tag值存在数组里，并且高亮按钮。
    }
    
//    连线画图
    func attachment(){
        if (pointValue == nil){
            return;
        }
        if(dotView == nil){
            return;
        }
        let bezierPath = UIBezierPath();
        var lastDot : UIView!;
        var from : CGPoint!;
        
        for temp in dotView{
            from = temp.center;
            if (lastDot == nil){
                bezierPath.moveToPoint(from);
            }else{
                bezierPath.addLineToPoint(from);
            }
            lastDot = temp as! UIView;
        }
        
        let pt = pointValue.CGPointValue();
        bezierPath.addLineToPoint(pt);
        if(shapepath == nil){
            shapepath = CAShapeLayer();
        }
        shapepath.strokeColor = UIColor.redColor().CGColor;
        shapepath.fillColor = UIColor.clearColor().CGColor;
        shapepath.lineWidth = 5;
        shapepath.path = bezierPath.CGPath;

        backView.layer.addSublayer(shapepath);
        backView.layer.zPosition = -1;
    }
    
    override func drawRect(rect: CGRect) {
        if(pointValue == nil){
            return;
        }
        let context = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(context, UIColor.yellowColor().CGColor);
        CGContextSetLineWidth(context, 4);
        var lastDot:UIView!;
        var from:CGPoint!;
        if (dotView == nil){
            return;
        }
        for temp in dotView
        {
            from  = (temp as? UIImageView)!.center;
            if (lastDot == nil){
                CGContextMoveToPoint(context, from.x, from.y)
            }else{
                CGContextAddLineToPoint(context, from.x, from.y);
            }
            lastDot = temp as! UIView;
        }
        let pt = pointValue.CGPointValue();
        CGContextAddLineToPoint(context, pt.x, pt.y);
        CGContextStrokePath(context);
        pointValue = nil;
        
    }
    
//    添加按过的点到数组中存起来
    func addDotView(dotview:UIView){
        if(dotView == nil){
            dotView = NSMutableArray(capacity: 0);
        }
        dotView.addObject(dotview);
//        密码判断 do something
        
    }
    
//    大扫除
    func clearDotViews(){
        if(dotView == nil){
            return;
        }
        dotView.removeAllObjects();
        if(secretArray == nil){
            return;
        }
        secretArray.removeAllObjects();
    }
    
    
}
