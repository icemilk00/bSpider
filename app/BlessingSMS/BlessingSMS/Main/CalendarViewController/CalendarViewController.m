//
//  CalendarViewController.m
//  CalendarDemo
//
//  Created by hp on 16/2/6.
//  Copyright © 2016年 hxp. All rights reserved.
//

#import "CalendarViewController.h"
#import "CalendarTileView.h"
#import "CalendarDataModel.h"
#import "CalendarNotiViewController.h"
#import "CalendarNotiTableViewCell.h"


@interface CalendarViewController ()
{
    NSMutableArray *_notifiDataSourceArray;
}
@property (nonatomic, strong) CalendarView *calendarView;
@property (nonatomic, strong) UITableView *notiTableView;

@property (nonatomic, strong) UIButton *prevMonthButton;
@property (nonatomic, strong) UIButton *nextMonthButton;
@property (nonatomic, strong) UILabel *dateShowLabel;
@property (nonatomic, strong) UIImageView *chooseFlagImageView;

@property (nonatomic, strong) UILabel *noNotiLabel;

@end

@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"日历提醒";
    self.view.backgroundColor = [UIColor whiteColor];
    
    _notifiDataSourceArray = [[NSMutableArray alloc] init];
    
    [self setupDefaultNavWitConfig:@[KeyLeftButton,KeyRightButton]];
    [[self defaultNavView].rightButton setImage:[UIImage imageNamed:@"add_noti" ] forState:UIControlStateNormal];
    
    [self.view addSubview:self.prevMonthButton];
    [self.view addSubview:self.nextMonthButton];
    [self.view addSubview:self.dateShowLabel];
    [self.view addSubview:self.chooseFlagImageView];
    
    [self.view addSubview:self.calendarView];
    [_calendarView reloadDataWithCurrentDate];
    
    [self setDateShowLabelTextWithDate:[NSDate date]];
    
    [self makeNotiTableViewDataSource];
    [self.view addSubview:self.notiTableView];
    
    [self.notiTableView addSubview:self.noNotiLabel];
    
}

-(void)setDateShowLabelTextWithDate:(NSDate *)date
{
    NSDateComponents *c = [date YMDComponents];
    _dateShowLabel.text = [NSString stringWithFormat:@"%ld 年 %ld 月",(long)c.year, (long)c.month];
}

- (CalendarTileView *)calendarView:(CalendarView *)gridView tileViewForRow:(NSUInteger)row column:(NSUInteger)column
{
    CalendarTileView *tileView = nil;
    if (tileView == nil) {
        tileView = [[[NSBundle mainBundle] loadNibNamed:@"CalendarTileView" owner:self options:nil] lastObject];
    }
    
    CalendarDataModel *model = [gridView modelAtRow:row andColumn:column];
    
    NSString *saveKey = [NSString stringWithFormat:@"%lu|%lu|%lu", (unsigned long)model.year, (unsigned long)model.month, (unsigned long)model.day];
    NSMutableArray *notiArray = [[CalendarNotifiCenter defaultCenter] calendarNotiDicWithKey:saveKey];
    if (notiArray && notiArray.count > 0) {
        tileView.isHasNotification = YES;
    }
    else
    {
        tileView.isHasNotification = NO;
    }

    return tileView;
}

- (void)calendarView:(CalendarView *)calendarView didSelectAtRow:(NSUInteger)row column:(NSUInteger)column
{
    [self setDateShowLabelTextWithDate:calendarView.selectDate];
    
    [self makeNotiTableViewDataSource];
    [_notiTableView reloadData];
    
}

-(void)makeNotiTableViewDataSource
{
    [_notifiDataSourceArray removeAllObjects];
    
    NSString *saveKey = [NSString stringWithFormat:@"%lu|%lu|%lu", (unsigned long)_calendarView.selectedCalendarModel.year, (unsigned long)_calendarView.selectedCalendarModel.month, (unsigned long)_calendarView.selectedCalendarModel.day];
    
    NSMutableArray *notiArray = [[CalendarNotifiCenter defaultCenter] calendarNotiDicWithKey:saveKey];
    if (notiArray && notiArray.count > 0) {
        _calendarView.selectedTileView.isHasNotification = YES;
        [_notifiDataSourceArray addObjectsFromArray:notiArray];
        
        if (_noNotiLabel) {
            _noNotiLabel.hidden = YES;
        }
    }
    else
    {
        _calendarView.selectedTileView.isHasNotification = NO;
        
        if (_noNotiLabel) {
            _noNotiLabel.hidden = NO;
        }
    }
}

-(void)dateChangeTap:(UITapGestureRecognizer *)tap
{
    CalendarDatePickerView *pickerView = [[CalendarDatePickerView alloc] initWithDelegate:self];
    [pickerView show];
}

-(void)dateChangedWithDate:(NSDate *)date
{
    [_calendarView reloadCalendarWithDate:date];
    [self setDateShowLabelTextWithDate:date];
    
    [self makeNotiTableViewDataSource];
    [_notiTableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self makeNotiTableViewDataSource];
    [_notiTableView reloadData];
}

#pragma mark - button action
-(void)goPrevMonth:(UIButton *)sender
{
    NSDate *prevDate = [_calendarView.selectDate dayInThePreviousMonth];
    [_calendarView reloadCalendarWithDate:prevDate];
    [self setDateShowLabelTextWithDate:prevDate];
    
    [self makeNotiTableViewDataSource];
    [_notiTableView reloadData];
}

