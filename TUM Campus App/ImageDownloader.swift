//
//  ImageDownloader.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/8/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import UIKit
import Sweeft

class ImageViewBinding {
    // Empty class used to signal when the reference has changed
}

protocol ImageContainer {
    var image: Image? { get }
}

class Image {
    
    let url: String?
    private var promise: Response<UIImage>?
    
    init(url: String?) {
        self.url = url
    }
    
    func bind(to imageView: UIImageView,
              default image: UIImage?) -> ImageViewBinding {
        
        promise = promise ?? url.map { .new(from: $0) }
        let binding = ImageViewBinding()
        imageView.image = image
        promise?.onSuccess(in: .main) { [weak binding, weak imageView] image in
            guard binding != nil else { return }
            imageView?.image = image
        }
        return binding
    }
    
}

extension Response where T == UIImage {
    
    static func new(from url: String) -> Response<T> {
        return UIImage.download(url: url)
    }
    
}

extension UIImage {
    
    static func download(url string: String) -> Response<UIImage> {
        return string.url.map { url in
            return async {
                let data = try Data(contentsOf: url)
                guard let image = UIImage(data: data) else {
                    throw APIError.invalidResponse
                }
                return image
            }
        } ?? .errored(with: .cannotPerformRequest)
    }
    
}
