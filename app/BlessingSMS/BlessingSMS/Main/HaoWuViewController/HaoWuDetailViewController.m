//
//  HaoWuDetailViewController.m
//  BlessingSMS
//
//  Created by hp on 2019/5/11.
//  Copyright © 2019 hxp. All rights reserved.
//

#import "HaoWuDetailViewController.h"
#import "HaoWuDetailModel.h"
#import "MaterialBannerCell.h"
#import "MaterialInfoCell.h"


typedef NS_ENUM(NSUInteger, HaoWuDetailSection) {
    HaoWuDetailSectionBanner,                // banner
    HaoWuDetailSectionInfo,                  // 商品信息
//    HaoWuDetailSectionRecommand,             // 关联推荐
    HaoWuDetailSectionMax
};

@interface HaoWuDetailViewController ()
@property (strong, nonatomic) HaoWuDetailModel *haowuModel;
@property (strong, nonatomic) TB_ItemDetailAPIManager *tb_itemDetailAPIManager;
@property (strong, nonatomic) UITableView *showTableView;
@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) UIButton *bottomBtn;
@end

@implementation HaoWuDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"商品详情";
    self.view.backgroundColor = DEFAULT_BG_COLOR;
    
    [self setupDefaultNavWitConfig:@[KeyLeftButton]];
    
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.bottomBtn];
    [self.view addSubview:self.showTableView];
    
    [self loadData];
}

-(void)loadData
{
    [self.tb_itemDetailAPIManager getTB_ItemDetailWithId:self.infoModel.item_id];
}

#pragma mark - TableViewDelegate and DataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == HaoWuDetailSectionBanner) {
        return SCREEN_WIDTH;
    }

    return 106;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return HaoWuDetailSectionMax;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == HaoWuDetailSectionBanner) {
        return 1;
    }
    
    if (section == HaoWuDetailSectionInfo) {
        return 1;
    }
    
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == HaoWuDetailSectionBanner) {
        MaterialBannerCell *cell = (MaterialBannerCell*)[tableView dequeueReusableCellWithIdentifier:@"MaterialBannerCell"];
        if (cell == nil) {
            cell = [[MaterialBannerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MaterialBannerCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.data = self.infoModel.small_images[@"string"];
        return cell;
    }
    
    if (indexPath.section == HaoWuDetailSectionInfo) {
        MaterialInfoCell *cell = (MaterialInfoCell*)[tableView dequeueReusableCellWithIdentifier:@"MaterialInfoCell"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MaterialInfoCell" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell setupWithModel:self.infoModel];
        return cell;
    }
    

    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    YHQInfoModel *infoModel = _dataSourceArray[indexPath.row];
    
    //    [AnalyticsManager eventSmsChooseWithCategoryID:infoModel.category_id withSMSID:infoModel.id];
    
    //    SMSSendViewController *smsSendVC = [[SMSSendViewController alloc] initWithSMSModel:infoModel];
    //    [self.navigationController pushViewController:smsSendVC animated:YES];
}

//点击领劵购买
-(void)juanAction {
    NSString *couponUrl = [CommonHelper addHttpsForUrlStr:self.infoModel.coupon_share_url];
    
    id<AlibcTradePage> page = [AlibcTradePageFactory page:couponUrl];
    //    [AlibcTradePageFactory itemDetailPage:@"45281461519"];
    id<AlibcTradeService> service = [AlibcTradeSDK sharedInstance].tradeService;
    AlibcTradeShowParams *showParams = [[AlibcTradeShowParams alloc] init];
    showParams.openType = AlibcOpenTypeNative;
    
    AlibcTradeTaokeParams *taokeParams = [[AlibcTradeTaokeParams alloc] init];
    taokeParams.pid = @"mm_17747039_0_0";
    
    [service
     show:showParams.isNeedPush ? self.navigationController : self
     page:page
     showParams:showParams
     taoKeParams:taokeParams
     trackParam:nil
     tradeProcessSuccessCallback:^(AlibcTradeResult * _Nullable result) {
         
     } tradeProcessFailedCallback:^(NSError * _Nullable error) {
         
     }];
}

#pragma mark - APIManagerDelegate
-(void)APIManagerDidSucess:(BaseAPIManager *)manager
{
    if ( manager == self.tb_itemDetailAPIManager) {
        
        NSDictionary *dic = manager.dataSourceDic;
        NSArray *resultArray = dic[@"tbk_item_info_get_response"][@"results"][@"n_tbk_item"];
        
        self.haowuModel = [HaoWuDetailModel mj_objectWithKeyValues:resultArray[0]];
        
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

-(TB_ItemDetailAPIManager *)tb_itemDetailAPIManager
{
    if (!_tb_itemDetailAPIManager) {
        _tb_itemDetailAPIManager = [[TB_ItemDetailAPIManager alloc] init];
        _tb_itemDetailAPIManager.delegate = self;
    }
    return _tb_itemDetailAPIManager;
}


-(UITableView *)showTableView
{
    if (!_showTableView) {
        _showTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGTH - NAVIGATIONBAR_HEIGHT - BOTTOMDangerArea_HEIGHT - self.bottomView.frame.size.height) style:UITableViewStylePlain];
        _showTableView.delegate = self;
        _showTableView.dataSource = self;
        _showTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _showTableView.backgroundColor = [UIColor whiteColor];
    }
    return _showTableView;
}

-(UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, self.view.frame.size.height - 40 - BOTTOMDangerArea_HEIGHT, SCREEN_WIDTH, 40)];
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}

-(UIButton *)bottomBtn
{
    if (!_bottomBtn) {
        _bottomBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.bottomView.frame.size.width, self.bottomView.frame.size.height)];
        _bottomBtn.backgroundColor = DEFAULT_BG_COLOR;
        [_bottomBtn setTitle:@"领劵" forState:UIControlStateNormal];
        [_bottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _bottomBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [_bottomBtn addTarget:self action:@selector(juanAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomBtn;
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
