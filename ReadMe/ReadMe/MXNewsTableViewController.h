//
//  MXNewsTableViewController.h
//  ReadMe
//
//  Created by Michael on 12/6/15.
//  Copyright © 2015 Bokun Xu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MXNewsTableViewController : UITableViewController <NSXMLParserDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (copy, nonatomic) NSString *url;
@property (nonatomic, strong) NSMutableArray *favorites;

@end
