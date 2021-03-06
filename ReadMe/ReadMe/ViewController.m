//
//  ViewController.m
//  ReadMe
//
//  Created by Michael on 12/6/15.
//  Copyright © 2015 Bokun Xu. All rights reserved.
//

#import "ViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <Parse/Parse.h>

@interface ViewController () <FBSDKLoginButtonDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // facebook login button and get read permission for profile, email, and friends
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    loginButton.center = CGPointMake(190, 500);
    loginButton.delegate = self;
    loginButton.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    
    // add loginButton to view
    [self.view addSubview:loginButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error {
    
    // no error, get user name, email, and picture
    if (error == nil) {
        if ([FBSDKAccessToken currentAccessToken]) {
            [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{ @"fields" : @"id,name,email,picture.width(100).height(100)"}]startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                
                // get uer name and email, check if user already created in Parse, if not add new user to Parse 
                if (!error) {
                    NSString *nameOfLoginUser = [result valueForKey:@"name"];
                    NSString *emailOfLoginUser = [result valueForKey:@"email"];
                    NSLog(@"%@", nameOfLoginUser);
                    NSLog(@"%@", emailOfLoginUser);
                    
                    PFQuery *query = [PFQuery queryWithClassName:@"Users"];
                    [query whereKey:@"email" equalTo:emailOfLoginUser];
                    NSArray *emailArray = [query findObjects];
                    
                    NSLog(@"%@", emailArray);
                    
                    if (emailArray.count > 0) {
                        NSLog(@"User already exists");
                    } else {
                        NSLog(@"Create new user");
                        PFObject *user = [PFObject objectWithClassName:@"Users"];
                        user[@"name"] = nameOfLoginUser;
                        user[@"email"] = emailOfLoginUser;
                        [user saveInBackground];
                    }
                }
            }];
        }
    
        NSLog(@"Login complete");
        [self performSegueWithIdentifier:@"login" sender:self];
    } else {
        NSLog(@"Login error");
    }
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
    NSLog(@"User logged out");
}

@end
































