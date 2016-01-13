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

@interface MainShowViewController ()
{
    NSMutableArray *_dataSourceArray;
    NSInteger pageIndex;
    
    NSString *currentCategoryId;
}

@property (strong, nonatomic) SMSAPIManager *smsApiManager;
@property (strong, nonatomic) SMSInfoReformer *smsApiReformer;
@property (strong, nonatomic) UITableView *showTableView;

@end

@implementation MainShowViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"推荐";
    pageIndex = 1;
    currentCategoryId = @"0";
    
    [self setupDefaultNavWitConfig:@[KeyLeftButton]];
    [self.defaultNavView.leftButton setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    
    [self arrayInit];
    [self loadData];
    
    [self.view addSubview:self.showTableView];
    
}

-(void)arrayInit
{
    _dataSourceArray = [[NSMutableArray alloc] init];
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
    
}

-(void)loadData
{
    [self.smsApiManager getSmsWithCategoryId:currentCategoryId andPageNum:pageIndex];
}

#pragma mark - APIManagerDelegate
-(void)APIManagerDidSucess:(BaseAPIManager *)manager
{
    if (manager == self.smsApiManager) [self getSmsSuccessWithManager:manager];
}

-(void)APIManagerDidFailed:(BaseAPIManager *)manager
{
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
    
    NSString *content = ((SMSInfoModel *)(_dataSourceArray[indexPath.row])).content;
    
    return [LayerHelper sizeWithContent:content andFont:[UIFont systemFontOfSize:15] andDrawSize:CGSizeMake(SCREEN_WIDTH - 15.0f, MAXFLOAT)].height + 14.0f + 14.0f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _dataSourceArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SmsCell *cell = (SmsCell*)[tableView dequeueReusableCellWithIdentifier:@"smsCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SmsCell" owner:self options:nil] lastObject];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    SMSInfoModel *model = _dataSourceArray[indexPath.row];
    
    cell.contentLabel.text = model.content;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SMSInfoModel *infoModel = _dataSourceArray[indexPath.row];
    
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

#pragma mark - headRefresh & footRefresh
-(void)headRefresh
{
    pageIndex = 1;
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
        _showTableView = [[UITableView alloc] initWithFrame:VIEW_FRAME_WITH_NAV style:UITableViewStylePlain];
        _showTableView.delegate = self;
        _showTableView.dataSource = self;
        _showTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _showTableView.backgroundColor = [UIColor colorWithRed:222/255.0f green:222/255.0f blue:222/255.0f alpha:1];
        
        _showTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRefresh)];
        _showTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRefresh)];
    }
    return _showTableView;
}

#pragma mark - didReceiveMemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
