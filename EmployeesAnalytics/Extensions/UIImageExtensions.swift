//
//  UIImageExtensions.swift
//  EmployeesAnalytics
//
//  Created by Taras Didukh on 5/25/18.
//  Copyright © 2018 Taras Didukh. All rights reserved.
//

import Foundation
import UIKit
extension UIImage {
    func imageWithInsets(insetDimen: CGFloat) -> UIImage {
        return imageWithInset(insets: UIEdgeInsets(top: insetDimen, left: insetDimen, bottom: insetDimen, right: insetDimen))
    }
    
    func imageWithInset(insets: UIEdgeInsets) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(
            CGSize(width: self.size.width + insets.left + insets.right,
                   height: self.size.height + insets.top + insets.bottom), false, self.scale)
        let origin = CGPoint(x: insets.left, y: insets.top)
        self.draw(at: origin)
        let imageWithInsets = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return imageWithInsets!
    }
   func cropCenter(width: Double, height: Double) -> UIImage
{
    let contextImage: UIImage = UIImage(cgImage: self.cgImage!)
    let contextSize: CGSize = contextImage.size
    
    var posX: CGFloat = 0.0
    var posY: CGFloat = 0.0
    var cgwidth: CGFloat = CGFloat(width)
    var cgheight: CGFloat = CGFloat(height)
    
    // See what size is longer and create the center off of that
    if contextSize.width > contextSize.height {
        posX = ((contextSize.width - contextSize.height) / 2)
        posY = 0
        cgwidth = contextSize.height
        cgheight = contextSize.height
    } else {
        posX = 0
        posY = ((contextSize.height - contextSize.width) / 2)
        cgwidth = contextSize.width
        cgheight = contextSize.width
    }
    
    let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)
    
    // Create bitmap image from context using the rect
    

    let imageRef: CGImage = (contextImage.cgImage?.cropping(to: rect))!
    
    // Create a new image based on the imageRef and rotate back to the original orientation
    let image: UIImage = UIImage(cgImage: imageRef, scale: self.scale, orientation: self.imageOrientation)
    
    return image
//    let kMaxResolution : CGFloat = 2048
//
//    let imgRef = self.cgImage
//    let width = CGFloat(imgRef!.width)
//    let height = CGFloat(imgRef!.height)
//    var transform = CGAffineTransform.identity
//
//    var bounds = CGRect(x: 0, y: 0, width: width, height: height)
//
//    if (width > kMaxResolution || height > kMaxResolution)
//    {
//        let ratio: CGFloat = width / height;
//
//    if (ratio > 1)
//    {
//        bounds.size.width = kMaxResolution;
//        bounds.size.height = bounds.width / ratio;
//    }
//    else
//    {
//        bounds.size.height = kMaxResolution;
//        bounds.size.width = bounds.height * ratio;
//    }
//    }
//
//    let scaleRatio = bounds.width / width;
//
//    let imageSize = CGSize(width: width, height: height)
//    let orient = self.imageOrientation;
//    var boundHeight: CGFloat;
//
//    switch (orient)
//    {
//        case UIImageOrientation.up:                                        //EXIF = 1
//            transform = CGAffineTransform.identity
//            break;
//
//        case UIImageOrientation.upMirrored:                                //EXIF = 2
//            transform = CGAffineTransform(translationX: imageSize.width, y: 0)
//            transform = CGAffineTransform(scaleX: -1, y: 1)
//            break;
//
//        case UIImageOrientation.down:                                      //EXIF = 3
//            transform = CGAffineTransform(translationX: imageSize.width, y: imageSize.height)
//            transform = transform.rotated(by: CGFloat.pi)
//            break;
//
//        case UIImageOrientation.downMirrored:                              //EXIF = 4
//            transform = CGAffineTransform(translationX: 0, y: imageSize.height)
//            transform = CGAffineTransform(scaleX: 1, y: -1)
//            break;
//
//        case UIImageOrientation.leftMirrored:                              //EXIF = 5
//            boundHeight = bounds.height;
//            bounds.size.height = bounds.width;
//            bounds.size.width = boundHeight;
//            transform = CGAffineTransform(translationX: imageSize.height, y: imageSize.width)
//            transform = CGAffineTransform(scaleX: -1, y: 1)
//            transform = transform.rotated(by: 3 * CGFloat.pi / 2)
//            break;
//
//        case UIImageOrientation.left:                                      //EXIF = 6
//            boundHeight = bounds.height;
//            bounds.size.height = bounds.width;
//            bounds.size.width = boundHeight;
//            transform = CGAffineTransform(translationX: 0, y: imageSize.width)
//            transform = transform.rotated(by: 3 * CGFloat.pi / 2)
//            break;
//
//        case UIImageOrientation.rightMirrored:                             //EXIF = 7
//            boundHeight = bounds.height;
//            bounds.size.height = bounds.width;
//            bounds.size.width = boundHeight;
//            transform = CGAffineTransform(scaleX: -1, y: 1)
//            transform = transform.rotated(by: CGFloat.pi / 2)
//            break;
//
//        case UIImageOrientation.right:                                     //EXIF = 8
//            boundHeight = bounds.height;
//            bounds.size.height = bounds.width;
//            bounds.size.width = boundHeight;
//            transform = CGAffineTransform(translationX: imageSize.height, y: 0)
//            transform = transform.rotated(by: 3 * CGFloat.pi / 2)
//            break;
//    }
//
//    UIGraphicsBeginImageContext(bounds.size)
//    let context = UIGraphicsGetCurrentContext()
//
//    if (orient == UIImageOrientation.right || orient == UIImageOrientation.left) {
//        context?.scaleBy(x: -scaleRatio, y: scaleRatio)
//        context?.translateBy(x: -height, y: 0)
//    } else {
//        context?.scaleBy(x: scaleRatio, y: -scaleRatio)
//        context?.translateBy(x: 0, y: -height)
//    }
//    context?.concatenate(transform)
//    context?.draw(imgRef!, in: CGRect(x: 0, y: 0, width: width, height: height))
//
//    let imageCopy = UIGraphicsGetImageFromCurrentImageContext()
//    UIGraphicsEndImageContext()
//
//    return imageCopy!;
    }
}
