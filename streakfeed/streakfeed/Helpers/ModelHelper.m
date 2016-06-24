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
            StreakTypeModel *streakTypeModel = [self streakTypeModelWithStreakTypeDictionary:dictionary];
            
            // add streak type model to array if valid
            if (streakTypeModel) [newArray addObject:streakTypeModel];
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
            PhotoModel *photoModel = [self photoModelWithPhotoDictionary:dictionary];
            
            // add photo model to array
            if (photoModel) [newArray addObject:photoModel];
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
            LocationModel *locationModel = [self locationModelWithLocationDictionary:dictionary];
            
            // add location model to array
            if (locationModel) [newArray addObject:locationModel];
        }
        
        return newArray;
    }
    
    return nil;
}

+ (NSMutableArray *)streakCardsFromStreakTypeDictionaryArray:(NSArray *)streakTypeArray
                                    locationsDictionaryArray:(NSArray *)locationsArray
                                       photosDictionaryArray:(NSArray *)photosArray {
    
    if (streakTypeArray ) {
        NSMutableArray *streakCardArray = [NSMutableArray arrayWithCapacity:[streakTypeArray count]];
        // first create a streak card
        for (NSDictionary *streakTypeDictionary in streakTypeArray) {
            StreakCardModel *streakCard = [self streakCardWithStreakTypeDictionary:streakTypeDictionary];
            if (streakCard) {
                // find if there is a relative location
                NSDictionary *locationDictionary = [self findDataDictionaryinArray:locationsArray
                                                                           withKey:kLocationArrivedAtKey
                                                                     isBetweenUTC1:streakTypeDictionary[kStreakTypeStartAtKey]
                                                                              utc2:streakTypeDictionary[kStreakTypeStopAtKey]];
                LocationModel *locationModel = [self locationModelWithLocationDictionary:locationDictionary];
                streakCard.location = locationModel;
                
                // find if there is a relative photo
                NSDictionary *photoDictionary = [self findDataDictionaryinArray:photosArray
                                                                        withKey:kPhotoTakenAtKey
                                                                  isBetweenUTC1:streakTypeDictionary[kStreakTypeStartAtKey]
                                                                           utc2:streakTypeDictionary[kStreakTypeStopAtKey]];
                
                PhotoModel *photoModel = [self photoModelWithPhotoDictionary:photoDictionary];
                streakCard.photo = photoModel;
            }
            
            [streakCardArray addObject:streakCard];
        }
        
        return streakCardArray;
    }
    
    return nil;
}

#pragma mark -
#pragma mark - create model methods
+ (StreakCardModel *)streakCardWithStreakTypeDictionary:(NSDictionary *)streakTypeDictionary {
    if (streakTypeDictionary != nil) {
        StreakCardModel *newStreakCard = [StreakCardModel new];
        newStreakCard.streakType = [StreakTypeModel new];
        newStreakCard.streakType.type = streakTypeDictionary[kStreakTypeTypeKey];
        newStreakCard.streakType.start_at = [self dateFromUTC:streakTypeDictionary[kStreakTypeStartAtKey]];
        newStreakCard.streakType.stop_at = [self dateFromUTC:streakTypeDictionary[kStreakTypeStopAtKey]];
        
        return newStreakCard;
    }
    
    return nil;
}

+ (StreakTypeModel *)streakTypeModelWithStreakTypeDictionary:(NSDictionary *)dictionary {
    if (dictionary) {
        StreakTypeModel *streakTypeModel = [StreakTypeModel new];
        streakTypeModel.type = dictionary[kStreakTypeTypeKey];
        streakTypeModel.start_at = [self dateFromUTC:dictionary[kStreakTypeStartAtKey]];
        streakTypeModel.stop_at = [self dateFromUTC:dictionary[kStreakTypeStopAtKey]];
        
        return streakTypeModel;
    }
    
    return nil;
}

+ (LocationModel *)locationModelWithLocationDictionary:(NSDictionary *)dictionary {
    if (dictionary) {
        LocationModel *locationModel = [LocationModel new];
        locationModel.latitude = dictionary[kLocationLatitudeKey];
        locationModel.longitude = dictionary[kLocationLongitudeKey];
        locationModel.arrived_at = [self dateFromUTC:dictionary[kLocationArrivedAtKey]];
        
        return locationModel;
    }
    
    return nil;
}

+ (PhotoModel *)photoModelWithPhotoDictionary:(NSDictionary *)dictionary {
    if (dictionary) {
        PhotoModel *photoModel = [PhotoModel new];
        photoModel.url = dictionary[kPhotoURLKey];
        photoModel.taken_at = [self dateFromUTC:dictionary[kPhotoTakenAtKey]];
        
        return photoModel;
    }
    
    return nil;
}

#pragma mark -
#pragma mark - find methods
+ (NSDictionary *)findDataDictionaryinArray:(NSArray *)array
                                    withKey:(NSString *)key
                              isBetweenUTC1:(NSNumber *)utc1
                                       utc2:(NSNumber *)utc2 {
    if (array && key && utc1 && utc2) {
        for (NSDictionary *dictionary in array) {
            NSNumber *time = dictionary[key];
            if (time) {
                long int foundTime = lround(floor([time doubleValue]));
                long int utcTime1 = lround(floor([utc1 doubleValue]));
                long int utcTime2 = lround(floor([utc2 doubleValue]));
                if (foundTime >= utcTime1 && foundTime <= utcTime2) {
                    return dictionary;
                }
            }
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
