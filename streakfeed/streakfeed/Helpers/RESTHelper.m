//
//  RESTHelper.m
//  streakfeed
//
//  Created by Ryan Badilla on 6/20/16.
//  Copyright © 2016 rybadilla. All rights reserved.
//

#import "RESTHelper.h"
#import <AFNetworking.h>
#import <NSDate+Helper.h>
#import "ModelHelper.h"
#import "kRESTConstants.h"
#import "StreakCardModel.H"


#define SERVER_URL          @"http://spire-challenge.herokuapp.com"
#define ENDPOINT_STREAK     @"/streaks/"
#define ENDPOINT_PHOTOS     @"/photos/"
#define ENDPOINT_LOCATION   @"/locations/"

@interface RESTHelper()

@end

@implementation RESTHelper

#pragma mark -
#pragma mark - get json data - Models
+ (void)getStreakTypeModelsForDate:(NSDate *)date
                      onCompletion:(CompletionWithArrayBlock)onCompletion {
    [self getStreakTypeDictionariesForDate:date onCompletion:^(NSArray *array, NSError *error) {
        onCompletion((!error && array) ? [ModelHelper streakTypesFromDictionaryArray:array] : array, error);
    }];
}
+ (void)getPhotosModelsForDate:(NSDate *)date
                  onCompletion:(CompletionWithArrayBlock)onCompletion {
    [self getPhotosDictionariesForDate:date onCompletion:^(NSArray *array, NSError *error) {
        onCompletion((!error && array) ? [ModelHelper photosFromDictionaryArray:array] : array, error);
    }];
}
+ (void)getLocationsModelsForDate:(NSDate *)date
                     onCompletion:(CompletionWithArrayBlock)onCompletion {
    [self getLocationsDictionariesForDate:date onCompletion:^(NSArray *array, NSError *error) {
        onCompletion((!error && array) ? [ModelHelper locationsFromDictionaryArray:array] : array, error);
    }];
}

+ (void)getStreakCardDataModelsForDates:(NSArray *)datesArray
                           onCompletion:(CompletionWithArrayBlock)onCompletion {
    [self getStreakCardDictionariesForDates:datesArray onCompletion:^(NSArray *array, NSError *error) {
        if (!error) {
            NSMutableArray *cardArray = [NSMutableArray new];
            
            // get an array of valid streak card data
            for (NSDictionary *dictionary in array) {
                NSMutableArray * currentCardArray =
                [ModelHelper streakCardsFromStreakTypeDictionaryArray:dictionary[kRESTStreakKey]
                                             locationsDictionaryArray:dictionary[kRESTLocationKey]
                                                photosDictionaryArray:dictionary[kRESTPhotoKey]];
                
                if (currentCardArray) {
                    [cardArray addObjectsFromArray:currentCardArray];
                }
            }
            
            onCompletion(cardArray, error);
        } else {
            onCompletion(nil, error);
        }
    }];
}

+ (void)getDictionaryOfStreakCardsAndDateKeysForDates:(NSArray *)datesArray
                                         onCompletion:(CompletionWithDictionaryBlock)onCompletion {
    NSMutableDictionary __block *dataDictionary = [NSMutableDictionary new];
    NSError __block *dataError = nil;
    
    dispatch_group_t streakGroup = dispatch_group_create();
    
    for (NSDate *date in datesArray) {
        dispatch_group_enter(streakGroup);
        [self getStreakCardDictionaryDataForDate:date
                                    onCompletion:^(NSDictionary *dictionary, NSError *error) {
                                        if (!error) {
                                            if (dictionary) {
                                                NSMutableArray * currentCardArray =
                                                [ModelHelper streakCardsFromStreakTypeDictionaryArray:dictionary[kRESTStreakKey]
                                                                             locationsDictionaryArray:dictionary[kRESTLocationKey]
                                                                                photosDictionaryArray:dictionary[kRESTPhotoKey]];
                                                [dataDictionary setObject:currentCardArray forKey:[date string]];
                                            }
                                        } else {
                                            if (!dataError) dataError = error;
                                        }
                                        
                                        dispatch_group_leave(streakGroup);
                                    }];
    }
    
    dispatch_group_notify(streakGroup, dispatch_get_main_queue(), ^{
        onCompletion(dataDictionary, dataError);
    });
}

