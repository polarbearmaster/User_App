//
//  ViewController.m
//  UserManagement
//
//  Created by kenny on 16/9/1.
//  Copyright © 2016年 polarbear. All rights reserved.
//

#import "LoginViewController.h"
#import "PersonInfoViewController.h"
#import "RegisterViewController.h"

#import "MBProgressHUD.h"
#import "YNMessageBox.h"

#define LOGINURL @"http://121.43.120.75/resources/Users/v1/login"

@interface LoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

- (IBAction)loginButtonTapped:(id)sender;
- (IBAction)backButtonTapped:(id)sender;

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *email;
@property (copy, nonatomic) NSString *birthday;
@property (copy, nonatomic) NSString *createdAt;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)login {
    if ([_emailTextField.text isEqualToString:@""] || [_passwordTextField.text isEqualToString:@""]) {
        return;
    }
    
    NSURL *URL = [NSURL URLWithString:LOGINURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request addValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    
    NSString *noteDataString = [NSString stringWithFormat:@"email=%@&password=%@", _emailTextField.text, _passwordTextField.text];
    request.HTTPBody = [noteDataString dataUsingEncoding:NSUTF8StringEncoding];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        
        BOOL success = NO;
        NSMutableDictionary *jsonDict = nil;
        
        if (!error && ((NSHTTPURLResponse *)response).statusCode == 200) {
            NSError *jsonError;
            
           jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
            
            if (jsonDict[@"error"] == [NSNumber numberWithBool:NO]) {
                success = YES;
            }
        }
        
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                _email = jsonDict[@"email"];
                _name = jsonDict[@"name"];
                _birthday = jsonDict[@"birthday"];
                _createdAt = jsonDict[@"created_at"];
                
                [self performSegueWithIdentifier:@"loginPersonInfoSegue" sender:self];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[YNMessageBox instance] show:@"登录失败"];
            });
        }
    }];
    
    [task resume];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[PersonInfoViewController class]]) {
        PersonInfoViewController *personInfoVC = segue.destinationViewController;
        
        [personInfoVC saveWithName:_name withEmail:_email withBirthday:_birthday withCreatedAt:_createdAt];
        
    }
}

//MARK: UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)loginButtonTapped:(id)sender {
    [self login];
}

- (IBAction)backButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
