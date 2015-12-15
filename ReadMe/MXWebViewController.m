//
//  MXWebViewController.m
//  ReadMe
//
//  Created by Michael on 12/7/15.
//  Copyright © 2015 Bokun Xu. All rights reserved.
//

#import "MXWebViewController.h"

@interface MXWebViewController ()

@end

@implementation MXWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSURL *URL = [NSURL URLWithString:[self.url stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    
    // load request with url given from previous views
    
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    [self.webView loadRequest:request];
    
    // add webview subview
    
    [self.webView addSubview:ActInd];
    timer = [NSTimer scheduledTimerWithTimeInterval:(1.0/2.0) target:self selector:@selector(loading) userInfo:nil repeats:YES];
    
}

// activity indicator loading animation
- (void)loading {
    
    if (!self.webView.loading) {
        [ActInd stopAnimating];
    } else {
        [ActInd startAnimating];
    }
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







