#pragma mark - 
#pragma mark - get json data - dictionary
+ (void)getStreakTypeDictionariesForDate:(NSDate *)date
                            onCompletion:(CompletionWithArrayBlock)onCompletion {
    NSString *utcString = [NSString stringWithFormat: @"%ld", [date utcTimeStamp]];
    NSString *baseStreakURL = [NSString stringWithFormat:@"%@%@", SERVER_URL, ENDPOINT_STREAK];
    NSString *fullURL = [NSString stringWithFormat:@"%@%@", baseStreakURL, utcString];
    
    [self requestDataFromURL:fullURL
                  httpMethod:@"GET"
                onCompletion:^(NSArray *array, NSError *error) {
                    onCompletion(array, error);
                }];
}

+ (void)getPhotosDictionariesForDate:(NSDate *)date
                        onCompletion:(CompletionWithArrayBlock)onCompletion {
    NSString *utcString = [NSString stringWithFormat: @"%ld", [date utcTimeStamp]];
    NSString *baseStreakURL = [NSString stringWithFormat:@"%@%@", SERVER_URL, ENDPOINT_PHOTOS];
    NSString *fullURL = [NSString stringWithFormat:@"%@%@", baseStreakURL, utcString];
    
    [self requestDataFromURL:fullURL
                  httpMethod:@"GET"
                onCompletion:^(NSArray *array, NSError *error) {
                    onCompletion(array, error);
    }];
}

+ (void)getLocationsDictionariesForDate:(NSDate *)date
                           onCompletion:(CompletionWithArrayBlock)onCompletion {
    NSString *utcString = [NSString stringWithFormat: @"%ld", [date utcTimeStamp]];
    NSString *baseStreakURL = [NSString stringWithFormat:@"%@%@", SERVER_URL, ENDPOINT_LOCATION];
    NSString *fullURL = [NSString stringWithFormat:@"%@%@", baseStreakURL, utcString];
    
    [self requestDataFromURL:fullURL
                  httpMethod:@"GET"
                onCompletion:^(NSArray *array, NSError *error) {
                    onCompletion(array, error);
                }];
}

+ (void)getStreakCardDictionariesForDates:(NSArray *)datesArray
                           onCompletion:(CompletionWithArrayBlock)onCompletion {
    NSMutableArray __block *dataArray = [NSMutableArray new];
    NSError __block *dataError = nil;
    
    dispatch_group_t streakGroup = dispatch_group_create();
    
    for (NSDate *date in datesArray) {
        dispatch_group_enter(streakGroup);
        [self getStreakCardDictionaryDataForDate:date
                                    onCompletion:^(NSDictionary *dictionary, NSError *error) {
                                        if (!error) {
                                            if (dictionary) [dataArray addObject:dictionary];
                                        } else {
                                            if (!dataError) dataError = error;
                                        }
                                        
                                        dispatch_group_leave(streakGroup);
                                    }];
    }
    
    dispatch_group_notify(streakGroup, dispatch_get_main_queue(), ^{
        onCompletion(dataArray, dataError);
    });
}

+ (void)getStreakCardDictionaryDataForDate:(NSDate *)date
                    onCompletion:(CompletionWithDictionaryBlock)onCompletion {
    NSMutableDictionary *dataDictionary = [NSMutableDictionary new];
    NSError __block *dataError;
    
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    [self getStreakTypeDictionariesForDate:date onCompletion:^(NSArray *array, NSError *error) {
        if (!error) {
            if (array) [dataDictionary setObject:array forKey:kRESTStreakKey];
        } else {
            if (!dataError) dataError = error;
        }
        
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    [self getPhotosDictionariesForDate:date onCompletion:^(NSArray *array, NSError *error) {
        if (!error) {
            if (array) [dataDictionary setObject:array forKey:kRESTPhotoKey];
        } else {
            if (!dataError) dataError = error;
        }
        
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    [self getLocationsDictionariesForDate:date onCompletion:^(NSArray *array, NSError *error) {
        if (!error) {
            [dataDictionary setObject:array forKey:kRESTLocationKey];
        } else {
            if (!dataError) dataError = error;
        }
        
        dispatch_group_leave(group);
    }];
    
    
    // Wait for requests to finish
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        onCompletion(dataDictionary, dataError);
    });
}


#pragma mark -
#pragma mark - generic request
+ (void)requestDataFromURL:(NSString *)url
                httpMethod:(NSString *)httpMethod
              onCompletion:(CompletionWithArrayBlock)onCompletion {

    // Create manager
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:httpMethod
                                                                                 URLString:url
                                                                                parameters:nil
                                                                                     error:nil];
    // Fetch Request
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"NSURLSessionDataTask Error: %@", error);
            
        } else {
            NSLog(@"%@ %@", response, responseObject);
            
            NSArray *responseArray = (NSArray *)responseObject;
            onCompletion(responseArray, nil);
        }
    }];
    
    [dataTask resume];
}

@end
