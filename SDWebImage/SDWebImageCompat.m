//
//  SDWebImageCompat.m
//  SDWebImage
//
//  Created by Olivier Poitrey on 11/12/12.
//  Copyright (c) 2012 Dailymotion. All rights reserved.
//

#import "SDWebImageCompat.h"

// __has_feature(objc_arc) 是否启用arc
#if !__has_feature(objc_arc)
// SDWebImage仅限ARC. 启用“ARC”或使用-fobjc-arc
#error SDWebImage is ARC only. Either turn on ARC for the project or use -fobjc-arc flag
#endif

// 内联函数  SDScaledImageForKey 缩放图片的key,key就是图片名
inline UIImage *SDScaledImageForKey(NSString *key, UIImage *image) {
    if (!image) {
        return nil;
    }
    // image是图片数组就会进判断,注意不是gif
    if ([image.images count] > 0) {
        // 缩放的图片数组
        NSMutableArray *scaledImages = [NSMutableArray array];
        
        for (UIImage *tempImage in image.images) {
            // 递归的方式一次添加到缩放图片的数组里面
            [scaledImages addObject:SDScaledImageForKey(key, tempImage)];
        }
        // 返回提供的图片数组,并且含有动画时间,默认是0(gif图)
        return [UIImage animatedImageWithImages:scaledImages duration:image.duration];
    }
    else {
        // 屏幕如果响应这个scale方法,就走里代码
        if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
            // 用这个scale值根据手机不同屏幕的像素点,加载不同比例的图片.
            CGFloat scale = 1;
            if (key.length >= 8) {
                // 名字的key有@2x.字符串
                NSRange range = [key rangeOfString:@"@2x."];
                if (range.location != NSNotFound) {
                    scale = 2.0;
                }
                // 名字的key有@3x.字符串
                range = [key rangeOfString:@"@3x."];
                if (range.location != NSNotFound) {
                    scale = 3.0;
                }
            }
            // 初始化图片
            UIImage *scaledImage = [[UIImage alloc] initWithCGImage:image.CGImage scale:scale orientation:image.imageOrientation];
            image = scaledImage;
        }
        return image;
    }
}

NSString *const SDWebImageErrorDomain = @"SDWebImageErrorDomain";
