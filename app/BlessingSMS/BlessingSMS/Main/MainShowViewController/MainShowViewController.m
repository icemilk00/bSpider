//
//  MainShowViewController.m
//  BlessingSMS
//
//  Created by hp on 15/12/30.
//  Copyright © 2015年 hxp. All rights reserved.
//

#import "MainShowViewController.h"
#import "SMSInfoModel.h"

@interface MainShowViewController ()
{
    NSMutableArray *_dataSourceArray;
    NSInteger pageIndex;
}
@property (strong, nonatomic) SMSAPIManager *smsApiManager;
@property (strong, nonatomic) SMSInfoReformer *smsApiReformer;
@property (strong, nonatomic) UITableView *showTableView;

@end

@implementation MainShowViewController

- (void)viewDidLoad {
    self.title = @"推荐";
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    pageIndex = 1;
    
    [self setupDefaultNavWitConfig:@[]];
    
    [self arrayInit];
    [self sendRequest];
    
    [self.view addSubview:self.showTableView];
    
}

-(void)arrayInit
{
    _dataSourceArray = [[NSMutableArray alloc] init];
}

-(void)sendRequest
{
    [self.smsApiManager getSmsWithCategoryId:@"0" andPageNum:pageIndex];
}

#pragma mark - APIManagerDelegate
-(void)APIManagerDidSucess:(BaseAPIManager *)manager
{
    if (manager == self.smsApiManager) [self getSmsSuccessWithManager:manager];
}

-(void)APIManagerDidFailed:(BaseAPIManager *)manager
{
//    NSLog(@"请求失败: %@", manager.requestError.description);
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
    
    if (_dataSourceArray.count > 0) {
        pageIndex ++;
    }
    
    [_dataSourceArray addObjectsFromArray:dataArray];
    [_showTableView reloadData];
}

#pragma mark - TableViewDelegate and DataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _dataSourceArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"smsCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"smsCell"];
    }
    
    SMSInfoModel *model = _dataSourceArray[indexPath.row];
    
    cell.textLabel.text = model.content;
    return cell;
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
        _showTableView = [[UITableView alloc] init];
        _showTableView.delegate = self;
        _showTableView.dataSource = self;
    }
    return _showTableView;
}

#pragma mark - didReceiveMemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
