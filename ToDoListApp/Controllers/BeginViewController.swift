//
//  BeginViewController.swift
//  ToDoListApp
//
//  Created by Tomasz Paluszkiewicz on 07/11/2020.
//  Copyright © 2020 Tomasz Paluszkiewicz. All rights reserved.
//

import UIKit
import Lottie

class BeginViewController: UIViewController, UIScrollViewDelegate {
    
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var scrollView: UIScrollView!

    var animationView: AnimationView?
    
    let stringArray = [ "Welcome\n\nSwipe to begin\n", "First tip:\n\nLongPress Category Cell\nto Change Color\n", "Second tip:\n\nLongPress Item Cell\nto set Reminder\n"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        animationView = .init(name: "checklist")
        animationView?.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height / 1.5)
        view.addSubview(animationView!)
        
        setupScrollView()

    }

    
    @objc
      func buttonAction() {
        defaults.set(true, forKey: KeyUserDefaults.firstLaunch)
          self.dismiss(animated: true, completion: nil)
      }

    
    func setupScrollView() {
        scrollView.contentSize = CGSize(width: self.view.frame.size.width * CGFloat(stringArray.count + 1), height: scrollView.frame.size.height)
        scrollView.delegate = self
        
        let button = UIButton(frame: CGRect(x: scrollView.center.x + CGFloat(stringArray.count) * self.view.frame.size.width - 80,
                                            y: 50,
                                            width: 160,
                                            height: 80))
        button.setTitle("Let's start", for: .normal)
        button.titleLabel?.font = UIFont(name: Fonts.helveticNeueBold, size: 25)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        button.layer.cornerRadius = button.frame.height / 2
       
        button.addTarget(self,
                         action: #selector(buttonAction),
                         for: .touchUpInside)
        
        scrollView.addSubview(button)
        
        for i in 0..<stringArray.count {
            let label = UILabel(frame: CGRect(x: scrollView.center.x + CGFloat(i) * self.view.frame.size.width - 150,
                                              y: 10,
                                              width: 300,
                                              height: 170))

            label.font = UIFont(name: Fonts.helveticNeueBold, size: 25)
            label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            label.lineBreakMode = .byWordWrapping
            label.numberOfLines = 0
            label.textAlignment = .center
            label.text = stringArray[i]

            scrollView.addSubview(label)

        }
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let progress = scrollView.contentOffset.x / scrollView.contentSize.width
        animationView?.currentProgress = progress
        
        
    }

    
    
}
