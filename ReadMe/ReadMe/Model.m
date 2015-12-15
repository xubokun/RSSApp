//
//  Model.m
//  ReadMe
//
//  Created by Michael on 12/13/15.
//  Copyright © 2015 Bokun Xu. All rights reserved.
//

#import "Model.h"
#import <Parse/Parse.h>

@interface Model ()

@property (strong, nonatomic) NSMutableArray *favorites;

@end

@implementation Model


// initialize instance
- (instancetype)init {
    if (self) {
        if (!_favorites) {
            _favorites = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

// get number of news objects in Favorites Array
- (NSUInteger) numberOfFavorites {
    return [self.favorites count];
}

// get current news object
- (NSDictionary *) favoriteAtIndex: (NSUInteger) index {
    return [self.favorites objectAtIndex:index];
}

// remove favorite object
- (void) removeFavoriteAtIndex: (NSUInteger) index {
    if (index < self.favorites.count) {
        [self.favorites removeObjectAtIndex:index];
    }
}

// add favorite object with title and link
- (void) insertFavorite: (NSString *) title link: (NSString *) link atIndex: (NSUInteger) index {
    if (index <= self.favorites.count) {
        NSDictionary *quoteDict = @{
                                    @"title":title,
                                    @"link":link
                                    };
        [self.favorites insertObject: quoteDict atIndex:index];
    }
}

// singleton shared model
+ (instancetype) sharedModel {
    static Model *_sharedModel = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // code to be executed once - thread safe version
        _sharedModel = [[self alloc] init];
    });
    return _sharedModel;
}

@end
