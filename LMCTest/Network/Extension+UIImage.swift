//
//  Extension+UIImage.swift
//  LMCTest
//
//  Created by сергей on 03.02.2021.
//

import Foundation

import UIKit

let imageCache = NSCache<NSString, UIImage>()
extension UIImageView {
    func loadImageUsingCache(withUrl urlString : String) {
        let url = URL(string: urlString)
        print(url)
        if url == nil { return }
        self.image = nil

        // check cached image
        if let cachedImage = imageCache.object(forKey: urlString as NSString)  {
            self.image = cachedImage
            return
        }

        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView.init(style: .medium)
        addSubview(activityIndicator)
        activityIndicator.startAnimating()
        activityIndicator.center = self.center

        // if not, download image from url
        URLSession.shared.dataTask(with: url!, completionHandler: { [weak self] (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }

            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    imageCache.setObject(image, forKey: urlString as NSString)
                    self?.image = image
                    activityIndicator.removeFromSuperview()
                }
            }

        }).resume()
    }
}
