//
//  ViewController.swift
//  DCSlideshow
//
//  Created by Alex on 2017/5/31.
//  Copyright © 2017年 Alex. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var slideshow: DCSlideshow? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        slideshow = DCSlideshow(frame: CGRect(x: 0, y: 200, width: self.view.frame.width, height: 200))
        
        var resouceImages = [UIImage]()
        for i in 0...2 {
            resouceImages.append(UIImage(named: "\(i+1).jpg")!)
        }
        
        slideshow?.setWillShowImages(images: resouceImages)
        
        self.view.addSubview(slideshow!)
        
        slideshow?.beginSlideWithInterval(timeInterval: 2)
    }

}

