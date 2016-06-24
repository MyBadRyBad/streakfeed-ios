//
//  RESTHelper.h
//  streakfeed
//
//  Created by Ryan Badilla on 6/20/16.
//  Copyright © 2016 rybad. All rights reserved.
//

#import <Foundation/Foundation.h>

/////////////////////////////
// block definitions
/////////////////////////////
typedef void (^CompletionWithDictionaryBlock)(NSDictionary *dictionary, NSError *error);
typedef void (^CompletionWithArrayBlock)(NSArray *array, NSError *error);

@interface RESTHelper : NSObject

//////////////////////////////////////////
// JSON Get request
//////////////////////////////////////////
+ (void)getStreakTypeModelsForDate:(NSDate *)date
                      onCompletion:(CompletionWithArrayBlock)onCompletion;

+ (void)getPhotosModelsForDate:(NSDate *)date
                  onCompletion:(CompletionWithArrayBlock)onCompletion;

+ (void)getLocationsModelsForDate:(NSDate *)date
                     onCompletion:(CompletionWithArrayBlock)onCompletion;

+ (void)getStreakCardDataModelsForDates:(NSArray *)datesArray
                           onCompletion:(CompletionWithArrayBlock)onCompletion;

+ (void)getDictionaryOfStreakCardsAndDateKeysForDates:(NSArray *)datesArray
                                         onCompletion:(CompletionWithDictionaryBlock)onCompletion;

@end
