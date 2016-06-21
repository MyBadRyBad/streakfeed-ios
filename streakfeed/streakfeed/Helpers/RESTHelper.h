//
//  RESTHelper.h
//  onepagestreak
//
//  Created by Ryan Badilla on 6/18/16.
//  Copyright © 2016 rybad. All rights reserved.
//

#import <Foundation/Foundation.h>

/////////////////////////////
// block definitions
/////////////////////////////
typedef void (^CompletionWithDictionaryBlock)(NSDictionary *dictionary, NSError *error);
typedef void (^CompletionWithArrayBlock)(NSArray *array, NSError *error);

@interface RESTHelper : NSObject


// JSON Get request
+ (void)getPhotosForDate:(NSDate *)date onCompletion:(CompletionWithArrayBlock)onCompletion;
+ (void)getStreaksForDate:(NSDate *)date onCompletion:(CompletionWithArrayBlock)onCompletion;
+ (void)getLocationsForDate:(NSDate *)date onCompletion:(CompletionWithArrayBlock)onCompletion;

+ (void)getDataForDates:(NSArray *)datesArray onCompletion:(CompletionWithArrayBlock)onCompletion;
+ (void)getDataForDate:(NSDate *)date onCompletion:(CompletionWithDictionaryBlock)onCompletion;
@end
