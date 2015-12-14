//
//  MXNewsTableViewController.m
//  ReadMe
//
//  Created by Michael on 12/6/15.
//  Copyright © 2015 Bokun Xu. All rights reserved.
//

#import "MXNewsTableViewController.h"
#import "MXWebViewController.h"
#import "Model.h"

@interface MXNewsTableViewController () {
    
    NSXMLParser *parser;
    NSMutableArray *feeds;
    NSMutableDictionary *item;
    NSMutableString *title;
    NSMutableString *link;
    NSString *element;
}
@property (strong, nonatomic) Model *model;

@end

@implementation MXNewsTableViewController
@synthesize favorites;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.model = [Model sharedModel];
    
    favorites = [[NSMutableArray alloc] init];
    
    feeds = [[NSMutableArray alloc] init];
   
    NSURL *url = [NSURL URLWithString:[self.url stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    
    parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return feeds.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = [[feeds objectAtIndex:indexPath.row] objectForKey:@"title"];
    cell.textLabel.text = [cell.textLabel.text substringToIndex:MIN(32, [cell.textLabel.text length])];
    
    //Create the button and add it to the cell
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self
               action:@selector(customActionPressed:)
     forControlEvents:UIControlEventTouchDown];
    [button setTitle:@"Save" forState:UIControlStateNormal];
    button.frame = CGRectMake(150.0f, 5.0f, 370.0f, 30.0f);
    [cell addSubview:button];
    
    return cell;
}

- (IBAction)customActionPressed:(id)sender {
    NSLog(@"Saved to favorites.");
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    UITableViewCell *selectedCell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSLog([[feeds objectAtIndex:indexPath.row] objectForKey:@"title"]);
    
    NSString *title = [[feeds objectAtIndex:indexPath.row] objectForKey:@"title"];
    NSString *link = [[feeds objectAtIndex:indexPath.row] objectForKey:@"link"];
    
//    NSDictionary *newsDict = @{
//                               @"title": title,
//                               @"link": link
//                               };
//    
//    [self.favorites addObject:newsDict];
//    NSLog(@"%@", self.favorites);
//    NSLog(@"%d", self.favorites.count);
    [self.model insertFavorite:title link:link atIndex:0];
    //NSLog(@"%lu", (unsigned long)[self.model numberOfFavorites]);
    
    
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict {
    
    element = elementName;
    if ([element isEqualToString:@"item"]) {
        item =[[NSMutableDictionary alloc] init];
        title = [[NSMutableString alloc] init];
        link = [[NSMutableString alloc] init];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {

    if ([elementName isEqualToString:@"item"]) {
        [item setObject:title forKey:@"title"];
        [item setObject:link forKey:@"link"];
        [feeds addObject:[item copy]];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    if ([element isEqualToString:@"title"]) {
        [title appendString:string];
    } else if ([element isEqualToString:@"link"]) {
        [link appendString:string];
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    [self.tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSString *url = [feeds[indexPath.row] objectForKey:@"link"];
        [[segue destinationViewController] setUrl:url];
    }
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
