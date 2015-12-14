//
//  MXFavoritesViewController.m
//  ReadMe
//
//  Created by Michael on 12/13/15.
//  Copyright © 2015 Bokun Xu. All rights reserved.
//

#import "MXFavoritesViewController.h"
#import "MXNewsTableViewController.h"
#import "Model.h"

@interface MXFavoritesViewController ()
@property (strong, nonatomic) Model *model;

@end

@implementation MXFavoritesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.model = [Model sharedModel];
    
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self.favoritesTableView reloadData];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.model numberOfFavorites];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = @"favorite";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *favoriteAtIndex = [self.model favoriteAtIndex:indexPath.row];
    NSString *title = favoriteAtIndex[@"title"];
    //NSString *link  = favoriteAtIndex[@"link"];
    
    cell.textLabel.text = title;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete from the model
        [self.model removeFavoriteAtIndex:indexPath.row];
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.favoritesTableView indexPathForSelectedRow];
        
        NSDictionary *favoriteAtIndex = [self.model favoriteAtIndex:indexPath.row];
        NSString *title = favoriteAtIndex[@"link"];
        
        NSString *url = title;
        [[segue destinationViewController] setUrl:url];
    }
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


























