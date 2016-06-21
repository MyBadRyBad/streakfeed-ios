//
//  ModelHelper.h
//  onepagestreak
//
//  Created by Ryan Badilla on 6/20/16.
//  Copyright © 2016 rybad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelHelper : NSObject

+ (NSMutableArray *)streakTypesFromDictionaryArray:(NSArray *)array ;
+ (NSMutableArray *)photosFromDictionaryArray:(NSArray *)array;
+ (NSMutableArray *)locationsFromDictionaryArray:(NSArray *)array;

@end
