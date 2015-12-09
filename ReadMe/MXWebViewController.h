//
//  MXWebViewController.h
//  ReadMe
//
//  Created by Michael on 12/7/15.
//  Copyright © 2015 Bokun Xu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MXWebViewController : UIViewController {
    
    IBOutlet UIActivityIndicatorView *ActInd;
    NSTimer *timer;
    
}

@property (copy, nonatomic) NSString *url;
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end





















