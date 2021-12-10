//
//  PomodoroViewController.swift
//  Xnote
//
//  Created by Cesar Augusto Acjota Merma on 12/7/21.
//  Copyright © 2021 xnote. All rights reserved.
//

import UIKit
import Firebase

class PomodoroViewController: UIViewController, CAAnimationDelegate {
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    
//    @IBOutlet weak var nombreTarea: UILabel!
//
//    @IBOutlet weak var tareaTerminada: UIButton!
    
    let foreProgressLayer = CAShapeLayer()
    let backProgressLayer = CAShapeLayer()
    let animation = CABasicAnimation(keyPath: "strokeEnd")
    
    //tarea
    
    public var tituloTarea: String = ""
    public var idTarea: String = ""
    
    var timer = Timer()
    var isTimerStarted = false
    var isAnimationStarted = false
    var time = 300
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawBackLayer()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnTaskTerminada(_ sender: Any){
    Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("tareas").child(idTarea).removeValue()
        let alerta = UIAlertController(title: "Terminaste la Tarea", message: "Terminaste la tarea por lo tanto se elimina la tarea", preferredStyle: .alert)
        let btnOK = UIAlertAction(title: "Aceptar", style: .default, handler: { (UIAlertAction) in
            self.performSegue(withIdentifier: "listaTareas", sender: nil)
        })
        alerta.addAction(btnOK)
        self.present(alerta,animated: true,completion: nil)
        //self.present(ListNotesViewController(), animated: true)
    }
   
    
    @IBAction func startButtonTapped(_ sender: Any) {
        cancelButton.isEnabled = true
        cancelButton.alpha = 1.0
        if !isTimerStarted{
            
            startResumeAnimation()
            startTimer()
            isTimerStarted = true
            drawForeLayer()
            startButton.setTitle("Pausa", for: .normal)
            startButton.setTitleColor(UIColor.orange, for: .normal)
            
        }else{
            pauseAnimation()
            timer.invalidate()
            isTimerStarted = false
            startButton.setTitle("Reiniciar", for: .normal)
            startButton.setTitleColor(UIColor.green, for: .normal
            )
        }
    }
    
    @IBAction func cancelButtinTapped(_ sender: Any) {
        stopAnimation()
        cancelButton.isEnabled = false
        cancelButton.alpha = 0.5
        startButton.setTitle("Comenzar", for: .normal)
        startButton.setTitleColor(UIColor.green, for: .normal)
        timer.invalidate()
        time = 300
        isTimerStarted = false
        timeLabel.text = "25:00"
    }
    
    
    func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
    }
    @objc func updateTimer(){
        if time<1{
            cancelButton.isEnabled = false
            cancelButton.alpha = 0.5
            startButton.setTitle("Comenzar", for: .normal)
            startButton.setTitleColor(UIColor.green, for: .normal)
            timer.invalidate()
            time = 10
            isTimerStarted = false
            timeLabel.text = "25:00"
        }else{
            time -= 1
            timeLabel.text = formatTime()
            
        }
        
    }
    func formatTime()->String{
        let minutos = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format: "%02i:%02i",  minutos, seconds)
    }
    //circulo Xd
    func drawBackLayer(){
        backProgressLayer.path = UIBezierPath(arcCenter: CGPoint(x:view.frame.midX, y:view.frame.midY), radius: 100, startAngle: -90.degreesToRadians, endAngle: 270.degreesToRadians, clockwise: true).cgPath
        backProgressLayer.strokeColor = UIColor.white.cgColor
        backProgressLayer.fillColor = UIColor.clear.cgColor
        backProgressLayer.lineWidth = 10
        view.layer.addSublayer(backProgressLayer)
    }
    //la parte animada del circulo Xd
    func drawForeLayer(){
        foreProgressLayer.path = UIBezierPath(arcCenter: CGPoint(x:view.frame.midX, y:view.frame.midY), radius: 100, startAngle: -90.degreesToRadians, endAngle: 270.degreesToRadians, clockwise: true).cgPath
        
        foreProgressLayer.strokeColor = UIColor.yellow.cgColor
        foreProgressLayer.fillColor = UIColor.clear.cgColor
        foreProgressLayer.lineWidth = 10
        view.layer.addSublayer(foreProgressLayer)
    }
    func startResumeAnimation(){
        if !isAnimationStarted{
            startAnimation()
        }else{
            resumeAnimation()
        }
    }
    
    func startAnimation(){
        resetAnimation()
        foreProgressLayer.strokeEnd = 0.0
        animation.keyPath = "strokeEnd"
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 300
        animation.delegate = self
        animation.isRemovedOnCompletion = false
        animation.isAdditive = true
        animation.fillMode = CAMediaTimingFillMode.forwards
        foreProgressLayer.add(animation , forKey: "strokeEnd")
        isAnimationStarted = true
        
    }
    func resetAnimation(){
        foreProgressLayer.speed = 1.0
        foreProgressLayer.timeOffset = 0.0
        foreProgressLayer.beginTime = 0.0
        foreProgressLayer.strokeEnd = 0.0
        isAnimationStarted = false
    }
    func pauseAnimation(){
        let pausedTime = foreProgressLayer.convertTime(CACurrentMediaTime(), from: nil)
        foreProgressLayer.speed = 0.0
        foreProgressLayer.timeOffset = pausedTime
    }
    func resumeAnimation(){
        let pausedTime = foreProgressLayer.timeOffset
        foreProgressLayer.speed = 1.0
        foreProgressLayer.timeOffset = 0.0
        foreProgressLayer.beginTime = 0.0
        let timeSincePaused = foreProgressLayer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        foreProgressLayer.beginTime = timeSincePaused
    }
    func  stopAnimation(){
        foreProgressLayer.speed = 1.0
        foreProgressLayer.timeOffset = 0.0
        foreProgressLayer.beginTime = 0.0
        foreProgressLayer.strokeEnd = 0.0
        foreProgressLayer.removeAllAnimations()
        isAnimationStarted = false
    }
    internal func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        stopAnimation()
    }
}
extension Int{
    var degreesToRadians: CGFloat{
    return CGFloat(self) * .pi / 180
}
}
