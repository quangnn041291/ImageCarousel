//
//  ImageCarousel.swift
//  ImageCarousel
//
//  Created by Firdavs Khaydarov on 30/06/18.
//  Copyright © 2018 Firdavs Khaydarov. All rights reserved.
//

import UIKit

public protocol ImageCarouselDelegate: class {
    func downloadImage(for imageView: UIImageView, fromUrl url: URL, andSet item: ImageCarouseltem)
}

public extension ImageCarouselDelegate {
    func downloadImage(for imageView: UIImageView, fromUrl url: URL, andSet item: ImageCarouseltem) {}
}

open class ImageCarousel: UIView {
    public enum Direction: Int {
        case left = -1, none, right
    }
    
    public var items = [ImageCarouseltem]() {
        didSet {
            prepareItems()
        }
    }
    
    private var beforeImage: UIImageView!
    fileprivate var beforeImageLeadingConstraint: NSLayoutConstraint!
    
    private var currentImage: UIImageView!
    
    private var afterImage: UIImageView!
    
    public var beforeIndex = 0
    
    public var currentIndex = 0
    
    public var afterIndex = 0
    
    public weak var delegate: ImageCarouselDelegate?
    
    // MARK: - Style
    public var slidesContentMode: UIView.ContentMode = .scaleAspectFill {
        didSet {
            updateContentMode()
        }
    }
    
    public var currentPageIndicatorTintColor: UIColor? {
        get {
            return pageControl.currentPageIndicatorTintColor
        }
        set {
            pageControl.currentPageIndicatorTintColor = newValue
        }
    }
    
    public var pageIndicatorTintColor: UIColor? {
        get {
            return pageControl.pageIndicatorTintColor
        }
        set {
            pageControl.pageIndicatorTintColor = newValue
        }
    }
    
    // MARK: - Private
    private var scrollView: UIScrollView!
    
    private var pageControl: UIPageControl!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        prepareScrollView()
        prepareImageViews()
        preparePageControl()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        prepareScrollView()
        prepareImageViews()
        preparePageControl()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        updateScrollViewFrame()
        beforeImageLeadingConstraint.constant = scrollView.frame.width
    }
    
    fileprivate func updateScrollViewFrame() {
        scrollView.contentInset = .zero
        scrollView.contentSize = CGSize(width: frame.size.width * 5.0, height: 0)
        scrollView.contentOffset = CGPoint(x: frame.size.width * 2, y: 0)
    }
    
    public func prepareItems() {
        guard items.count > 0 else {
            return
        }
        
        setImages()
        toggleScroll()
    }
    
    fileprivate func setImages() {
        var beforeIndex = currentIndex - 1
        var afterIndex = currentIndex + 1
        if beforeIndex < 0 {
            beforeIndex = items.count - 1
        }
        if afterIndex > items.count - 1 {
            afterIndex = 0
        }
        
        // Set image
        setImage(for: currentIndex, imageView: currentImage)
        
        if items.count > 1 {
            setImage(for: beforeIndex, imageView: beforeImage)
            setImage(for: afterIndex, imageView: afterImage)
        }
        
        pageControl.numberOfPages = items.count
        pageControl.currentPage = currentIndex
        updateScrollViewFrame()
    }
    
    fileprivate func setImage(for index: Int, imageView: UIImageView) {
        if let image = items[index].image {
            imageView.image = image
        } else if let string = items[index].url, let url = URL(string: string) {
            delegate?.downloadImage(for: imageView, fromUrl: url, andSet: items[index])
        }
    }
    
    fileprivate func toggleScroll() {
        scrollView.isScrollEnabled = items.count != 1
    }
    
    fileprivate func handleIndex(_ scrollDirection: Direction) {
        switch scrollDirection {
        case .left:
            currentIndex = currentIndex - 1
            if currentIndex < 0 {
                currentIndex = items.count - 1
            }
        case .right:
            currentIndex = currentIndex + 1
            if currentIndex == items.count {
                currentIndex = 0
            }
        case .none: break
        }
        
        pageControl.currentPage = currentIndex
    }
    
    fileprivate func scrollToImage(_ scrollDirection: Direction) {
        guard items.count > 0 else {
            return
        }
        
        switch scrollDirection {
        case .left:
            afterImage.image = currentImage.image
            setImage(for: currentIndex, imageView: currentImage)
            if currentIndex - 1 < 0 {
                setImage(for: items.count - 1, imageView: beforeImage)
            } else {
                setImage(for: currentIndex - 1, imageView: beforeImage)
            }
        case .right:
            beforeImage.image = currentImage.image
            setImage(for: currentIndex, imageView: currentImage)
            if currentIndex + 1 > items.count - 1 {
                setImage(for: 0, imageView: afterImage)
            } else {
                setImage(for: currentIndex + 1, imageView: afterImage)
            }
        case .none: break
        }
        
        scrollView.contentOffset = CGPoint(x: frame.size.width * 2, y: 0)
    }
    
    fileprivate func updateContentMode() {
        [beforeImage, currentImage, afterImage].forEach { image in
            image?.contentMode = self.slidesContentMode
        }
    }
}

extension ImageCarousel {
    fileprivate func prepareScrollView() {
        scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scrollView)
        
        // Constraints
        scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    fileprivate func prepareImageViews() {
        beforeImage = UIImageView()
        currentImage = UIImageView()
        afterImage = UIImageView()
        
        [beforeImage, currentImage, afterImage].forEach { image in
            image?.contentMode = self.slidesContentMode
            image?.clipsToBounds = true
            image?.translatesAutoresizingMaskIntoConstraints = false
        }
        
        scrollView.addSubview(beforeImage)
        scrollView.addSubview(currentImage)
        scrollView.addSubview(afterImage)
        
        // Before Image
        beforeImageLeadingConstraint = NSLayoutConstraint(item: beforeImage,
                                                          attribute: .leading,
                                                          relatedBy: .equal,
                                                          toItem: scrollView,
                                                          attribute: .leading,
                                                          multiplier: 1,
                                                          constant: 0)
        beforeImageLeadingConstraint.isActive = true
        beforeImage.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        beforeImage.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        beforeImage.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true

        // Current Image
        currentImage.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        currentImage.leftAnchor.constraint(equalTo: beforeImage.rightAnchor).isActive = true
        currentImage.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        currentImage.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
        
        // After Image
        afterImage.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        afterImage.leftAnchor.constraint(equalTo: currentImage.rightAnchor).isActive = true
        afterImage.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        afterImage.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
    }
    
    fileprivate func preparePageControl() {
        pageControl = UIPageControl()
        pageControl.hidesForSinglePage = true
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.pageIndicatorTintColor = UIColor.white.withAlphaComponent(0.5)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        addSubview(pageControl)
        
        // Constraints
        pageControl.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
    }
}

extension ImageCarousel: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard items.count > 0 else {
            return
        }
        
        let width = scrollView.frame.width
        let currentPage = ((scrollView.contentOffset.x - width / 2) / width) - 1.5
        
        guard !currentPage.isNaN,
            let scrollDirection = Direction(rawValue: Int(currentPage)) else { return }
        
        switch scrollDirection {
        case .none:
            break
        default:
            handleIndex(scrollDirection)
            scrollToImage(scrollDirection)
        }
    }
}
