//
//  YNMessageBox.m
//  SkyViewS
//
//  Created by kenny on 16/8/1.
//  Copyright © 2016年 Gavin. All rights reserved.
//

#import "YNMessageBox.h"
#import "AppDelegate.h"

static YNMessageBox * sharedInstance = nil;
#define kAnimateDuration 2.0f
#define UIColorWithRGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define SCREENWIDTH     [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT     [UIScreen mainScreen].bounds.size.height


@interface YNMessageBox()

@property (nonatomic, strong) UILabel *warningLabel;
@property (assign, nonatomic) YNMessageBoxStyle style;

@end
@implementation YNMessageBox

+(YNMessageBox *)instance {
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        sharedInstance = [[self alloc]init];
    });
    
    return sharedInstance;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self initWarningBar];
    }
    return self;
}

- (void)setStyle:(YNMessageBoxStyle)style {
    _style = style;
    switch (_style) {
        case YNMessageBoxStyleClear:
            [self.warningLabel setBackgroundColor:[UIColor clearColor]];
            break;
        case YNMessageBoxStyleGray:
            [self.warningLabel setBackgroundColor:UIColorWithRGB(7, 73, 94)];
            break;
        case YNMessageBoxStyleRed:
            [self.warningLabel setBackgroundColor:UIColorWithRGB(232, 115, 112)];
            break;
        case YNMessageBoxStyleBlue:
            [self.warningLabel setBackgroundColor:UIColorWithRGB(141, 201, 240)];
            break;
        default:
            break;
    }
}

-(void)show:(NSString *)text {
    [self show:text dismissing:YES];
}

-(void)show:(NSString *)text dismissing:(BOOL)dismissing {
    [self show:text style:YNMessageBoxStyleBlue dismissing:dismissing];
}

- (void)show:(NSString *)text style:(YNMessageBoxStyle)style dismissing:(BOOL)dismissing {
    [self addWarningLabel];
    self.style = style;
    [self warningMessage:text dismissing:dismissing];
    self.onClick = nil;
}

-(void)initWarningBar {
    self.warningLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, -50, SCREENWIDTH, 50)];
    [self.warningLabel setTextColor:[UIColor whiteColor]];
    [self.warningLabel setTextAlignment:NSTextAlignmentCenter];
    
    self.warningLabel.userInteractionEnabled = YES;
    self.warningLabel.preferredMaxLayoutWidth = SCREENWIDTH;
    self.warningLabel.numberOfLines = 0;
    self.warningLabel.font = [UIFont fontWithName:@"Helvetica" size:16.0];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(warningLabelTap:)];
    [self.warningLabel addGestureRecognizer:tap];
}

-(void)addWarningLabel {
    AppDelegate *delegate=[UIApplication sharedApplication].delegate;
    self.warningLabel.frame = CGRectMake(0, 0, SCREENWIDTH, 50);
    self.warningLabel.alpha = 1.0;
    [delegate.window addSubview:_warningLabel];
}

- (void)warningMessage:(NSString *)msg dismissing:(BOOL)dismissing {
    self.warningLabel.text = msg;
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideWarningBar) object:nil];
    
    if (dismissing) {
        [UIView animateWithDuration:kAnimateDuration
                         animations:^{
                             self.warningLabel.frame = CGRectMake(0, -50, SCREENWIDTH, 50);
                             //self.warningLabel.alpha = 0.0;
                         }
                         completion:^(BOOL finished) {
                             [_warningLabel removeFromSuperview];
                         }];
    }
}

- (void)hideWarningBar {
    [UIView animateWithDuration:kAnimateDuration
                     animations:^{
                         self.warningLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, -50, SCREENWIDTH, 50)];
                     }
                     completion:^(BOOL finished) {
                         [self.warningLabel removeFromSuperview];
                     }];
}

#pragma mark - Gesture
- (void)warningLabelTap:(UITapGestureRecognizer *)tap {
    if (tap.state == UIGestureRecognizerStateRecognized) {
        if (self.onClick) {
            self.onClick();
            self.onClick = nil;
            
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideWarningBar) object:nil];
            [self hideWarningBar];
        }
    }
}

@end
