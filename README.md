# ImageCarousel
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-brightgreen.svg?style=flat)](https://github.com/Carthage/Carthage)

Image slider in Swift.

![Demo](https://i.imgur.com/5e6h3Py.png)

## Installation
### Carthage:
```
github "Recouse/ImageCarousel"
```

## Requirements
- iOS 9.0+
- Xcode 9.0+
- Swift 4.0+

## Usage
```swift
import ImageCarousel

let imageCarousel = ImageCarousel()
imageCarousel.items = [
    ImageCarouseltem(url: "https://site.com/image.jpg"),
    ImageCarouseltem(image: UIImage(named: "your_image"))
]
```

If you're set URL instead image you should implement delegate method to download an image. Example with [Kingfisher](https://github.com/onevcat/Kingfisher) :
```swift
class ViewController: UIViewController, ImageCarouselDelegate {
    func viewDidLoad() {
        super.viewDidLoad()
        
        ...
        
        imageCarousel.delegate = self
    }

    func downloadImage(for imageView: UIImageView, fromUrl url: URL, andSet item: ImageCarouseltem) {
        imageView.kf.setImage(with: url)
    }
}
```

## Contribution
Feel free to make pull requests

