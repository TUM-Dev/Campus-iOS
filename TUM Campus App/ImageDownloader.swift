//
//  ImageDownloader.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/8/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import UIKit
import Sweeft

typealias Image = Response<UIImage>

class ImageViewBinding {
    fileprivate var cancelled = false
    
    func cancel() {
        cancelled = true
    }
}

protocol ImageContainer {
    var image: Image? { get }
}

extension Response where T == UIImage {
    
    static func new(from url: String) -> Response<T> {
        return UIImage.download(url: url)
    }
    
    func bind(to imageView: UIImageView, default image: UIImage?) -> ImageViewBinding {
        let binding = ImageViewBinding()
        imageView.image = image
        onSuccess(in: .main) { image in
            guard !binding.cancelled else { return }
            imageView.image = image
        }
        return binding
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
