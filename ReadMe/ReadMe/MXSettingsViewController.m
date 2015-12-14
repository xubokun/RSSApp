//
//  MXSettingsViewController.m
//  ReadMe
//
//  Created by Michael on 12/13/15.
//  Copyright © 2015 Bokun Xu. All rights reserved.
//

#import "MXSettingsViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface MXSettingsViewController ()

@end

@implementation MXSettingsViewController
- (IBAction)logOutButton:(id)sender {
    [[FBSDKLoginManager new] logOut];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
