//
//  PersonViewController.h
//  UserManagement
//
//  Created by kenny on 16/9/5.
//  Copyright © 2016年 polarbear. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonInfoViewController : UIViewController

@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *birthday;
@property (nonatomic, copy) NSString *createdAt;


- (void)saveWithName:(NSString *)name
              withEmail:(NSString *)email
           withBirthday:(NSString *)birthday
          withCreatedAt:(NSString *)createdAt;
@end
