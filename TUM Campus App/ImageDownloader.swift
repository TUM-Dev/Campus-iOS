//
//  ImageDownloader.swift
//  TUM Campus App
//
//  This file is part of the TUM Campus App distribution https://github.com/TCA-Team/iOS
//  Copyright (c) 2018 TCA
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, version 3.
//
//  This program is distributed in the hope that it will be useful, but
//  WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
//  General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program. If not, see <http://www.gnu.org/licenses/>.
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
    let maxCache: CacheTime
    private var promise: Response<UIImage>?
    
    init(url: String?, maxCache: CacheTime = .no) {
        self.url = url
        self.maxCache = maxCache
    }
    
    @discardableResult func fetch() -> Response<UIImage?> {
        promise = promise ?? url.map { .new(from: $0, maxCache: self.maxCache) }
        return promise?.map { .some($0) } ?? .successful(with: nil)
    }
    
    func bind(to imageView: UIImageView,
              default image: UIImage?,
              mapping transform: @escaping (UIImage) -> UIImage = { $0 }) -> ImageViewBinding {
        
        fetch()
        let binding = ImageViewBinding()
        imageView.image = image
        promise?.onSuccess(in: .main) { [weak binding, weak imageView] image in
            guard binding != nil else { return }
            imageView?.image = transform(image)
        }
        return binding
    }
    
    func bind(to barButton: UIBarButtonItem,
              default image: UIImage? = nil,
              mapping transform: @escaping (UIImage) -> UIImage = { $0 }) -> ImageViewBinding {
        
        promise = promise ?? url.map { .new(from: $0, maxCache: self.maxCache) }
        let binding = ImageViewBinding()
        barButton.image = image
        promise?.onSuccess(in: .main) { [weak binding, weak barButton] image in
            guard binding != nil else { return }
            let transformed = transform(image)
            let newImage = barButton?.image.map {
                transformed
                    .resized(to: $0.size, scale: $0.scale)
                    .withRenderingMode(.alwaysOriginal)
            } ?? transformed
            barButton?.image = newImage
        }
        return binding
    }
    
}

extension Response where T == UIImage {
    
    static func new(from url: String, maxCache: CacheTime = .no) -> Response<T> {
        return UIImage.download(url: url, maxCache: maxCache)
    }
    
}

extension Data {
    
    static let cache = FileCache(directory: "DownloadCache")
    
    static func download(url string: String, maxCache: CacheTime = .no) -> Response<Data> {
        return string.url.map { url in
            let key = url.relativePath.replacingOccurrences(of: "/", with: "_")
            if let cached = cache.get(with: key, maxTime: maxCache) {
                return .successful(with: cached)
            }
            return async {
                let data = try Data(contentsOf: url)
                if maxCache != .no {
                    cache.store(data, with: key)
                }
                return data
            }
        } ?? .errored(with: .cannotPerformRequest)
    }
    
}

extension UIImage {
    
    
    static func download(url string: String, maxCache: CacheTime = .no) -> Response<UIImage> {
        return Data.download(url: string, maxCache: maxCache).flatMap { data in
            return async {
                guard let image = UIImage(data: data) else {
                    throw APIError.invalidResponse
                }
                return image
            }
        }
    }
    
}
