//
//  CustomViewController.swift
//  neaterDifferent
//
//  Created by HochinKazuma on 18/03/2016.
//  Copyright © 2016 k. All rights reserved.
//

import Foundation
import UIKit


class CustomViewController: UIViewController{
	
	let appColors = [
		"practice" : UIColor(red: 90/255, green: 158/255, blue: 1, alpha: 1),
		"timetrial" : UIColor(red: 180/255, green: 110/255, blue: 210/255, alpha: 1),
		"highscores": UIColor(red: 240/255, green: 190/255, blue: 10/255, alpha: 1),
		"white": UIColor.whiteColor(),
		"darkGrey": UIColor(red: 75/255, green: 75/255, blue: 75/255, alpha: 1),
		"lightGrey": UIColor(red: 225/255, green: 225/255, blue: 225/255, alpha: 1)
		]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func displayLabel(title:String, textColor: UIColor){
		let posX = Int(self.view.frame.width * 0.1)
		let posY = 70
        let myLabel = UILabel(frame: CGRect(
			x: posX,
			y: posY,
			width: Int(self.view.frame.width * 0.8),
			height: 60
			))
        myLabel.text = title
		myLabel.textAlignment = .Center;
        myLabel.font = UIFont.systemFontOfSize(25)
        myLabel.textColor = UIColor.whiteColor()
        myLabel.tag = 1
        self.view.addSubview(myLabel)
    }
	
	func removeViews(tag: Int){
		var viewsToFade = [UIView]()
		self.view.subviews.forEach({ if $0.tag == tag { viewsToFade.append($0) }})
		UIView.animateWithDuration(
			0.3,
			animations: {
				viewsToFade.forEach({ $0.alpha = 0 })
			},
			completion: {
				(finished: Bool) -> Void in
				viewsToFade.forEach({ $0.removeFromSuperview() })
		})
	}
	
	//hides status bar
	override func prefersStatusBarHidden() -> Bool {
		return true;
	}
}