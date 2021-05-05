//
//  InterfaceController.swift
//  Caddy App Watch WatchKit Extension
//
//  Created by Karl Cridland on 01/05/2021.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController {

    @IBOutlet var game: WKInterfaceGroup!
    @IBOutlet var hole: WKInterfaceLabel!
    @IBOutlet var score: WKInterfaceLabel!
    @IBOutlet var next: WKInterfaceButton!
    @IBOutlet var remove: WKInterfaceButton!
    @IBOutlet var add: WKInterfaceButton!
    @IBOutlet var scoreboard: WKInterfaceGroup!
    @IBOutlet var finalScore: WKInterfaceLabel!
    @IBOutlet var settings: WKInterfaceGroup!
    @IBOutlet var timer: WKInterfaceTimer!
    
    var scores : NSMutableArray = []
    var scoreLabels = [WKInterfaceLabel]()
    var holeButtons = [WKInterfaceButton]()
    var numberOfHoles = 9
    
    var currentScore = 0
    var currentHole = 1
    
    @IBOutlet var holesBackground: WKInterfaceGroup!
    @IBOutlet var nine: WKInterfaceButton!
    @IBOutlet var eighteen: WKInterfaceButton!
    
    @IBAction func nextHole() {
        if (currentScore > 0){
            scores[currentHole-1] = currentScore
            currentHole += 1
            if (currentHole <= numberOfHoles){
                currentScore = 0
                hole.setText("Hole \(currentHole)")
                updateScore()
            }
            else{
                Settings.playing = false
                game.setHidden(true)
                scoreboard.setHidden(false)
                finalScore.setHidden(false)
                var total = 0
                timer.stop()
                scores.forEach { score in
                    if let n = score as? Int{
                        total += n
                    }
                }
                finalScore.setText("Final Hole\nScore: \(total)")
                
                print(1)
                let session = WCSession.default
                if session.activationState == .activated {
                    do{
                        try session.updateApplicationContext(["my_global": ["test":[0]]])
                    }
                    catch{
                    
                    }
                    
                }
            }
        }
    }
    
    @IBAction func increaseScore() {
        currentScore += 1
        updateScore()
    }
    
    @IBAction func decreaseScore() {
        currentScore -= 1
        updateScore()
    }
    
    func updateScore(){
        if (currentScore < 0){
            currentScore = 0
        }
        score.setText("\(currentScore)")
        if (scoreLabels.count > 0){
            scoreLabels[currentHole-1].setText(String(currentScore))
        }
        
        if currentScore == 0{
            next.setAlpha(0.5)
            remove.setAlpha(0.5)
        }
        else{
            next.setAlpha(1)
            remove.setAlpha(1)
        }
    }
    
    @IBAction func restart() {
        
        scores = []
        currentHole = 1
        currentScore = 0
        hole.setText("Hole \(currentHole)")
        game.setHidden(false)
        scoreboard.setHidden(true)
        updateScore()
        Settings.playing = true
        timer.setDate(Date())
        timer.start()
        
        if let holePicker = Settings.holePicker{
            if let prompt = Settings.prompt{
                prompt.setHidden(true)
            }
            holePicker.setHidden(false)
            holePicker.setNumberOfRows(numberOfHoles, withRowType: "HoleRowControllerIdentifier")
            Settings.buttons = []
            for i in 0 ..< numberOfHoles {
                if let row = holePicker.rowController(at: i) as? HoleRowController{
                    row.hole = i
                    row.label.setText("Hole \(i+1)")
                    if scores.count > i{
                        if let value = scores[i] as? Int{
                            row.value.setText("\(value)")
                        }
                    }
                    else{
                        row.value.setText("0")
                    }
                    
                    scoreLabels.append(row.value)

                }
            }
        }
        
    }
    
    @IBAction func nineHoles() {
        nine.setBackgroundColor(#colorLiteral(red: 0, green: 0.9810667634, blue: 0.5736914277, alpha: 1))
        eighteen.setBackgroundColor(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))
        numberOfHoles = 9
    }
    
    @IBAction func eighteenHoles() {
        eighteen.setBackgroundColor(#colorLiteral(red: 0, green: 0.9810667634, blue: 0.5736914277, alpha: 1))
        nine.setBackgroundColor(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))
        numberOfHoles = 18
    }

    @IBAction func openSettings() {
        settings.setHidden(false)
    }
    
    @IBAction func removeSettings() {
        settings.setHidden(true)
    }
    
    override func awake(withContext context: Any?) {
        // Configure interface objects here.
        super.awake(withContext: context)
        holesBackground.setCornerRadius(4)
        Settings.interface = self
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
