//
//  StreakFeedViewController.h
//  
//
//  Created by Ryan Badilla on 6/20/16.
//
//

#import <UIKit/UIKit.h>

@interface StreakFeedViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (atomic, strong) NSMutableArray *dateArray;
@property (atomic, strong) NSMutableDictionary *dataDictionary;

@end
