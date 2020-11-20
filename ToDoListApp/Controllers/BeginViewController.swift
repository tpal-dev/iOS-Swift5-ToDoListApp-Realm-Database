//
//  BeginViewController.swift
//  ToDoListApp
//
//  Created by Tomasz Paluszkiewicz on 07/11/2020.
//  Copyright © 2020 Tomasz Paluszkiewicz. All rights reserved.
//

import UIKit
import Lottie

enum AnimationFrames: CGFloat {
  
    case slide1 = 30
    case slide2 = 40
    case slide3 = 60
    case slide4 = 90
    
}


class BeginViewController: UIViewController, UIScrollViewDelegate {
    
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var lottieLabel: UILabel!
    
    var animationView: AnimationView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewConfig()
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
        startAnimation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.all)
    }
    
    
    @objc
    func buttonAction() {
        defaults.set(true, forKey: KeyUserDefaults.firstLaunch)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    private func startAnimation() {
        animationView?.play(fromFrame: 0, toFrame: AnimationFrames.slide1.rawValue, loopMode: .none) {  (_) in
        
        }
    }
    
    
    func createSlides() -> [Slide] {
        
        let slide1: Slide = Bundle.main.loadNibNamed(ViewName.slide, owner: self, options: nil)?.first as! Slide
        slide1.label.text = "Welcome\n\nSwipe to begin\n".localized()

        let slide2: Slide = Bundle.main.loadNibNamed(ViewName.slide, owner: self, options: nil)?.first as! Slide
        slide2.label.text = "First tip:\n\nLongPress Category Cell\nto Change Color\n".localized()

        let slide3: Slide = Bundle.main.loadNibNamed(ViewName.slide, owner: self, options: nil)?.first as! Slide
        slide3.label.text = "Second tip:\n\nLongPress Item Cell\nto set Reminder\n".localized()
    
        let slide4: Slide = Bundle.main.loadNibNamed(ViewName.slide, owner: self, options: nil)?.first as! Slide
        slide4.label.isHidden = true
        slide4.button.isHidden = false
        slide4.button.setTitle("Let's start".localized(), for: .normal)
        slide4.button.titleLabel?.font = UIFont(name: Fonts.helveticNeueBold, size: 25)
        slide4.button.setTitleColor(.black, for: .normal)
        slide4.button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        slide4.button.layer.cornerRadius = slide4.button.frame.height / 2
        slide4.button.addTarget(self,
                         action: #selector(buttonAction),
                         for: .touchUpInside)
        
        return [slide1, slide2, slide3, slide4]
    }
    
    
    func setupSlideScrollView(slides: [Slide]) {
        
        scrollView.contentSize = CGSize(width: self.view.frame.size.width * CGFloat(slides.count), height: scrollView.frame.size.height)
        
        scrollView.isPagingEnabled = true
        
        
        for i in 0..<slides.count {
            slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
            scrollView.addSubview(slides[i])
        }
    }
    
    
   
    
    // MARK: - ScrollView Configuration
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let progress = scrollView.contentOffset.x / scrollView.contentSize.width
        let progressRange = AnimationFrames.slide4.rawValue - AnimationFrames.slide1.rawValue
        let progresFrame = progressRange*progress
        let currentFrame = progresFrame + AnimationFrames.slide1.rawValue
        animationView?.currentFrame = currentFrame

        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageControl.currentPage = Int(pageIndex)
        
        if pageIndex == CGFloat(3.0) {
            lottieLabel.isHidden = false
        } else {
            lottieLabel.isHidden = true
        }
        
    }
    
    
    // MARK: - View Configuration
    
    func viewConfig() {
        
        scrollView.delegate = self
        
        animationView = .init(name: AnimationName.checklist)
        animationView?.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height / 1.5)
        view.addSubview(animationView!)
        
        let slides: [Slide] = createSlides()
        setupSlideScrollView(slides: slides)
        pageControl.numberOfPages = slides.count
        pageControl.currentPage = 0
        view.bringSubviewToFront(pageControl)
    }
    
    
    
    
    
}
