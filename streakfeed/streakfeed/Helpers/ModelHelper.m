//
//  ModelHelper.m
//  streakfeed
//
//  Created by Ryan Badilla on 6/20/16.
//  Copyright © 2016 rybadilla. All rights reserved.
//

#import "ModelHelper.h"
#import "StreakCardModel.h"
#import "kRESTConstants.h"


@implementation ModelHelper

#pragma mark -
#pragma mark - dataModel methods
+ (NSMutableArray *)streakTypesFromDictionaryArray:(NSArray *)array {
    if ([self isValidArrayOfDictionary:array]) {
        NSMutableArray *newArray = [NSMutableArray new];
        for (NSDictionary *dictionary in array) {
            //create new streak type model with data in dictionary
            StreakTypeModel *streakTypeModel = [StreakTypeModel new];
            streakTypeModel.type = dictionary[kStreakTypeTypeKey];
            streakTypeModel.start_at = [self dateFromUTC:dictionary[kStreakTypeStartAtKey]];
            streakTypeModel.stop_at = [self dateFromUTC:dictionary[kStreakTypeStopAtKey]];
            
            // add streak type model to array
            [newArray addObject:streakTypeModel];
        }
        
        return newArray;
    }
    
    return nil;
}

+ (NSMutableArray *)photosFromDictionaryArray:(NSArray *)array {
    if ([self isValidArrayOfDictionary:array]) {
        NSMutableArray *newArray = [NSMutableArray new];
        for (NSDictionary *dictionary in array) {
            //create new photo model with data in dictionary
            PhotoModel *photoModel = [PhotoModel new];
            photoModel.url = dictionary[kPhotoURLKey];
            photoModel.taken_at = [self dateFromUTC:dictionary[kPhotoTakenAtKey]];
            
            // add photo model to array
            [newArray addObject:photoModel];
        }
        
        return newArray;
    }
    
    return nil;
}

+ (NSMutableArray *)locationsFromDictionaryArray:(NSArray *)array {
    if ([self isValidArrayOfDictionary:array]) {
        NSMutableArray *newArray = [NSMutableArray new];
        for (NSDictionary *dictionary in array) {
            //create new location model with data in dictionary
            LocationModel *locationModel = [LocationModel new];
            locationModel.latitude = dictionary[kLocationLatitudeKey];
            locationModel.longitude = dictionary[kLocationLongitudeKey];
            locationModel.arrived_at = [self dateFromUTC:dictionary[kLocationArrivedAtKey]];
            
            
            // add location model to array
            [newArray addObject:locationModel];
        }
        
        return newArray;
    }
    
    return nil;
}

+ (NSMutableArray *)streakCardsFromDictionaryArray:(NSArray *)array {
    if ([self isValidArrayOfDictionary:array]) {
        NSMutableArray *newArray = [NSMutableArray new];
        for (NSDictionary *dictionary in array) {
            //create new streak card model with data in dictionary
            StreakCardModel *streakCardModel = [StreakCardModel new];
            
            // add streak type model to array
            [newArray addObject:streakCardModel];
        }
        
        return newArray;
    }
    
    return nil;
}

+ (NSMutableArray *)streakCardsFromStreakTypeDictionaryArray:(NSArray *)streakTypeArray
                                    locationsDictionaryArray:(NSArray *)locationsArray
                                       photosDictionaryArray:(NSArray *)photosArray {

    if (streakTypeArray) {
        
        
        for (StreakTypeModel *streakTypeModel in streakTypeArray) {
            
        }
    }
    
    return nil;
}


#pragma mark -
#pragma mark - helper methods
+ (NSDate *)dateFromUTC:(NSNumber *)utc {
    return (utc) ? [NSDate dateWithTimeIntervalSince1970:lround(floor([utc doubleValue]))] : nil;
}

+ (BOOL)isValidArrayOfDictionary:(NSArray *)array {
    BOOL isValidArray = (array && [array count] > 0);
    BOOL isArrayOfDictionaries = isValidArray && [array[0] isKindOfClass:[NSDictionary class]];
    
    return (isValidArray && isArrayOfDictionaries);
}

@end
