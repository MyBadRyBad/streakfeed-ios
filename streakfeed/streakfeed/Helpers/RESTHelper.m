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

+ (void)getFullStreakDataModelsForDates:(NSArray *)datesArray
                           onCompletion:(CompletionWithArrayBlock)onCompletion {
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

+ (void)getFullStreakDataDictionariesForDates:(NSArray *)datesArray
                                 onCompletion:(CompletionWithArrayBlock)onCompletion {
    if (datesArray && [datesArray count] > 0) {
        NSMutableArray *dataArray = [NSMutableArray new];
        NSError __block *dataError;
        
        dispatch_group_t group = dispatch_group_create();
        
        for (NSDate *date in datesArray) {
            dispatch_group_enter(group);
            [self getStreakDataForDate:date onCompletion:^(NSDictionary *dictionary, NSError *error) {
                if (!error) {
                    if (dictionary) [dataArray addObject:dictionary];
                } else {
                    if (!dataError) dataError = error;
                }
                
                dispatch_group_leave(group);
            }];
        }
        
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            onCompletion(dataArray, dataError);
        });
    }
}

+ (void)getStreakDataForDate:(NSDate *)date
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
            if (array) [dataDictionary setObject:array forKey:kRESTStreakKey];
        } else {
            if (!dataError) dataError = error;
        }
        
        dispatch_group_leave(group);
    }];
    
    
    [self getLocationsDictionariesForDate:date onCompletion:^(NSArray *array, NSError *error) {
        if (!error) {
            [dataDictionary setObject:array forKey:kRESTStreakKey];
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
