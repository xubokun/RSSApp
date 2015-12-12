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
    
    logoLinks = @[@"http://purelifi.com/wp-content/uploads/2015/10/logo_wired.png", //wired
                  @"http://www.stackdriver.com/wp-content/uploads/customer-logos/techcrunch-logo.png", //techcrunch
                  @"https://upload.wikimedia.org/wikipedia/commons/7/77/The_New_York_Times_logo.png", //newyorktimes
                  @"https://upload.wikimedia.org/wikipedia/en/thumb/8/82/CNET.svg/1024px-CNET.svg.png", //cnet
                  @"http://static1.squarespace.com/static/54f5b878e4b02932b195baf4/54f742dce4b0d3690345d1a8/54f744d2e4b0b26b872ae204/1425491155228/Logo.jpg", //techworld
                  @"http://www.steveharveylaw.com/wp-content/uploads/2013/06/cnn-hd-logo-png-sk.png", //cnn
                  @"https://upload.wikimedia.org/wikipedia/commons/thumb/e/e4/BuzzFeed.svg/2000px-BuzzFeed.svg.png"];
                  
    newsLinks = @[@"http://www.wired.com/category/gear/feed/",
                  @"http://feeds.feedburner.com/TechCrunch/",
                  @"http://rss.nytimes.com/services/xml/rss/nyt/Technology.xml",
                  @"http://www.cnet.com/rss/all/",
                  @"http://www.techworld.com/news/rss",
                  @"http://rss.cnn.com/rss/cnn_topstories.rss",
                  @"http://www.buzzfeed.com/community/justlaunched.xml"];
    
    images = [[NSMutableArray alloc] init];
    
    [self startBackgroundTask];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)startBackgroundTask {
    
    UIDevice *device = [UIDevice currentDevice];
    
    if (! [device isMultitaskingSupported]) {
        NSLog(@"Multitasking not supported on this device.");
        return;
    }
    
    dispatch_queue_t background = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(background, ^{
        [self performBackgroundTask];
    });
}

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
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_imageTable beginUpdates];
            [images addObject:image];
            [_imageTable insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:counter inSection:0]] withRowAnimation:UITableViewRowAnimationRight];
            [_imageTable endUpdates];
        });
        
        [NSThread sleepForTimeInterval:3];
        
        NSLog(@"Background Processed %ld. Time remaining is: %f", (long)counter, remainingTime);
        
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
    return images.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    //cell.textLabel.text = [logoLinks objectAtIndex:indexPath.row];
    
    cell.imageView.image = [images objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"selected"]) {
        NSIndexPath *indexPath = [self.imageTable indexPathForSelectedRow];
        NSString *link = newsLinks[indexPath.row];
        [[segue destinationViewController] setUrl:link];
    }
    
}

@end























