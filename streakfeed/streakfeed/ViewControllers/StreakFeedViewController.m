//
//  StreakFeedViewController.m
//  
//
//  Created by Ryan Badilla on 6/20/16.
//
//

#import "StreakFeedViewController.h"
#import "StreakCardTableViewCell.h"
#import "RESTHelper.h"
#import "kErrorConstants.h"
#import "StreakCardModel.h"
#import <MapKit/MapKit.h>
#import <NSDate+Helper.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <UIScrollView+InfiniteScroll.h>

static NSInteger const kDaysFetchCount  = 1;
static CGFloat const kTableCellHeight   = 80.0f;
static CGFloat const kTableHeaderHeight = 60.0f;

static NSString *const kTableViewCellStreakCardID = @"StreakCardCell";

@interface StreakFeedViewController ()

@property (atomic, strong) NSMutableArray *dateArray;
@property (atomic, strong) NSMutableDictionary *dataDictionary;


@end

@implementation StreakFeedViewController

#pragma mark -
#pragma mark - view controller life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    
    
    NSMutableArray *dates = [self daysDaysFromStartDate:[NSDate date] daysCount:kDaysFetchCount];
    [self fetchDataWithDates:dates onCompletion:^(NSError *error) {
        
    }];;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


#pragma mark -
#pragma mark - setup
- (void)setup {
    [self setupView];
    [self setupConstraints];
}

- (void)setupView {
    [self.view addSubview:[self tableView]];
}

- (void)setupConstraints {
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_tableView);
    NSDictionary *metrics = @{@"vBuffer" : @(20)};
    
    // setup vertical constraints
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-vBuffer-[_tableView]|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:viewsDictionary]];
    
    // setup horizontal constraints
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tableView]|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:viewsDictionary]];
}

#pragma mark -
#pragma mark - loadData
- (void)fetchDataWithDates:(NSArray *)datesArray onCompletion:(CompletionWithErrorBlock)completion{
    [RESTHelper getDictionaryOfStreakCardsAndDateKeysForDates:datesArray onCompletion:^(NSDictionary *dictionary, NSError *error) {
        if (!error) {
            if (!_dateArray) _dateArray = [NSMutableArray new];
            if (!_dataDictionary) _dataDictionary = [NSMutableDictionary new];
            
            [_dateArray addObjectsFromArray:datesArray];
            [_dataDictionary addEntriesFromDictionary:dictionary];
            
            [_tableView reloadData];
            
        } else {
            [self showAlertViewControllerWithTitle:kAlertTitle
                                           message:error.localizedDescription
                                       actionTitle:kAlertCancelActionTitle];
        }
        
        if (completion) completion(error);
    }];
}


#pragma mark -
#pragma mark - UITableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kTableHeaderHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.frame.size.width - (10 * 2), kTableHeaderHeight)];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    label.text = [_dateArray[section] stringWithFormat:@"MMMM d, yyyy"];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, kTableHeaderHeight)];
    view.backgroundColor = [UIColor whiteColor];
    [view addSubview:label];
    
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:NO];
}


#pragma mark -
#pragma mark - UITableView data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellID = kTableViewCellStreakCardID;
    
    StreakCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[StreakCardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    [self setupStreakCardTableViewCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)setupStreakCardTableViewCell:(StreakCardTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NSDate *date = _dateArray[indexPath.section];
    NSArray *cardArray = _dataDictionary[[date string]];
    StreakCardModel *streakCard = cardArray[indexPath.row];
    
    if (streakCard) {
        NSString *streakTypeString = streakCard.streakType.type;
        NSString *startTimeString = [streakCard.streakType.start_at stringWithDateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle];
    
        NSString *durationString = [NSString stringWithFormat:@"%ld min", lround([streakCard.streakType.stop_at timeIntervalSinceDate:streakCard.streakType.start_at] / 60)];
    
        cell.streakTypeLabel.text = streakTypeString;
        cell.startTimeLabel.text = startTimeString;
        cell.durationTypeLabel.text = durationString;
        
        if (streakCard.photo && streakCard.photo.url) {
            NSURL *photoURL = [NSURL URLWithString:streakCard.photo.url];
            [cell.photoImageView sd_setImageWithURL:photoURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
            }];
        } else if (streakCard.location) {
            double latitude = [streakCard.location.latitude doubleValue];
            double longitude = [streakCard.location.longitude doubleValue];
            NSString *staticMapURL = [NSString stringWithFormat:@"http://maps.google.com/maps/api/staticmap?markers=color:red|%f,%f&%@&sensor=true",latitude, longitude, @"zoom=10&size=270x70"];
            NSURL *mapURL = [NSURL URLWithString:[staticMapURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];
            
            [cell.photoImageView sd_setImageWithURL:mapURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
            }];
        } else {
            [cell.photoImageView setImage:nil];
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_dateArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDate *date = _dateArray[section];
    NSArray *cardArray = _dataDictionary[[date string]];
    
    return (cardArray) ? [cardArray count] : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kTableCellHeight;
}

#pragma mark -
#pragma mark - date helpers
- (NSMutableArray *)daysDaysFromStartDate:(NSDate *)date daysCount:(NSInteger)days{
    if (days > 0) {
        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDate *startDate = [date beginningOfDay];
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:days];

        for (NSInteger index = 0; index < days; index++) {
            [dateComponents setDay:-index];
            NSDate *newDate = [calendar dateByAddingComponents:dateComponents toDate:startDate options:0];
            [array addObject:newDate];
        }
        
        return array;
        
    }
    return nil;
}

#pragma mark -
#pragma mark - alertError
- (void)showAlertViewControllerWithTitle:(NSString *)title
                                 message:(NSString *)message
                             actionTitle:(NSString *)actionTitle {
    UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:title
                                                                                 message:message
                                                                          preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:actionTitle
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    
    [alertViewController addAction:cancelAction];
    
    [self presentViewController:alertViewController animated:YES completion:nil];
}

#pragma mark -
#pragma mark - didRecieveMemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - getter method
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [UITableView new];
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [_tableView registerClass:[StreakCardTableViewCell class] forCellReuseIdentifier:kTableViewCellStreakCardID];
        _tableView.delegate = self;
        _tableView.dataSource = self;

        if (!_dateArray) _dateArray = [NSMutableArray new];
        if (!_dataDictionary) _dataDictionary = [NSMutableDictionary new];
        
        __weak typeof(_dateArray) dateArray = _dateArray;
        __weak typeof(self) weakSelf = self;
        [_tableView addInfiniteScrollWithHandler:^(UITableView* tableView) {
            if (dateArray) {
                // get previous days
                NSDate *date = [dateArray lastObject];
                NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
                [dateComponents setDay:-1];
                NSDate *previousDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
                NSMutableArray *previousDatesArray = [weakSelf daysDaysFromStartDate:previousDate daysCount:kDaysFetchCount];
                
                // fetch data
                [weakSelf fetchDataWithDates:previousDatesArray onCompletion:^(NSError *error) {
                    if (!error) [tableView reloadData];
                    [tableView finishInfiniteScroll];
                }];
                
            } else {
                [tableView finishInfiniteScroll];
            }
            

        }];
    }
    
    return _tableView;
}

@end

