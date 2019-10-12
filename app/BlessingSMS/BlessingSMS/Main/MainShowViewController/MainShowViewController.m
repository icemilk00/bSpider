//
//  MainShowViewController.m
//  BlessingSMS
//
//  Created by hp on 15/12/30.
//  Copyright © 2015年 hxp. All rights reserved.
//

#import "MainShowViewController.h"
#import "SMSInfoModel.h"
#import "SmsCell.h"
#import "SMSSendViewController.h"
#import "RecommendViewController.h"
#import "ActivityManager.h"

#import "GDTNativeExpressAd.h"
#import "GDTNativeExpressAdView.h"
#import "SmsADCell.h"

#define AD_SHOW_INDEX  6

@interface MainShowViewController () <GDTNativeExpressAdDelegete>
{
    NSMutableArray *_dataSourceArray;
    NSInteger pageIndex;
    
    NSString *currentCategoryId;
}

@property (strong, nonatomic) SMSAPIManager *smsApiManager;
@property (strong, nonatomic) SMSInfoReformer *smsApiReformer;

@property (strong, nonatomic) UITableView *showTableView;
@property (strong, nonatomic) UIButton *recommendButton;    //淘宝客推荐
@property (strong, nonatomic) UIButton *hbButton;           //红包
@property (assign, nonatomic) BOOL firstIn;

@property (nonatomic, strong) NSMutableArray *expressAdViews;
@property (nonatomic, strong) GDTNativeExpressAd *nativeExpressAd;
@property (nonatomic, assign) BOOL hasLoadAd;

@end

@implementation MainShowViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"推荐";
    pageIndex = 1;
    currentCategoryId = @"0";
    _hasLoadAd = NO;
    self.firstIn = YES;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hbShow:) name:ActivityUpdateNotifi object:nil];
    
    [self setupDefaultNavWitConfig:@[KeyLeftButton]];
    [self.defaultNavView.leftButton setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    
    [self arrayInit];
    
    self.nativeExpressAd = [[GDTNativeExpressAd alloc] initWithAppId:@"1106197212" placementId:@"6020680663999247" adSize:CGSizeMake(SCREEN_WIDTH - 20, 87)];
    self.nativeExpressAd.delegate = self;
    [self.nativeExpressAd loadAd:10];
    
    [self loadData];
    
    [self.view addSubview:self.showTableView];
    [self.view addSubview:self.recommendButton];
    [self.view addSubview:self.hbButton];
}

-(void)arrayInit
{
    _dataSourceArray = [[NSMutableArray alloc] init];
    self.expressAdViews = [[NSMutableArray alloc] init];
}

-(void)loadDataWithCategoryId:(NSString *)requestCategoryId andCategoryName:(NSString *)categoryName
{
    self.title = categoryName;
    [self loadDataWithCategoryId:requestCategoryId];
}

-(void)loadDataWithCategoryId:(NSString *)requestCategoryId
{
    currentCategoryId = requestCategoryId;
    pageIndex = 1;
    [self loadData];
    [self.nativeExpressAd loadAd:10];
}

-(void)loadData
{
    if (self.firstIn) [self.view showHud];
    [self.smsApiManager getSmsWithCategoryId:currentCategoryId andPageNum:pageIndex];
    
}

#pragma mark - AD Delegate
- (void)nativeExpressAdSuccessToLoad:(GDTNativeExpressAd
                                      *)nativeExpressAd views:(NSArray<__kindof
                                                               GDTNativeExpressAdView *> *)views
{
    [self.expressAdViews removeAllObjects];
    [self.expressAdViews addObjectsFromArray:views];
    [self.expressAdViews addObjectsFromArray:views];
    [self.expressAdViews addObjectsFromArray:views];
    [self.expressAdViews addObjectsFromArray:views];
    [self.expressAdViews addObjectsFromArray:views];
    if (self.expressAdViews.count > 0) {
        [self.expressAdViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            GDTNativeExpressAdView *expressView = (GDTNativeExpressAdView *)obj;
            expressView.controller = self;
            [expressView render];
        }];
        _hasLoadAd = YES;
    }
    // 广告位 render 后刷新 tableView
    [self.showTableView reloadData];
}

- (void)nativeExpressAdFailToLoad:(GDTNativeExpressAd *)nativeExpressAd error:(NSError *)error
{
    NSLog(@"Express Ad Load Fail : %@",error);
}

#pragma mark - APIManagerDelegate
-(void)APIManagerDidSucess:(BaseAPIManager *)manager
{
    self.firstIn = NO;
    [self.view hideHud];
    if (manager == self.smsApiManager) [self getSmsSuccessWithManager:manager];
}

