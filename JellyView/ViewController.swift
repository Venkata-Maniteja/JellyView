//
//  ViewController.swift
//  JellyView
//
//  Created by Rupika Sompalli on 13/02/19.
//  Copyright © 2019 Venkata. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var jellyView : JellyView?
    
    var openCurtain = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        jellyView = JellyView.fromNib()
        jellyView?.frame = CGRect(x: 0, y: -30, width: view.frame.size.width, height: 100)
        
        jellyView?.touchPoint = CGPoint(x: jellyView!.frame.size.width/2, y: jellyView!.frame.size.height - 50)
        jellyView?.offset = 50
        view.addSubview(jellyView!)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

        
        jellyView?.touchPoint = CGPoint(x: jellyView!.frame.size.width/2, y: jellyView!.frame.size.height - 50)
        jellyView?.offset = 50
        self.jellyView?.setNeedsDisplay()
        
        openCurtain = !openCurtain
        //start animation
        if openCurtain == true{
            
            self.jellyView?.frame = CGRect(x: 0, y: -view.frame.size.height+80, width: self.view.frame.size.width, height: view.frame.size.height)
            
            UIView.animate(withDuration: 1.0, delay: 0, options: [.transitionCurlDown], animations: {
                self.jellyView?.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                self.jellyView?.touchPoint = CGPoint(x: self.jellyView!.frame.size.width/2, y: self.jellyView!.frame.size.height - 50)
                self.jellyView?.offset = 50
            }, completion: nil)
            
           
        }else{
            
            self.jellyView?.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: view.frame.size.height)
            UIView.animate(withDuration: 1.0, delay: 0, options: [.transitionCurlUp], animations: {
                self.jellyView?.frame = CGRect(x: 0, y: -self.view.frame.size.height+80, width: self.view.frame.size.width, height: self.view.frame.size.height)
                self.jellyView?.touchPoint = CGPoint(x: self.jellyView!.frame.size.width/2, y: self.jellyView!.frame.size.height - 50)
                self.jellyView?.offset = 50
            }, completion: nil)
            
            
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first!
        let location = touch.location(in: view)
        
       
        
        
        if location.y < (jellyView!.frame.size.height + jellyView!.frame.origin.y){
            
            self.jellyView?.touchPoint = CGPoint(x: location.x, y: location.y - jellyView!.frame.origin.y)
            jellyView?.offset = 50
            self.jellyView?.setNeedsDisplay()
        }else{
            self.jellyView?.touchPoint = CGPoint(x: location.x, y: jellyView!.frame.size.height )
            jellyView?.offset = 50
            self.jellyView?.setNeedsDisplay()
        }
        
        // self.jellyView!.frame = CGRect(x: 0, y: 50, width: self.jellyView!.frame.size.width, height:location.y)
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        jellyView?.touchPoint = CGPoint(x: jellyView!.frame.size.width/2, y: jellyView!.frame.size.height - 50)
        jellyView?.offset = 50
        self.jellyView?.setNeedsDisplay()
    }


}




class JellyView : UIView{
    
    var touchPoint : CGPoint!
    var rectanglePath : UIBezierPath!
    var offset : CGFloat!
    
    
    override func draw(_ rect: CGRect) {
        
        drawBezier(rect)
    }
    
     func drawBezier(_ rect: CGRect) {
        
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()
        
        //// Rectangle Drawing
        context!.saveGState()

        
        let cp1 = CGPoint(x: touchPoint.x + 40, y: touchPoint.y)
        let cp2 = CGPoint(x: touchPoint.x - 40, y: touchPoint.y)
        
        
        rectanglePath = UIBezierPath()
        rectanglePath.move(to: CGPoint(x: 0, y: rect.size.height - offset))
        
        rectanglePath.addCurve(to: touchPoint, controlPoint1: CGPoint(x: 0, y: rect.size.height - offset), controlPoint2: cp2)
        rectanglePath.addCurve(to: CGPoint(x: rect.size.width, y: rect.size.height - offset), controlPoint1: cp1, controlPoint2: CGPoint(x: rect.size.width, y: rect.size.height - offset))
        
        
        rectanglePath.addLine(to: CGPoint(x: rect.size.width, y: 0))
        rectanglePath.addLine(to: CGPoint(x: 0, y: 0))
        rectanglePath.addLine(to: CGPoint(x: 0, y: rect.size.height - offset))
        rectanglePath.close()
        UIColor.clear.setFill()
        rectanglePath.fill()
        
        
        context!.restoreGState()
        
        
        let mask           = CAShapeLayer()
        mask.path          = rectanglePath.cgPath
        layer.mask         = mask
    }
    
    
}


extension UIView {
    class func fromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}

