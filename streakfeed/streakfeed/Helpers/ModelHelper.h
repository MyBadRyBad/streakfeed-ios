//
//  ModelHelper.h
//  streakfeed
//
//  Created by Ryan Badilla on 6/20/16.
//  Copyright © 2016 rybadilla. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelHelper : NSObject

+ (NSMutableArray *)streakTypesFromDictionaryArray:(NSArray *)array;
+ (NSMutableArray *)photosFromDictionaryArray:(NSArray *)array;
+ (NSMutableArray *)locationsFromDictionaryArray:(NSArray *)array;

+ (NSMutableArray *)streakCardsFromStreakTypeDictionaryArray:(NSArray *)streakTypeArray
                                    locationsDictionaryArray:(NSArray *)locationsArray
                                       photosDictionaryArray:(NSArray *)photosArray;

@end
