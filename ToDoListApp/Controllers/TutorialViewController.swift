//
//  TutorialViewController.swift
//  ToDoList
//
//  Created by Tomasz Paluszkiewicz on 13/11/2020.
//  Copyright © 2020 Tomasz Paluszkiewicz. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewConfig()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.all)
    }
    
    
    @objc
    func buttonAction() {
        
        self.dismiss(animated: true, completion: nil)
    }
   
    
    // MARK: - ScrollView Configuration
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageControl.currentPage = Int(pageIndex)
        
       
    }
    
    
    // MARK: - View Configuration
    
    func viewConfig() {
        
        scrollView.delegate = self
        
        let slides: [SlideTutorial] = createSlides()
        setupSlideScrollView(slides: slides)
        pageControl.numberOfPages = slides.count
        pageControl.currentPage = 0
        view.bringSubviewToFront(pageControl)
        
    }
    
    
    // MARK: - Slides Configuration

    func setupSlideScrollView(slides: [SlideTutorial]) {
            
            scrollView.contentSize = CGSize(width: self.view.frame.size.width * CGFloat(slides.count), height: scrollView.frame.size.height)
            
            scrollView.isPagingEnabled = true
            
            for i in 0..<slides.count {
                slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
                scrollView.addSubview(slides[i])
            }
        }
    
    
    
    func createSlides() -> [SlideTutorial] {
            
            let slide1: SlideTutorial = Bundle.main.loadNibNamed(ViewName.slideTutorial, owner: self, options: nil)?.first as! SlideTutorial
        slide1.label.text = "TAP '+'\nTO ADD A NEW CATEGORY".localized()
            slide1.imageTutorial.image = UIImage(named: ImageName.addCategory)
            
            let slide2: SlideTutorial = Bundle.main.loadNibNamed(ViewName.slideTutorial, owner: self, options: nil)?.first as! SlideTutorial
        slide2.label.text = "LONG-PRESS CATEGORY CELL\nTO CHANGE CATEGORY COLOR".localized()
            slide2.imageTutorial.image = UIImage(named: ImageName.changeColor)
            
            let slide3: SlideTutorial = Bundle.main.loadNibNamed(ViewName.slideTutorial, owner: self, options: nil)?.first as! SlideTutorial
        slide3.label.text = "INSIDE CATEGORY TAP '+'\nTO ADD NEW TASK".localized()
            slide3.imageTutorial.image = UIImage(named: ImageName.addNewItem)
            
            let slide4: SlideTutorial = Bundle.main.loadNibNamed(ViewName.slideTutorial, owner: self, options: nil)?.first as! SlideTutorial
        slide4.label.text = "SWIPE TO THE LEFT\nTO DELETE THING TO DO OR CATEGORY".localized()
            slide4.imageTutorial.image = UIImage(named: ImageName.swipeDelete)
            
            let slide5: SlideTutorial = Bundle.main.loadNibNamed(ViewName.slideTutorial, owner: self, options: nil)?.first as! SlideTutorial
        slide5.label.text = "LONG-PRESS THING TO DO\nTO SET REMINDER TIME\n/CALENDAR EVENT".localized()
            slide5.imageTutorial.image = UIImage(named: ImageName.addEvent)
            
            let slide6: SlideTutorial = Bundle.main.loadNibNamed(ViewName.slideTutorial, owner: self, options: nil)?.first as! SlideTutorial
        slide6.label.text = "TAP THING TO DO\nTO SET A CHECKMARK".localized()
            slide6.imageTutorial.image = UIImage(named: ImageName.itemCheck)
            
            let slide7: SlideTutorial = Bundle.main.loadNibNamed(ViewName.slideTutorial, owner: self, options: nil)?.first as! SlideTutorial
        slide7.label.text = "TAP EDIT BUTTON\nTO EDIT THING TO DO".localized()
            slide7.imageTutorial.image = UIImage(named: ImageName.editItems)
            
            let slide8: SlideTutorial = Bundle.main.loadNibNamed(ViewName.slideTutorial, owner: self, options: nil)?.first as! SlideTutorial
        slide8.label.text = "EDIT MODE GIVE ACCESS\nTO DRAG AND DROP OPTION".localized()
            slide8.imageTutorial.image = UIImage(named: ImageName.moveItem)
            
            let slide9: SlideTutorial = Bundle.main.loadNibNamed(ViewName.slideTutorial, owner: self, options: nil)?.first as! SlideTutorial
        slide9.label.text = "IN SETTINGS YOU CAN SET\nREMEINDER ALERTS TIME(HOW MANY MINUTES BEFORE AN EVENT START)".localized()
            slide9.imageTutorial.image = UIImage(named: ImageName.optionSet)
        
        let slide10: SlideTutorial = Bundle.main.loadNibNamed(ViewName.slideTutorial, owner: self, options: nil)?.first as! SlideTutorial
        slide10.label.text = "\nTHAT'S ALL,\n\nRIGHT NOW YOU WILL BE\nREMEMBER EVERYTHING\n\nwith\n\nTO DO LIST CALEDAR ✓".localized()
        slide10.imageTutorial.isHidden = true
        slide10.exitButton.isHidden = false
        slide10.exitButton.addTarget(self,
                                    action: #selector(buttonAction),
                                    for: .touchUpInside)
            
        
            return [slide1, slide2, slide3, slide4, slide5, slide6, slide7, slide8, slide9, slide10]
        }
        
        
    
}