-(void)APIManagerDidFailed:(BaseAPIManager *)manager
{
    self.firstIn = NO;
    [self.view hideHud];
//    NSLog(@"请求失败: %@", manager.requestError.description);
    [_showTableView.mj_header endRefreshing];
    [_showTableView.mj_footer endRefreshing];
}

-(void)getSmsSuccessWithManager:(BaseAPIManager *)apiManager
{
    if ([apiManager.retCode integerValue] != RTAPIManagerErrorTypeSuccess) {
        return;
    }
    
    NSArray *dataArray = [apiManager fetchDataWithReformer:self.smsApiReformer];
    
    if (pageIndex == 1 && _dataSourceArray.count > 0) {
        [_dataSourceArray removeAllObjects];
    }
    
    if (dataArray.count > 0) {
        pageIndex ++;
    }
    
    [_dataSourceArray addObjectsFromArray:dataArray];
    [_showTableView reloadData];
    
    [_showTableView.mj_header endRefreshing];
    [_showTableView.mj_footer endRefreshing];
    
}

#pragma mark - TableViewDelegate and DataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (_hasLoadAd && indexPath.row % AD_SHOW_INDEX == 0 && indexPath.row != 0 && indexPath.row/AD_SHOW_INDEX < self.expressAdViews.count) {
        // cell 高度取 adView render 后的值，这里的值是SDK算出来的
        UIView *view = [self.expressAdViews objectAtIndex:indexPath.row / AD_SHOW_INDEX];
        return view.bounds.size.height + 14;
    } else {
        NSInteger showAdNum = indexPath.row/AD_SHOW_INDEX;
        showAdNum = showAdNum > self.expressAdViews.count ?  self.expressAdViews.count :  showAdNum;
        NSInteger dataIndex = indexPath.row - showAdNum;
        SMSInfoModel *model = _dataSourceArray[dataIndex];
        NSString *content = model.content;
        return [LayerHelper sizeWithContent:content andFont:[UIFont systemFontOfSize:15] andDrawSize:CGSizeMake(SCREEN_WIDTH - 15.0f, MAXFLOAT)].height + 14.0f + 14.0f;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (_hasLoadAd) {
        NSInteger adNum = _dataSourceArray.count/AD_SHOW_INDEX;         //目前可以容纳的总广告量
        NSInteger adNum_now = self.expressAdViews.count;    //目前拉出来的总共广告量
        NSInteger showAdCount = adNum >= adNum_now ? adNum_now : adNum;
        return _dataSourceArray.count + showAdCount;
    } else {
        return _dataSourceArray.count;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = nil;
    if (_hasLoadAd && indexPath.row % AD_SHOW_INDEX == 0 && indexPath.row != 0 && indexPath.row/AD_SHOW_INDEX < self.expressAdViews.count) {
        SmsADCell *cell = (SmsADCell*)[tableView dequeueReusableCellWithIdentifier:@"SmsADCell"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SmsADCell" owner:self options:nil] lastObject];
            //        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        UIView *subView = (UIView *)[cell.bgView viewWithTag:1000];
        if ([subView superview]) {
            [subView removeFromSuperview];
        }
        UIView *view = [self.expressAdViews objectAtIndex:indexPath.row / AD_SHOW_INDEX];
        view.tag = 1000;
        [cell.bgView addSubview:view];
        return cell;
    } else {
        SmsCell *cell = (SmsCell*)[tableView dequeueReusableCellWithIdentifier:@"smsCell"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SmsCell" owner:self options:nil] lastObject];
            //        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        NSInteger showAdNum = indexPath.row/AD_SHOW_INDEX;
        showAdNum = showAdNum > self.expressAdViews.count ?  self.expressAdViews.count :  showAdNum;
        NSInteger dataIndex = indexPath.row - showAdNum;
        SMSInfoModel *model = _dataSourceArray[dataIndex];
        
        cell.contentLabel.text = model.content;
        return cell;
    }
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[SmsADCell class]]) {
        return;
    }
    
    NSInteger showAdNum = indexPath.row/AD_SHOW_INDEX;
    showAdNum = showAdNum > self.expressAdViews.count ?  self.expressAdViews.count :  showAdNum;
    NSInteger dataIndex = indexPath.row - showAdNum;
    SMSInfoModel *infoModel = _dataSourceArray[dataIndex];
        
    [AnalyticsManager eventSmsChooseWithCategoryID:infoModel.category_id withSMSID:infoModel.id];
    
    SMSSendViewController *smsSendVC = [[SMSSendViewController alloc] initWithSMSModel:infoModel];
    [self.navigationController pushViewController:smsSendVC animated:YES];
}

#pragma mark - leftAction
-(void)navLeftButtonClicked:(UIButton *)sender
{

    if (self.sideMenuViewController.visible) {
        [self.sideMenuViewController hideMenuViewController];
    }
    else
    {
        [self.sideMenuViewController presentLeftMenuViewController];
    }
}

-(void)recommendAction:(UIButton *)sender
{
    [AnalyticsManager eventHomeRecommendWithCategoryID:currentCategoryId withCategoryName:self.title];
    
    NSString *recommendFavID = @"";
    if ([currentCategoryId isEqualToString:@"0"]) {
        recommendFavID = [[ClientConfigManager sharedInstance] homePageRecommendFavID];
    }
    else
    {
        recommendFavID = [[TBManager sharedInstance] favIDForCategoryID:currentCategoryId];
    }
    
    RecommendViewController *recommendVc = [[RecommendViewController alloc] initWithFavID:recommendFavID];
    [self.navigationController pushViewController:recommendVc animated:YES];
}

-(void)hbAction:(UIButton *)sender
{
    [[ActivityManager shareInstance] showAlert];
}

-(void)hbShow:(NSNotification *)noti
{
    if (_hbButton) {
        _hbButton.hidden = ![ActivityManager shareInstance].isShow;
    }
}

#pragma mark - headRefresh & footRefresh
-(void)headRefresh
{
    pageIndex = 1;
    [self.nativeExpressAd loadAd:10];
    [self loadData];
}

-(void)footRefresh
{
    [self loadData];
}

#pragma mark - getter and setter
-(SMSAPIManager *)smsApiManager
{
    if (!_smsApiManager) {
        _smsApiManager = [[SMSAPIManager alloc] init];
        _smsApiManager.delegate = self;
    }
    return _smsApiManager;
}

-(SMSInfoReformer *)smsApiReformer
{
    if (!_smsApiReformer) {
        _smsApiReformer = [[SMSInfoReformer alloc] init];
    }
    return _smsApiReformer;
}


-(UITableView *)showTableView
{
    if (!_showTableView) {
        _showTableView = [[UITableView alloc] initWithFrame:VIEW_FRAME_WITH_NAV_TABBAR style:UITableViewStylePlain];
        _showTableView.delegate = self;
        _showTableView.dataSource = self;
        _showTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _showTableView.backgroundColor = [UIColor colorWithRed:222/255.0f green:222/255.0f blue:222/255.0f alpha:1];
        
        _showTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRefresh)];
        _showTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRefresh)];
    }
    return _showTableView;
}

