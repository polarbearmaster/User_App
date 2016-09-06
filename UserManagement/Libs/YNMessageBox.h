//
//  YNMessageBox.h
//  SkyViewS
//
//  Created by kenny on 16/8/1.
//  Copyright © 2016年 Gavin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    YNMessageBoxStyleClear,
    YNMessageBoxStyleGray,
    YNMessageBoxStyleRed,
    YNMessageBoxStyleBlue,
} YNMessageBoxStyle;

typedef void(^YNMessageBoxCallback)();

@interface YNMessageBox : NSObject

+ (YNMessageBox *)instance;
/**
 *  在屏幕中间显示提示消息， 默认2秒钟后消息自动消失
 *
 *  @param text 文本
 */
- (void)show:(NSString *)text;

@property (nonatomic, strong) YNMessageBoxCallback onClick;
@end
