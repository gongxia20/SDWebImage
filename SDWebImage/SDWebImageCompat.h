/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 * (c) Jamie Pinkham
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 * 做适配的类
 */

#import <TargetConditionals.h>

#ifdef __OBJC_GC__
// SDWebImage不支持垃圾回收机制,autorelease,release,retain,dealloc方法都将被系统忽略
#error SDWebImage does not support Objective-C Garbage Collection
#endif

// __IPHONE_OS_VERSION_MIN_REQUIRED app支持的最低版本,宏值不等于20000, 低于5.0
#if __IPHONE_OS_VERSION_MIN_REQUIRED != 20000 && __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_5_0
// 不支持5.0以下的版本
#error SDWebImage doesn't support Deployment Target version < 5.0
#endif

// TARGET_OS_IPHONE 苹果设备  TARGET_IPHONE_SIMULATOR 模拟器
#if !TARGET_OS_IPHONE
#import <AppKit/AppKit.h>
#ifndef UIImage
#define UIImage NSImage
#endif
#ifndef UIImageView
#define UIImageView NSImageView
#endif
#else

#import <UIKit/UIKit.h>

#endif

#ifndef NS_ENUM
#define NS_ENUM(_type, _name) enum _name : _type _name; enum _name : _type
#endif

#ifndef NS_OPTIONS
#define NS_OPTIONS(_type, _name) enum _name : _type _name; enum _name : _type
#endif

// OS_OBJECT_USE_OBJC: GCD在6.0之前不参与ARC,需要手动管理GCD释放的对象.ARC是5.0就出来了
// 要支持低版本,就需要写.
#if OS_OBJECT_USE_OBJC
    #undef SDDispatchQueueRelease
    #undef SDDispatchQueueSetterSementics
    #define SDDispatchQueueRelease(q)
    #define SDDispatchQueueSetterSementics strong
#else
#undef SDDispatchQueueRelease
#undef SDDispatchQueueSetterSementics
#define SDDispatchQueueRelease(q) (dispatch_release(q))
#define SDDispatchQueueSetterSementics assign
#endif

// 提供改外部的图片函数
extern UIImage *SDScaledImageForKey(NSString *key, UIImage *image);
// 声明了返回值为void的block. block名字:SDWebImageNoParamsBlock(没参数的block)
typedef void(^SDWebImageNoParamsBlock)();
// 图片错误域字符串
extern NSString *const SDWebImageErrorDomain;

// 保证线程安全的两个宏
#define dispatch_main_sync_safe(block)\
    if ([NSThread isMainThread]) {\
        block();\
    } else {\
        dispatch_sync(dispatch_get_main_queue(), block);\
    }

#define dispatch_main_async_safe(block)\
    if ([NSThread isMainThread]) {\
        block();\
    } else {\
        dispatch_async(dispatch_get_main_queue(), block);\
    }
