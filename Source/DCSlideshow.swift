//
//  DCSlideshow.swift
//  DCSlideshow
//
//  Created by Alex on 2017/5/31.
//  Copyright © 2017年 Alex. All rights reserved.
//

import UIKit

class DCSlideshow: UIView, UIScrollViewDelegate {
    
    private var timer:Timer? = nil
    private var myTimeInterval = 2.0
    
    private lazy var scrollView: UIScrollView = {
        let sV = UIScrollView()
        sV.delegate = self
        sV.bounces = false
        sV.isPagingEnabled = true
        sV.showsHorizontalScrollIndicator = false
        return sV
    }()
    
    private let pageControl: UIPageControl = {
        let pC = UIPageControl()
        return pC
    }()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        scrollView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        scrollView.setContentOffset(CGPoint(x: frame.width, y: 0), animated: false)
        
        pageControl.frame = CGRect(x: 0, y: frame.height-20, width: frame.width, height: 10)
        
        addSubview(scrollView)
        addSubview(pageControl)
        
        bringSubview(toFront: pageControl)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - SlideshowAction
    
    private var imageCount:Int = 0
    private var pageNum: Int = 0
    
    public func setWillShowImages(images: [UIImage]) {
        imageCount = images.count
        
        pageControl.numberOfPages = imageCount
        
        let contentWidth = self.scrollView.frame.width * CGFloat(imageCount+2)
        
        scrollView.contentSize = CGSize(width: contentWidth, height: self.frame.height)
        
        for (index, image) in images.enumerated() {
            
            if index == 0 {
                let imageView = UIImageView(image: images[imageCount-1])
                imageView.frame = CGRect(x: scrollView.frame.width*CGFloat(index), y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
                
                scrollView.addSubview(imageView)
            }
            
            let imageView = UIImageView(image: image)
            imageView.frame = CGRect(x: scrollView.frame.width*CGFloat(index+1), y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
            
            scrollView.addSubview(imageView)
            
            if index == imageCount - 1 {
                let imageView = UIImageView(image: images[0])
                imageView.frame = CGRect(x: scrollView.frame.width*CGFloat(index+2), y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
                
                scrollView.addSubview(imageView)
            }
        }
    }
    
    public func beginSlideWithInterval(timeInterval: TimeInterval) {
        
        self.myTimeInterval = timeInterval
        
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(nextPageAction), userInfo: nil, repeats: true)
            RunLoop.current.add(timer!, forMode: .commonModes)
        }
    }
    
    @objc private func nextPageAction() {
        
        self.pageNum += 1
        
        let scrollWidth = self.scrollView.frame.width
        scrollView.setContentOffset(CGPoint(x: scrollWidth*CGFloat(self.pageNum+1), y: 0), animated: true)
        
        if pageNum == imageCount {
            pageNum = 0
        }
        
        pageControl.currentPage = self.pageNum
    }

    
    //MARK: - UIScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x == self.scrollView.frame.width*CGFloat(imageCount+1) {
            scrollView.setContentOffset(CGPoint.init(x: self.scrollView.frame.width, y: 0), animated: false)
        } else if scrollView.contentOffset.x == 0 {
            scrollView.setContentOffset(CGPoint.init(x: self.scrollView.frame.width*CGFloat(imageCount), y: 0), animated: false)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        timer?.invalidate()
        timer = nil
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let curContentOffset = scrollView.contentOffset
        let scrollWidth = self.scrollView.frame.width
        
        self.pageNum = Int(curContentOffset.x/scrollWidth)-1
        
        if self.pageNum == imageCount {
            self.pageNum = 0
        } else if self.pageNum == -1 {
            self.pageNum = imageCount-1
        }
        
        pageControl.currentPage = self.pageNum
        
        timer = Timer.scheduledTimer(timeInterval: self.myTimeInterval, target: self, selector: #selector(nextPageAction), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: .commonModes)
    }
}
