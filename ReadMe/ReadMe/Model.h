//
//  Model.h
//  ReadMe
//
//  Created by Michael on 12/13/15.
//  Copyright © 2015 Bokun Xu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model : NSObject

- (NSUInteger) numberOfFavorites;
- (NSDictionary *) favoriteAtIndex: (NSUInteger) index;
- (void) removeFavoriteAtIndex: (NSUInteger) index;
- (void) insertFavorite: (NSString *) title
                 link: (NSString *) link
                atIndex: (NSUInteger) index;
+ (instancetype) sharedModel;

@end
