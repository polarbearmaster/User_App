//
//  RegisterViewController.m
//  UserManagement
//
//  Created by kenny on 16/9/5.
//  Copyright © 2016年 polarbear. All rights reserved.
//

#import "RegisterViewController.h"
#import "HomeViewController.h"

#import "MBProgressHUD.h"
#import "YNMessageBox.h"

#define REGISTERURL @"http://121.43.120.75/resources/Users/v1/register"

@interface RegisterViewController()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *birthdayTextField;
- (IBAction)registerButtonTapped:(id)sender;
- (IBAction)backButtonTapped:(id)sender;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)registerUser {
    if ( [_emailTextField.text isEqualToString:@""] ||
         [_passwordTextField.text isEqualToString:@""] ||
         [_nameTextField.text isEqualToString:@""] ||
         [_birthdayTextField.text isEqualToString:@""] ) {
        return;
    }
    
    NSURL *URL = [NSURL URLWithString:REGISTERURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request addValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    
    NSString *noteDataString = [NSString stringWithFormat:@"email=%@&password=%@&name=%@&birthday=%@", _emailTextField.text, _passwordTextField.text, _nameTextField.text, _birthdayTextField.text];
    request.HTTPBody = [noteDataString dataUsingEncoding:NSUTF8StringEncoding];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self)bSelf = self;
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        
        BOOL success = NO;
        
        if (!error && ((NSHTTPURLResponse *)response).statusCode == 201) {            
            NSError *jsonError;
            
            NSMutableDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
            if (jsonDict[@"error"] == [NSNumber numberWithBool:NO]) {
                 success = YES;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [[YNMessageBox instance] show:jsonDict[@"message"]];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[YNMessageBox instance] show:[NSString stringWithFormat:@"errcode: %li", (long)((NSHTTPURLResponse *)response).statusCode]];
            });
        }
        
        if (success) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [bSelf performSegueWithIdentifier:@"registerHomeSegue" sender:self];
            });
        }
    }];
    
    [task resume];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[HomeViewController class]]) {
        HomeViewController *homeVC = segue.destinationViewController;
        [homeVC setMessage:[NSString stringWithFormat:@"欢迎 %@!", _nameTextField.text]];
    }
}

//MARK: UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)registerButtonTapped:(id)sender {
    [self registerUser];
}

- (IBAction)backButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
