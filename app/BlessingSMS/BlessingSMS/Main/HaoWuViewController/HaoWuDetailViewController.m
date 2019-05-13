//
//  HaoWuDetailViewController.m
//  BlessingSMS
//
//  Created by hp on 2019/5/11.
//  Copyright © 2019 hxp. All rights reserved.
//

#import "HaoWuDetailViewController.h"


typedef NS_ENUM(NSUInteger, HaoWuDetailSection) {
    HaoWuDetailSectionBanner,                // banner
    HaoWuDetailSectionInfo,                  // 信息
    ZBStoreServiceSectionHonest,                // 保证
    ZBStoreServiceSectionScore,                 // 打分
    ZBStoreServiceSectionEvaluate,              // 评价
    ZBStoreServiceSectionMax
};

@interface HaoWuDetailViewController ()

@property (strong, nonatomic) TB_ItemDetailAPIManager *tb_itemDetailAPIManager;
@property (strong, nonatomic) UITableView *showTableView;
@end

@implementation HaoWuDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"商品详情";
    
    [self setupDefaultNavWitConfig:@[KeyLeftButton]];
    
    [self.view addSubview:self.showTableView];
    
//    [self loadData];
}



#pragma mark - TableViewDelegate and DataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 106;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 10;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    YHQTableViewCell *cell = (YHQTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"YHQTableViewCell"];
//    if (cell == nil) {
//        cell = [[[NSBundle mainBundle] loadNibNamed:@"YHQTableViewCell" owner:self options:nil] lastObject];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
//
//    YHQInfoModel *model = _dataSourceArray[indexPath.row];
//    [cell setupWithModel:model];
    UITableViewCell *cell = [UITableViewCell new];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    YHQInfoModel *infoModel = _dataSourceArray[indexPath.row];
    
    //    [AnalyticsManager eventSmsChooseWithCategoryID:infoModel.category_id withSMSID:infoModel.id];
    
    //    SMSSendViewController *smsSendVC = [[SMSSendViewController alloc] initWithSMSModel:infoModel];
    //    [self.navigationController pushViewController:smsSendVC animated:YES];
}


-(UITableView *)showTableView
{
    if (!_showTableView) {
        _showTableView = [[UITableView alloc] initWithFrame:VIEW_FRAME_WITH_NAV style:UITableViewStylePlain];
        _showTableView.delegate = self;
        _showTableView.dataSource = self;
        _showTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _showTableView.backgroundColor = [UIColor whiteColor];
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
