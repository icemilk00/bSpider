//
//  HaoWuThemeViewController.m
//  BlessingSMS
//
//  Created by hp on 2019/5/8.
//  Copyright © 2019 hxp. All rights reserved.
//

#import "HaoWuThemeViewController.h"
#import "YHQTableViewCell.h"
#import "HaoWuDetailViewController.h"


@interface HaoWuThemeViewController ()
{
    NSMutableArray *_dataSourceArray;
    NSInteger _pageIndex;
    NSString *_favID;
}
@property (strong, nonatomic) TB_MaterialAPIManager *tb_MaterialAPIManager;
@property (strong, nonatomic) UITableView *showTableView;
@end

@implementation HaoWuThemeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    _pageIndex = 1;

    [self setupDefaultNavWitConfig:@[KeyLeftButton]];
    
    [self arrayInit];
    
    [self.view addSubview:self.showTableView];
    
    [self loadData];
    
}

-(void)arrayInit
{
    _dataSourceArray = [[NSMutableArray alloc] init];
}

//4094 特惠
-(void)loadData
{
    [self.tb_MaterialAPIManager getTB_MaterialWithId:self.materialId andPageNum:_pageIndex];
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
    
    MaterialDetailModel *model = _dataSourceArray[indexPath.row];
    [cell setupWithModel:model];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MaterialDetailModel *infoModel = _dataSourceArray[indexPath.row];
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
    if ( manager == self.tb_MaterialAPIManager) {
        
        if (_pageIndex == 1 && _dataSourceArray.count > 0) {
            [_dataSourceArray removeAllObjects];
        }
        
        NSDictionary *dic = manager.dataSourceDic;
        NSArray *resultArray = dic[@"tbk_dg_optimus_material_response"][@"result_list"][@"map_data"];
        
        if (resultArray.count > 0) {
            _pageIndex ++;
        }
        
        for (NSDictionary *dataDic in resultArray) {
            MaterialDetailModel *model = [MaterialDetailModel mj_objectWithKeyValues:dataDic];
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

-(TB_MaterialAPIManager *)tb_MaterialAPIManager
{
    if (!_tb_MaterialAPIManager) {
        _tb_MaterialAPIManager = [[TB_MaterialAPIManager alloc] init];
        _tb_MaterialAPIManager.delegate = self;
    }
    return _tb_MaterialAPIManager;
}

-(UITableView *)showTableView
{
    if (!_showTableView) {
        _showTableView = [[UITableView alloc] initWithFrame:VIEW_FRAME_WITH_NAV style:UITableViewStylePlain];
        _showTableView.delegate = self;
        _showTableView.dataSource = self;
//        _showTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _showTableView.backgroundColor = [UIColor whiteColor];
        _showTableView.tableFooterView = [UIView new];
        
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
