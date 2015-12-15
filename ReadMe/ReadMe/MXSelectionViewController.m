//
//  MXSelectionViewController.m
//  ReadMe
//
//  Created by Michael on 12/12/15.
//  Copyright © 2015 Bokun Xu. All rights reserved.
//

#import "MXSelectionViewController.h"
#import "MXNewsTableViewController.h"

@interface MXSelectionViewController ()

@property (weak, nonatomic) IBOutlet UITableView *imageTable;

@end

@implementation MXSelectionViewController

@synthesize logoLinks;
@synthesize images;
@synthesize newsLinks;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Array of links to logo pictures
    logoLinks = @[@"http://purelifi.com/wp-content/uploads/2015/10/logo_wired.png", //wired
                  @"http://www.stackdriver.com/wp-content/uploads/customer-logos/techcrunch-logo.png", //techcrunch
                  @"https://upload.wikimedia.org/wikipedia/commons/7/77/The_New_York_Times_logo.png", //newyorktimes
                  @"https://upload.wikimedia.org/wikipedia/en/thumb/8/82/CNET.svg/1024px-CNET.svg.png", //cnet
                  @"http://static1.squarespace.com/static/54f5b878e4b02932b195baf4/54f742dce4b0d3690345d1a8/54f744d2e4b0b26b872ae204/1425491155228/Logo.jpg", //techworld
                  @"http://www.steveharveylaw.com/wp-content/uploads/2013/06/cnn-hd-logo-png-sk.png", //cnn
                  @"https://upload.wikimedia.org/wikipedia/commons/thumb/e/e4/BuzzFeed.svg/2000px-BuzzFeed.svg.png",
                  @"http://collegeforamerica.org/wp-content/uploads/2015/05/fox_news_logo_a_l3.png", //fox
                  @"https://upload.wikimedia.org/wikipedia/commons/thumb/c/c4/The_Wall_Street_Journal_Logo.svg/2000px-The_Wall_Street_Journal_Logo.svg.png", //wsj
                  @"https://healthyartists.files.wordpress.com/2013/09/huffington-post-icon.jpg", //huffington
                  @"https://s3.amazonaws.com/rapgenius/gq_logoredblack.jpg", //gq
                  @"https://upload.wikimedia.org/wikipedia/commons/2/23/Google-News_logo.png", //google
                  @"http://static.tumblr.com/54e5cf4bfb89f3d0693e59ff99573ade/xhawh4f/dwLn3iu62/tumblr_static_ign_com_no_chrome-1.png", //ign
                  @"https://upload.wikimedia.org/wikipedia/commons/3/3e/PC_Gamer_logo.jpg"];
    
    // Array of links to rss feed
    newsLinks = @[@"http://www.wired.com/category/gear/feed/",
                  @"http://feeds.feedburner.com/TechCrunch/",
                  @"http://rss.nytimes.com/services/xml/rss/nyt/Technology.xml",
                  @"http://www.cnet.com/rss/all/",
                  @"http://www.techworld.com/news/rss",
                  @"http://rss.cnn.com/rss/cnn_topstories.rss",
                  @"http://www.buzzfeed.com/community/justlaunched.xml",
                  @"http://feeds.foxnews.com/foxnews/latest?format=xml",
                  @"http://www.wsj.com/xml/rss/3_7455.xml",
                  @"http://www.huffingtonpost.com/feeds/news.xml",
                  @"http://www.gq.com/rss",
                  @"http://news.google.com/news?cf=all&hl=en&pz=1&ned=us&output=rss",
                  @"http://feeds.ign.com/ign/all?format=xml",
                  @"http://dynamic.feedsportal.com/pf/510578/http://www.pcgamer.com/feed/rss2/"];
    
    images = [[NSMutableArray alloc] init];
    
    [self startBackgroundTask];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

// Start executing background task method
- (void)startBackgroundTask {
    
    UIDevice *device = [UIDevice currentDevice];
    
    // check if device is multitask supported
    if (! [device isMultitaskingSupported]) {
        NSLog(@"Multitasking not supported on this device.");
        return;
    }
    
    dispatch_queue_t background = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(background, ^{
        [self performBackgroundTask];
    });
}

// Background Task Method
- (void)performBackgroundTask {
    NSInteger counter = 0;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    __block UIBackgroundTaskIdentifier bTask = [[UIApplication sharedApplication]
                                                beginBackgroundTaskWithExpirationHandler:^{
                                                    NSLog(@"Background Expiration Handler called.");
                                                    NSLog(@"Counter is: %ld, task ID is %lu.",(long)counter, (unsigned long)bTask);
                                                    bTask = UIBackgroundTaskInvalid;
                                                }];
    
    NSLog(@"Background task starting, task ID is %lu.",(unsigned long)bTask);
    for (counter = 0; counter<logoLinks.count; counter++) {
        [userDefaults synchronize];
        
        NSTimeInterval remainingTime = [[UIApplication sharedApplication] backgroundTimeRemaining];
        
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:logoLinks[counter]]]];
        
        // add images to our imagetable and insert rows 1 by 1
        dispatch_async(dispatch_get_main_queue(), ^{
            [_imageTable beginUpdates];
            [images addObject:image];
            [_imageTable insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:counter inSection:0]] withRowAnimation:UITableViewRowAnimationRight];
            [_imageTable endUpdates];
        });
        
        [NSThread sleepForTimeInterval:3];
        
        //NSLog(@"Background Processed %ld. Time remaining is: %f", (long)counter, remainingTime);
        
    }
    
    NSLog(@"Background Completed tasks");
    
    [userDefaults synchronize];
    
    [[UIApplication sharedApplication] endBackgroundTask:bTask];
    
    bTask = UIBackgroundTaskInvalid;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // return images object count
    return images.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // populate rows with logo images
    cell.imageView.image = [images objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    // prepare for segue to web view
    
    if ([[segue identifier] isEqualToString:@"selected"]) {
        NSIndexPath *indexPath = [self.imageTable indexPathForSelectedRow];
        NSString *link = newsLinks[indexPath.row];
        [[segue destinationViewController] setUrl:link];
    }
    
}

@end























