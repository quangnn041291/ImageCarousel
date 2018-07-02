//
//  ImageCarouseltem.swift
//  ImageCarousel
//
//  Created by Firdavs Khaydarov on 30/06/18.
//  Copyright © 2018 Firdavs Khaydarov. All rights reserved.
//

import UIKit

public class ImageCarouseltem {
    public var url: String?
    public var image: UIImage?
    public var title: String?

    public init(url: String? = nil, image: UIImage? = nil, title: String? = nil) {
        self.url = url
        self.image = image
        self.title = title
    }
}