-(UIButton *)recommendButton
{
    if (!_recommendButton) {
        _recommendButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 54, SCREEN_HEIGTH - 54 - TABBAR_HEIGHT, 40, 40)];
        _recommendButton.backgroundColor = [UIColor whiteColor];
        [_recommendButton addTarget:self action:@selector(recommendAction:) forControlEvents:UIControlEventTouchUpInside];
        _recommendButton.layer.cornerRadius = 44/2;
        _recommendButton.layer.shadowColor = [UIColor grayColor].CGColor;
        _recommendButton.layer.shadowOffset = CGSizeMake(1, 1);
        _recommendButton.layer.shadowOpacity = 0.8;
        
        [_recommendButton setImage:[UIImage imageNamed:@"home_recommend"] forState:UIControlStateNormal];
    }
    return _recommendButton;
}

-(UIButton *)hbButton
{
    if (!_hbButton) {
        _hbButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 52, SCREEN_HEIGTH - 54 - 54 - TABBAR_HEIGHT, 36, 40)];
        _hbButton.backgroundColor = [UIColor whiteColor];
        [_hbButton addTarget:self action:@selector(hbAction:) forControlEvents:UIControlEventTouchUpInside];
        _hbButton.layer.cornerRadius = 44/2;
        _hbButton.layer.shadowColor = [UIColor grayColor].CGColor;
        _hbButton.layer.shadowOffset = CGSizeMake(1, 1);
        _hbButton.layer.shadowOpacity = 0.8;
        _hbButton.hidden = ![ActivityManager shareInstance].isShow;
        
        [_hbButton setImage:[UIImage imageNamed:@"hb"] forState:UIControlStateNormal];
    }
    return _hbButton;
}

#pragma mark - didReceiveMemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