-(void)goNextMonth:(UIButton *)sender
{
    NSDate *nextDate = [_calendarView.selectDate dayInTheFollowingMonth];
    [_calendarView reloadCalendarWithDate:nextDate];
    [self setDateShowLabelTextWithDate:nextDate];
    
    [self makeNotiTableViewDataSource];
    [_notiTableView reloadData];
}

-(void)navLeftButtonClicked:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)navRightButtonClicked:(UIButton *)sender
{
    CalendarNotiViewController *v = [[CalendarNotiViewController alloc] initWithNibName:@"CalendarNotiViewController" bundle:nil withCalendarModel:[_calendarView selectedCalendarModel]];
    [self.navigationController pushViewController:v animated:YES];
    
    
    NSLog(@"notifiArray = %@", [PushManager localNotifications]);
    
}

#pragma mark - UITableViewDelegate and datasource

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44.0f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _notifiDataSourceArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CalendarNotiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CalendarNotiTableViewCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CalendarNotiTableViewCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    CalendarNotiModel *model = _notifiDataSourceArray[indexPath.row];
    
    BOOL isExpired = [model.date isBeforeCurrentDate];
    
    if (model.isExpired != isExpired) {
        model.isExpired = isExpired;
        [[CalendarNotifiCenter defaultCenter] editNotifi:model withIndex:indexPath.row];
    }
    
    [cell configUIWithModel:model];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CalendarNotiViewController *v = [[CalendarNotiViewController alloc] initWithNibName:@"CalendarNotiViewController" bundle:nil withCalendarNotiModel:_notifiDataSourceArray[indexPath.row] andIndex:indexPath.row];

    [self.navigationController pushViewController:v animated:YES];
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[CalendarNotifiCenter defaultCenter] delNotifi:_notifiDataSourceArray[indexPath.row]];
        [_notifiDataSourceArray removeObjectAtIndex:[indexPath row]];
        if (_notifiDataSourceArray.count <= 0) {
            _calendarView.selectedTileView.isHasNotification = NO;
        }
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationTop];
    }
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    return [NSString stringWithFormat:@"%@%lu日", self.dateShowLabel.text, (unsigned long)self.calendarView.selectedCalendarModel.day];
}


#pragma mark - setter and getter
-(CalendarView *)calendarView
{
    if (_calendarView == nil) {
        self.calendarView = [[CalendarView alloc] initWithFrame:CGRectMake(0.0f, NAVIGATIONBAR_HEIGHT + 50.0f, self.view.frame.size.width, 0)];
        _calendarView.delegate = self;
        _calendarView.dataSource = self;
    }

    return _calendarView;
}

-(UIButton *)prevMonthButton
{
    if (_prevMonthButton == nil) {
        self.prevMonthButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, NAVIGATIONBAR_HEIGHT + 5.0f, 80.0f, 40.0f)];
        [_prevMonthButton setTitle:@"上个月" forState:UIControlStateNormal];
        [_prevMonthButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_prevMonthButton addTarget:self action:@selector(goPrevMonth:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _prevMonthButton;
}

-(UIButton *)nextMonthButton
{
    if (_nextMonthButton == nil) {
        self.nextMonthButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 80.0f, NAVIGATIONBAR_HEIGHT + 5.0f, 80.0f, 40.0f)];
        [_nextMonthButton setTitle:@"下个月" forState:UIControlStateNormal];
        [_nextMonthButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_nextMonthButton addTarget:self action:@selector(goNextMonth:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _nextMonthButton;
}

-(UILabel *)dateShowLabel
{
    if (_dateShowLabel == nil) {
        self.dateShowLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 60.0f, NAVIGATIONBAR_HEIGHT + 5.0f, 120.0f, 40.0f)];
        _dateShowLabel.textAlignment = NSTextAlignmentCenter;
        _dateShowLabel.text = @"xx年xx月";
        
        _dateShowLabel.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dateChangeTap:)];
        [_dateShowLabel addGestureRecognizer:tap];
    }
    
    return _dateShowLabel;
}

-(UIImageView *)chooseFlagImageView
{
    if (_chooseFlagImageView == nil) {
        self.chooseFlagImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chooseFlag"]];
        _chooseFlagImageView.frame = CGRectMake(_dateShowLabel.frame.origin.x + _dateShowLabel.frame.size.width - 5.0f, _dateShowLabel.frame.origin.y + 17.0f, 6.0f, 6.0f);
    }
    return _chooseFlagImageView;
}

-(UITableView *)notiTableView
{
    if (_notiTableView == nil) {
        self.notiTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, _calendarView.frame.origin.y + _calendarView.frame.size.height, _calendarView.frame.size.width,self.view.frame.size.height - _calendarView.frame.origin.y - _calendarView.frame.size.height) style:UITableViewStylePlain];
        _notiTableView.delegate = self;
        _notiTableView.dataSource = self;
        _notiTableView.tableFooterView = [[UIView alloc] init];
    }
    
    return _notiTableView;
}

-(UILabel *)noNotiLabel
{
    if (_noNotiLabel == nil) {
        self.noNotiLabel = [[UILabel alloc] initWithFrame:CGRectMake(_notiTableView.frame.size.width/2 - 30.0f, 50.0f, 60.0f, 40.0f)];
        _noNotiLabel.text = @"无提醒";
        _noNotiLabel.textColor = [UIColor lightGrayColor];
        _noNotiLabel.textAlignment = NSTextAlignmentCenter;
        
        if(_notifiDataSourceArray && _notifiDataSourceArray.count > 0)
        {
            _noNotiLabel.hidden = YES;
        }
        else
        {
            _noNotiLabel.hidden = NO;
        }
    }
    return _noNotiLabel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
