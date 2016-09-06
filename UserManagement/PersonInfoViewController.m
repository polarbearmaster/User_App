//
//  PersonViewController.m
//  UserManagement
//
//  Created by kenny on 16/9/5.
//  Copyright © 2016年 polarbear. All rights reserved.
//

#import "PersonInfoViewController.h"

@interface PersonInfoViewController()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *birthdayLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;

- (IBAction)backButtonTapped:(id)sender;

@end

@implementation PersonInfoViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self display];
    
}

- (void)display {
    _nameLabel.text      =      _name;
    _emailLabel.text     =     _email;
    _birthdayLabel.text  =  _birthday;
    _createdAtLabel.text = _createdAt;
}

- (void)saveWithName:(NSString *)name withEmail:(NSString *)email withBirthday:(NSString *)birthday withCreatedAt:(NSString *)createdAt {
    _name = name;
    _email = email;
    _birthday = birthday;
    _createdAt = createdAt;
}


- (IBAction)backButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
