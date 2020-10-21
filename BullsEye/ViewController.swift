//
//  ViewController.swift
//  BullsEye
//
//  Created by Matt Larsen on 10/5/20.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var horizontalSlider: UISlider!
    @IBOutlet var verticalSlider: UISlider!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var currentRoundLabel: UILabel!
    @IBOutlet var gridView: UIView!
    
    var horizontalCurrentValue = 0
    var verticalCurrentValue = 0
    var horizontalTargetValue = 0
    var verticalTargetValue = 0
    var score = 0
    var currentRound = 1
    var circleLayer = CAShapeLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customSliders()
        startNewRound()
        
        guard let viewBG = UIImage(named: "greenFelt2") else {return}
        gridView.layer.borderWidth = 10
        gridView.layer.borderColor = UIColor(red: 0.33, green: 0.16, blue: 0.05, alpha: 1).cgColor
        gridView.backgroundColor = UIColor(patternImage: viewBG)
        }
    

    @IBAction func showAlert() {
        let vDifference = abs(horizontalCurrentValue - horizontalTargetValue)
        let hDifference = abs(verticalCurrentValue - verticalTargetValue)
        
        let difference = Float(hDifference * hDifference + vDifference * vDifference).squareRoot()
        var points = 100 - Int(difference)
        score += points
        currentRound += 1
        
        let message = "You scored \(points) points."
        let alertTitle: String
        if difference == 0 {
            alertTitle = "Perfect!"
            points += 100
        } else if difference <= 10 {
            alertTitle = "Very close."
        } else if difference <= 20 {
            alertTitle = "Close."
        } else if difference <= 50 {
            alertTitle = "Okay..."
        } else {
            alertTitle = "Are you even TRYING?"
        }
        let alert = UIAlertController(title: alertTitle, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: { _ in
                                    self.startNewRound()})
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func horizontalSliderMoved(_ slider: UISlider) {
        horizontalCurrentValue = lroundf(slider.value)
    }

    @IBAction func verticalSliderMoved(_ sender: UISlider) {
        verticalCurrentValue = lroundf(sender.value)
    }
    
    @IBAction func startOver() {
        print("Start Over button pressed.")
        let alertTitle = "GAME OVER"
        let message = "Final score: \(score) points in \(currentRound) rounds."
        let alert = UIAlertController(title: alertTitle, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "START OVER", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        score = 0
        horizontalCurrentValue = 0
        horizontalTargetValue = 0
        currentRound = 1
        startNewRound()
        
        let transition = CATransition()
        transition.type = CATransitionType.fade
        transition.duration = 1
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        view.layer.add(transition, forKey: nil)
    }
    
    func customSliders() {
        let thumbImageNormal = UIImage(named: "SliderThumb-Normal")!
        horizontalSlider.setThumbImage(thumbImageNormal, for: .normal)
        verticalSlider.setThumbImage(thumbImageNormal, for: .normal)
        
        let thumbImageHighlighted = UIImage(named: "SliderThumb-Highlighted")!
        horizontalSlider.setThumbImage(thumbImageHighlighted, for: .highlighted)
        verticalSlider.setThumbImage(thumbImageHighlighted, for: .highlighted)
        
        let insets = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
        
        let trackLeftImage = UIImage(named:"SliderTrackLeft")!
        let trackLeftResizable = trackLeftImage.resizableImage(withCapInsets: insets)
        horizontalSlider.setMinimumTrackImage(trackLeftResizable, for: .normal)
        verticalSlider.setMinimumTrackImage(trackLeftResizable, for: .normal)
        
        let trackRightImage = UIImage(named: "SliderTrackRight")!
        let trackRightResizable = trackRightImage.resizableImage(withCapInsets: insets)
        horizontalSlider.setMaximumTrackImage(trackRightResizable, for: .normal)
        verticalSlider.setMaximumTrackImage(trackRightResizable, for: .normal)
        verticalSlider.makeVertical()
    }
    
    func startNewRound() {
        horizontalTargetValue = Int.random(in: 10...100)
        verticalTargetValue = Int.random(in: 10...30)

        horizontalCurrentValue = 50
        verticalCurrentValue = 15
        horizontalSlider.value = Float(horizontalCurrentValue)
        verticalSlider.value = Float(verticalCurrentValue)
        circleDot()
        updateLabels()
    }
    
    func updateLabels() {
        scoreLabel.text = String(score)
        currentRoundLabel.text = String(currentRound)
    }
    
    func circleDot() {
        let circleCenterX = Int(CGFloat(horizontalTargetValue) * gridView.frame.size.width / 100) - 30
        let circleCenterY = Int(CGFloat(verticalTargetValue) * gridView.frame.size.height / 30) - 30
        circleLayer.path = UIBezierPath(ovalIn: CGRect(x: circleCenterX, y: circleCenterY, width: 20, height: 20)).cgPath;
        circleLayer.lineWidth = 10
        circleLayer.fillColor = UIColor.red.cgColor
        circleLayer.strokeColor = UIColor.white.cgColor;
        gridView.layer.addSublayer(circleLayer)
    }
    
}

//MARK: - rotate any elements on the screen
extension UIView {
    func makeVertical() {
        transform = CGAffineTransform(rotationAngle: (-CGFloat.pi/2))
    }
}
