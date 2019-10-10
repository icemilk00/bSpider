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
#import "HaowuDetailCell.h"
#import "YHQTableViewCell.h"
#import "SMSWebViewController.h"

typedef NS_ENUM(NSUInteger, HaoWuDetailSection) {
    HaoWuDetailSectionBanner,                // banner
    HaoWuDetailSectionInfo,                  // 商品信息
    HaoWuDetailSectionGuessLike,             // 猜你喜欢
    HaoWuDetailSectionMax
};

@interface HaoWuDetailViewController ()
@property (strong, nonatomic) HaoWuDetailModel *haowuModel;

@property (strong, nonatomic) UITableView *showTableView;
@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) UIButton *bottomBtn;

@property (strong, nonatomic) NSString *detailStr;

@property (assign, nonatomic) BOOL firstIn;

@property (strong, nonatomic) NSMutableArray *dataSourceArray;
@property (nonatomic, strong) UILabel *noDataLabel;

@property (nonatomic, strong) NSString *tkl;

@end

@implementation HaoWuDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"商品详情";
    self.view.backgroundColor = DEFAULT_BG_COLOR;
    self.dataSourceArray = [[NSMutableArray alloc] init];
    self.firstIn = YES;
    
    [self setupDefaultNavWitConfig:@[KeyLeftButton]];
    
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.bottomBtn];
    
    if(![[ClientConfigManager sharedInstance] canGoDetailPage])
    {
        _bottomView.frame = CGRectMake(_bottomView.left, _bottomView.bottom, _bottomView.width, 0);
        _bottomBtn.hidden = YES;
    }
    
    [self.view addSubview:self.showTableView];
    [self.showTableView addSubview:self.noDataLabel];
    
    [self loadData];
}

-(void)loadData
{
    int index = arc4random() % 10;
    
    NSString *searchStr = self.infoModel.title;
    if (searchStr) {
        searchStr = [searchStr substringToIndex:10];
    }
    
    if (self.firstIn) [self.view showHud];
    [[[TB_SearchMaterialAPIManager alloc] init] getTB_SearchMaterialWithPageNum:index cat:nil searchStr:searchStr complete:^(BaseAPIManager *manager) {
        
        self.firstIn = NO;
        [self.view hideHud];
        
        if (manager.success) {
            [self.dataSourceArray removeAllObjects];
            
            NSDictionary *dic = manager.dataSourceDic;
            NSArray *resultArray = dic[@"tbk_dg_material_optional_response"][@"result_list"][@"map_data"];
            
            self.noDataLabel.hidden = YES;
            if (resultArray.count == 0) {
                self.noDataLabel.hidden = NO;
            }
            
            for (NSDictionary *dataDic in resultArray) {
                MaterialDetailModel *model = [MaterialDetailModel mj_objectWithKeyValues:dataDic];
                [self.dataSourceArray addObject:model];
            }
            
            [self.showTableView reloadData];
            
        } else {
            [self.view showHudWithMessage:@"网络不给力哦，请重试"];
        }
        
    }];
}


#pragma mark - TableViewDelegate and DataSource

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == HaoWuDetailSectionBanner) {
        return SCREEN_WIDTH;
    } else if (indexPath.section == HaoWuDetailSectionGuessLike) {
        return 126;
    }

    return 115;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return HaoWuDetailSectionMax;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == HaoWuDetailSectionGuessLike) {
        
        return _dataSourceArray.count;
    }
    return 1;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == HaoWuDetailSectionGuessLike) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, 50)];
        view.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, view.height)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"猜你喜欢";
        label.font = [UIFont systemFontOfSize:17];
        label.textColor = DEFAULT_BG_COLOR;
        [view addSubview:label];
        return view;
    }
    
    return nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == HaoWuDetailSectionGuessLike) {
        return 50;
    }
    
    return CGFLOAT_MIN;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == HaoWuDetailSectionBanner) {
        MaterialBannerCell *cell = (MaterialBannerCell*)[tableView dequeueReusableCellWithIdentifier:@"MaterialBannerCell"];
        if (cell == nil) {
            cell = [[MaterialBannerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MaterialBannerCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        NSArray *imageArray = self.infoModel.small_images[@"string"];
        if (imageArray && imageArray.count > 0) {
            cell.data = imageArray;
        } else {
            cell.data = @[self.infoModel.pict_url];
        }
        
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
    
    if (indexPath.section == HaoWuDetailSectionGuessLike) {
        
        YHQTableViewCell *cell = (YHQTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"YHQTableViewCell"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"YHQTableViewCell" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        MaterialDetailModel *model = _dataSourceArray[indexPath.row];
        [cell setupWithModel:model];
        return cell;
    }
    

    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section != HaoWuDetailSectionGuessLike) {
        return;
    }
    MaterialDetailModel *infoModel = _dataSourceArray[indexPath.row];
    HaoWuDetailViewController *vc = [[HaoWuDetailViewController alloc] init];
    vc.infoModel = infoModel;
    [self.navigationController pushViewController:vc animated:YES];
}

//点击领劵购买
-(void)juanAction {
    
    NSString *couponUrl = [CommonHelper addHttpsForUrlStr:self.infoModel.coupon_share_url];
    couponUrl = [NSString stringWithFormat:@"%@&%@",couponUrl,@"pid=mm_17747039_25550611_101788700150"];
    
    
    SMSWebViewController *webView = [[SMSWebViewController alloc] initWithUrlString:couponUrl];
    webView.title = @"领券";
    [self.navigationController pushViewController:webView animated:YES];
    
    
//    NSString *couponUrl = [CommonHelper addHttpsForUrlStr:self.infoModel.coupon_share_url];
//
//    id<AlibcTradeService> service = [AlibcTradeSDK sharedInstance].tradeService;
//    AlibcTradeShowParams *showParams = [[AlibcTradeShowParams alloc] init];
//    showParams.openType = AlibcOpenTypeAuto;
//
//    AlibcTradeTaokeParams *taokeParams = [[AlibcTradeTaokeParams alloc] init];
//    taokeParams.pid = @"mm_17747039_25550611_101788700150";
//    taokeParams.extParams = @{
//                              @"taokeAppkey":@"23832822"
//                              };
//    [service openByUrl:couponUrl identity:@"trade" webView:nil parentController:showParams.isNeedPush ? self.navigationController : self showParams:showParams taoKeParams:taokeParams trackParam:nil tradeProcessSuccessCallback:^(AlibcTradeResult * _Nullable result) {
//
//    } tradeProcessFailedCallback:^(NSError * _Nullable error) {
//
//    }];
    
    
//    [service
//     show:showParams.isNeedPush ? self.navigationController : self
//     page:page
//     showParams:showParams
//     taoKeParams:taokeParams
//     trackParam:nil
//     tradeProcessSuccessCallback:^(AlibcTradeResult * _Nullable result) {
//
//     } tradeProcessFailedCallback:^(NSError * _Nullable error) {
//
//     }];
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

-(UILabel *)noDataLabel
{
    if (_noDataLabel == nil) {
        self.noDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, SCREEN_WIDTH + 115 + 40 + 20, SCREEN_WIDTH - 20, 40.0f)];
        _noDataLabel.text = @"没有找到您喜欢的哦";
        _noDataLabel.textColor = [UIColor lightGrayColor];
        _noDataLabel.textAlignment = NSTextAlignmentCenter;
        
        if(_dataSourceArray && _dataSourceArray.count > 0)
        {
            _noDataLabel.hidden = YES;
        }
        else
        {
            _noDataLabel.hidden = NO;
        }
    }
    return _noDataLabel;
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
