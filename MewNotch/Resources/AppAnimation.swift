//
//  AppAnimation.swift
//  MewNotch
//
//  Created by Monu Kumar on 27/02/25.
//

import Lottie

enum AppAnimation {
    static var brightness: LottieAnimation? {
        LottieAnimation.named("Brightness.json", animationCache: DefaultAnimationCache.sharedCache)
    }

    static var speaker: LottieAnimation? {
        LottieAnimation.named("Speaker.json", animationCache: DefaultAnimationCache.sharedCache)
    }

    static var visualizer: LottieAnimation? {
        LottieAnimation.named("Visualizer.json", animationCache: DefaultAnimationCache.sharedCache)
    }

    static var lock: LottieAnimation? {
        LottieAnimation.named("Lock.json", animationCache: DefaultAnimationCache.sharedCache)
    }
}
