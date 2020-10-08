//
//  ViewController.swift
//  LottieToyProject
//
//  Created by 김혜지 on 2020/10/04.
//

import UIKit
import Lottie

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var points = [CGPoint]()
    var firstTouch = CGPoint()
    var longPressBeginTime = TimeInterval()
    let animationView = AnimationView(name: "orange")
//    let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gesture:)))
    
    
//    @IBAction func longPressAction(_ longPressGesture: UILongPressGestureRecognizer) {
//        longPressGesture.numberOfTouchesRequired = 1 //2
//        longPressGesture.minimumPressDuration = 3.0
//        longPressGesture.allowableMovement = CGFloat.greatestFiniteMagnitude
//        longPressGesture.delegate = self
//
//        if longPressGesture.state == .began {
//            print("longPressGesture began")
//            self.lastPoint = longPressGesture.location(in: self.view)
//            setAnimationView(self.lastPoint!)
//
//        } else if longPressGesture.state == .changed {
//            print("longPressGesture changed")
//            self.lastPoint = longPressGesture.location(in: self.view)
//            setAnimationView(self.lastPoint!)
//        } else if longPressGesture.state == .ended {
//            print("longPressGesture ended")
//            self.setAnimationView(longPressGesture.location(in: self.view))
//        }
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // animated VS true
        self.view.backgroundColor = .black
        self.view.isMultipleTouchEnabled = true
        self.setGestureRecognizer()
//        longPressGesture.numberOfTouchesRequired = 1 //2
//        longPressGesture.minimumPressDuration = 3.0
//        longPressGesture.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            self.points.append(touch.location(in: self.view))
        }
        print(self.points)
//        let touch = touches.first
//        self.lastPoint = touch?.location(in: self.view)
//        self.setAnimationView(self.lastPoint!)
        setAnimationView(self.points)
        self.animationView.loopMode = .loop
        print("touchesBegan is called")
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        var movedLocation = [CGPoint]()
        for touch: AnyObject in touches {
            self.points.append(touch.location(in: self.view))
            movedLocation.append(touch.location(in: self.view))
        }
//        let touch = touches.first
//        let currPoint = touch?.location(in: self.view)
//        self.setAnimationView(currPoint!)
//        self.lastPoint = currPoint
        
        if movedLocation != self.points {
            setAnimationView(self.points)
            self.animationView.loopMode = .loop
            self.points.removeAll()
        }
        print("touchesMoved is called")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            self.points.append(touch.location(in: self.view))
        }
//        let touch = touches.first
//        let currPoint = touch?.location(in: self.view)
//        self.lastPoint = currPoint
        self.animationView.removeFromSuperview()
        self.points.removeAll()
        print("touches ended")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setGestureRecognizer() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gesture:)))
        longPressGesture.numberOfTouchesRequired = 2
        longPressGesture.minimumPressDuration = 3.0
        longPressGesture.allowableMovement = CGFloat.greatestFiniteMagnitude
        longPressGesture.delegate = self
        self.view.addGestureRecognizer(longPressGesture)
    }
    // 모든 finger animation should show
    func setAnimationView(_ locations: Any) {
        guard let locations = locations as? [CGPoint] else { return }
        //뭔가 animationView 더 만들어야할것같음
        for location: CGPoint in locations {
        let centerLocation = CGPoint(x: location.x - self.animationView.bounds.midX, y: location.y - self.animationView.bounds.midY)
        self.animationView.frame = CGRect(origin: centerLocation, size: self.animationView.frame.size)
        // origin 수정 필요(location 이용하여 이미지의 midX,Y cgpoint를 origin에)
        self.animationView.contentMode = .scaleAspectFit
//        self.animationView.loopMode = .loop
        animationView.play()
        view.addSubview(self.animationView)
        }
    }
    
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
        // 진행중이어도 3초 지나면 결과 보여주고 touchesMoved는 계속
        if gesture.state == .began {
            print("longPress began")
            setAnimationView(self.points)
            
//            self.lastPoint = gesture.location(in: self.view)
//            self.setAnimationView(self.lastPoint!)
            self.animationView.loopMode = .loop
            
            DispatchQueue.main.async {
                Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { timer in
                    self.firstTouch = gesture.location(ofTouch: 0, in: self.view)
                    self.animationView.removeFromSuperview()
                    self.setAnimationView(self.firstTouch)
                    self.animationView.loopMode = .playOnce
                    self.animationView.stop()
                }
            }
        }
        else if gesture.state == .changed {
            print("longPress changed")
            setAnimationView(self.points)
            
//            self.lastPoint = gesture.location(in: self.view)
//            self.setAnimationView(self.lastPoint!)
            self.animationView.loopMode = .loop
            
            DispatchQueue.main.async {
                Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { timer in
                    self.firstTouch = gesture.location(ofTouch: 0, in: self.view)
                    self.animationView.removeFromSuperview()
                    self.setAnimationView(self.firstTouch)
                    self.animationView.loopMode = .playOnce
                    self.animationView.stop()
                }
            }
        }
        else if gesture.state == .ended {
            print("gesture ended")
            self.animationView.removeFromSuperview()
        }
    }

}

