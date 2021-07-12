//
//  TabBarVC.swift
//  Radio Player
//
//  Created by Chandresh Kachariya on 10/07/21.
//

import UIKit

class TabBarVC: UITabBarController {
    
    var window1: UIWindow?
    var bottomPlayer1: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initialSetup()
    }
    
    //Use this method for default initialization
    func initialSetup() {
        //Setup Bottom Player on window
        window1 = UIApplication.shared.windows.first!
        self.bottomPlayer1 = UIView(frame: CGRect(x: 0, y: self.tabBar.frame.minY - 135, width: window1?.frame.width ?? 0, height: 100))
        self.bottomPlayer1?.backgroundColor = UIColor.clear
        window1?.addSubview(self.bottomPlayer1!)
        
        let myVC = PlayerVC.init(nibName: "PlayerVC", bundle: nil)
        let vc = PlayerVC.shared
        self.bottomPlayer1?.addSubview(vc.view)
        vc.view.isHidden = true
        myVC.didMove(toParent: self)
    }
    
}
