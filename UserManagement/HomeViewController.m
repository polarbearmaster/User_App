//
//  HomeViewController.m
//  UserManagement
//
//  Created by kenny on 16/9/6.
//  Copyright © 2016年 polarbear. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController()
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@end

@implementation HomeViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_message && ![_message isEqualToString:@""]) {
        [self showMessage:_message];
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _message = nil;
}

- (void)showMessage:(NSString *)message {
    _messageLabel.text = message;
}

@end
