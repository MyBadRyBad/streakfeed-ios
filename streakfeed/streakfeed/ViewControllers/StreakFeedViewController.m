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
#import <NSDate+Helper.h>

static NSInteger const kDaysFetchCount = 1;
static CGFloat const kTableCellHeight = 80.0f;

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
    [self fetchDataWithDates:dates];
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
    NSDictionary *metrics = nil;
    
    // setup vertical constraints
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_tableView]|"
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
- (void)fetchDataWithDates:(NSArray *)datesArray {
    [RESTHelper getDictionaryOfStreakCardsAndDateKeysForDates:datesArray onCompletion:^(NSDictionary *dictionary, NSError *error) {
        if (!error) {
            if (!_dateArray) _dateArray = [NSMutableArray new];
            if (!_dataDictionary) _dataDictionary = [NSMutableDictionary new];
            
            [_dateArray addObjectsFromArray:[self dateArrayToKeys:datesArray]];
            [_dataDictionary addEntriesFromDictionary:dictionary];
            
            [_tableView reloadData];
            
        } else {
            [self showAlertViewControllerWithTitle:kAlertTitle
                                           message:error.localizedDescription
                                       actionTitle:kAlertCancelActionTitle];
        }
    }];
}


#pragma mark -
#pragma mark - UITableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // do nothing
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return  nil;
}

#pragma mark -
#pragma mark - UITableView data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"StreakCardCell";
    
    StreakCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[StreakCardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    [self setupStreakCardTableViewCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)setupStreakCardTableViewCell:(StreakCardTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NSArray *cardArray = _dataDictionary[_dateArray[indexPath.section]];
    StreakCardModel *streakCard = cardArray[indexPath.row];
    
    if (streakCard) {
        NSString *streakTypeString = streakCard.streakType.type;
        NSString *startTimeString = [streakCard.streakType.start_at stringWithDateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle];
    
        NSString *durationString = [NSString stringWithFormat:@"%ld min", lround([streakCard.streakType.stop_at timeIntervalSinceDate:streakCard.streakType.start_at] / 60)];
    
        cell.streakTypeLabel.text = streakTypeString;
        cell.startTimeLabel.text = startTimeString;
        cell.durationTypeLabel.text = durationString;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_dateArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *cardArray = _dataDictionary[_dateArray[section]];
    
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

- (NSMutableArray *)dateArrayToKeys:(NSArray *)dateArray {
    if (dateArray) {
        NSMutableArray *newArray = [NSMutableArray arrayWithCapacity:[dateArray count]];
        for (NSDate *date in dateArray) {
            [newArray addObject:[date string]];
        }
        
        return newArray;
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
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    
    return _tableView;
}

@end

