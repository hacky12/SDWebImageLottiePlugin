//
//  CompatibleAnimationView+WebCache.swift
//  SDWebImageLottiePlugin
//
//  Created by MyeongHoon IM on 2023/02/06.
//  Copyright © 2023 cocoapods. All rights reserved.
//

import SDWebImage
import Lottie

extension CompatibleAnimationView {

    @objc
    public func compatibleAnimationView() -> AnimationView? {
        let mirror = Mirror(reflecting: self)

        let animationView = mirror.descendant("animationView") as? AnimationView
        return animationView
    }

    @objc
    public func sd_setImage(with url: URL?, placeholderImage placeholder: PlatformImage? = nil, options: SDWebImageOptions = [], context: [SDWebImageContextOption : Any]? = nil, progress progressBlock: SDImageLoaderProgressBlock? = nil, completed completedBlock: SDExternalCompletionBlock? = nil) {
        var context = context ?? [:]
        context[.animatedImageClass] = LottieImage.self
        self.sd_internalSetImage(with: url, placeholderImage: placeholder, options: options, context: context, setImageBlock: { [weak self] (image, data, cacheType, url) in
            if let lottieImage = image as? LottieImage {
                self?.compatibleAnimationView()?.animation = lottieImage.animation
            } else {
                self?.compatibleAnimationView()?.animation = nil
            }
        }, progress: progressBlock) { (image, data, error, cacheType, finiseh, url) in
            completedBlock?(image, error, cacheType, url)
        }
    }
}
