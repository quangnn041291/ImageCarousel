//
//  ViewController.swift
//  ImageCarouselExample
//
//  Created by Firdavs Khaydarov on 30/06/18.
//  Copyright © 2018 Firdavs Khaydarov. All rights reserved.
//

import UIKit
import ImageCarousel

class ViewController: UIViewController {
    var imageCarousel: ImageCarousel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        title = "Image Carousel"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .white
        
        prepareImageCarousel()
    }
}

extension ViewController {
    func prepareImageCarousel() {
        imageCarousel = ImageCarousel()
        imageCarousel.backgroundColor = .lightGray
        imageCarousel.items = [
            ImageCarouseltem(image: #imageLiteral(resourceName: "james-gillespie-719235-unsplash")),
            ImageCarouseltem(image: #imageLiteral(resourceName: "jan-szwagrzyk-719569-unsplash")),
            ImageCarouseltem(image: #imageLiteral(resourceName: "nemanja-o-718755-unsplash"))
        ]
        
        imageCarousel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageCarousel)

        // Constraints
        imageCarousel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageCarousel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageCarousel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        imageCarousel.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
}

