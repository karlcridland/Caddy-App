//
//  ViewController.swift
//  Caddy App Watch
//
//  Created by Karl Cridland on 01/05/2021.
//

import UIKit
import WatchConnectivity

var home = UIView()
class ViewController: UIViewController, WCSessionDelegate {
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print(1)
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print(2)
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print(3)
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        if let receivedGlobal = applicationContext["my_global"] as? [String:[Int]]{
            print(receivedGlobal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        home = self.view
        Settings.viewController = self
        Settings.shared.loadStorage()
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        UIApplication.shared.windows.forEach { window in
            window.overrideUserInterfaceStyle = .dark
        }
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false, block: { _ in
            if let layout = self.view.superview?.layoutMargins{
                Settings.top = layout.top
                Settings.bottom = layout.bottom
                
                if let s = self.view.superview{
                    Settings.cornerRadius = s.layer.cornerRadius
                }
                
                self.startUp()
            }
        })
    }
    
    var homeView: HomeMenuView?
    func startUp() {
        if (Settings.playing){
            
        }
        else{
            let newGame = HomeMenuView()
            homeView = newGame
            self.view.addSubview(newGame)
        }
        
    }
    
}

func addCover() -> UIButton{
    let cover = UIButton(frame: home.frame)
    home.addSubview(cover)
    return cover
}
