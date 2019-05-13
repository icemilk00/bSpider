//
//  HaoWuViewController.m
//  BlessingSMS
//
//  Created by hp on 2019/5/8.
//  Copyright © 2019 hxp. All rights reserved.
//

#import "HaoWuViewController.h"
#import "YHQTableViewCell.h"
#import "HaoWuDetailViewController.h"


@interface HaoWuViewController ()
{
    NSMutableArray *_dataSourceArray;
    NSInteger _pageIndex;
    NSString *_favID;
}
@property (strong, nonatomic) TB_JuanListAPIManager *tb_JuanListAPIManager;
@property (strong, nonatomic) UITableView *showTableView;
@end

@implementation HaoWuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"好物";
    _pageIndex = 1;

    [self setupDefaultNavWitConfig:@[]];
    
    [self arrayInit];
    
    [self.view addSubview:self.showTableView];
    
    [self loadData];
    
}

-(void)arrayInit
{
    _dataSourceArray = [[NSMutableArray alloc] init];
}

-(void)loadData
{
    [self.tb_JuanListAPIManager getTB_JuanListWithCat:@"" searchStr:@"" andPageNum:_pageIndex];
}

#pragma mark - TableViewDelegate and DataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 106;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataSourceArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    YHQTableViewCell *cell = (YHQTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"YHQTableViewCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"YHQTableViewCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    YHQInfoModel *model = _dataSourceArray[indexPath.row];
    [cell setupWithModel:model];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YHQInfoModel *infoModel = _dataSourceArray[indexPath.row];
    
    
    
//    [AnalyticsManager eventSmsChooseWithCategoryID:infoModel.category_id withSMSID:infoModel.id];
    
    HaoWuDetailViewController *vc = [[HaoWuDetailViewController alloc] init];
    vc.infoModel = infoModel;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - headRefresh & footRefresh
-(void)headRefresh
{
    _pageIndex = 1;
    [self loadData];
}

-(void)footRefresh
{
    [self loadData];
}

#pragma mark - APIManagerDelegate
-(void)APIManagerDidSucess:(BaseAPIManager *)manager
{
    if (manager == self.tb_JuanListAPIManager){
        if (_pageIndex == 1 && _dataSourceArray.count > 0) {
            [_dataSourceArray removeAllObjects];
        }
        
        NSDictionary *dic = manager.dataSourceDic;
        NSArray *resultArray = dic[@"tbk_dg_item_coupon_get_response"][@"results"][@"tbk_coupon"];

        if (resultArray.count > 0) {
            _pageIndex ++;
        }
        
        for (NSDictionary *dataDic in resultArray) {
            YHQInfoModel *model = [YHQInfoModel mj_objectWithKeyValues:dataDic];
            [_dataSourceArray addObject:model];
        }

        [_showTableView reloadData];

        [_showTableView.mj_header endRefreshing];
        [_showTableView.mj_footer endRefreshing];
    }
}

-(void)APIManagerDidFailed:(BaseAPIManager *)manager
{
    NSLog(@"请求失败: %@", manager.requestError.description);
    [_showTableView.mj_header endRefreshing];
    [_showTableView.mj_footer endRefreshing];
}


-(TB_JuanListAPIManager *)tb_JuanListAPIManager
{
    if (!_tb_JuanListAPIManager) {
        _tb_JuanListAPIManager = [[TB_JuanListAPIManager alloc] init];
        _tb_JuanListAPIManager.delegate = self;
    }
    return _tb_JuanListAPIManager;
}

-(UITableView *)showTableView
{
    if (!_showTableView) {
        _showTableView = [[UITableView alloc] initWithFrame:VIEW_FRAME_WITH_NAV_TABBAR style:UITableViewStylePlain];
        _showTableView.delegate = self;
        _showTableView.dataSource = self;
//        _showTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _showTableView.backgroundColor = [UIColor whiteColor];
        
        _showTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRefresh)];
        _showTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRefresh)];
    }
    return _showTableView;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
