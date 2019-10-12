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
#import "HaoWuThemeView.h"
#define angelToRandian(x) ((x)/180.0*M_PI)

#import "GDTNativeExpressAd.h"
#import "GDTNativeExpressAdView.h"

#define AD_SHOW_INDEX  6

@interface HaoWuViewController () <GDTNativeExpressAdDelegete>
{
    NSMutableArray *_dataSourceArray;
    NSInteger _pageIndex;
}
@property (strong, nonatomic) TB_MaterialAPIManager *tb_MaterialAPIManager;
@property (strong, nonatomic) UITableView *showTableView;
@property (strong, nonatomic) HaoWuThemeView *themeView;
@property (strong, nonatomic) UIButton *QYHButton;           //推荐按钮

@property (nonatomic, strong) NSMutableArray *expressAdViews;
@property (nonatomic, strong) GDTNativeExpressAd *nativeExpressAd;
@property (nonatomic, assign) BOOL hasLoadAd;

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
    
    [self.view addSubview:self.QYHButton];
    CAKeyframeAnimation* anim=[CAKeyframeAnimation animation];
    anim.keyPath=@"transform.rotation";
    anim.values=@[@(angelToRandian(-9)),@(angelToRandian(9)),@(angelToRandian(-9)),@(angelToRandian(9)),@(angelToRandian(-9)),@(angelToRandian(9)),@(angelToRandian(-9)),@(angelToRandian(9)),@(angelToRandian(0)),@(angelToRandian(0)),@(angelToRandian(0)),@(angelToRandian(0)),@(angelToRandian(0)),@(angelToRandian(0)),@(angelToRandian(0)),@(angelToRandian(0)),@(angelToRandian(0)),@(angelToRandian(0)),@(angelToRandian(0)),@(angelToRandian(0)),@(angelToRandian(0)),@(angelToRandian(0)),@(angelToRandian(0)),@(angelToRandian(0)),@(angelToRandian(0)),@(angelToRandian(0)),@(angelToRandian(0)),@(angelToRandian(0)),@(angelToRandian(0)),@(angelToRandian(0)),@(angelToRandian(0)),@(angelToRandian(0))];
    anim.repeatCount = MAXFLOAT;
    anim.duration = 3;
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
    [self.QYHButton.layer addAnimation:anim forKey:nil];

    
    self.nativeExpressAd = [[GDTNativeExpressAd alloc] initWithAppId:@"1106197212" placementId:@"6090784686841960" adSize:CGSizeMake(SCREEN_WIDTH - 20, 87)];
    self.nativeExpressAd.delegate = self;
    [self.nativeExpressAd loadAd:10];
    
    [self loadData];
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if([[ClientConfigManager sharedInstance] canGoDetailPage]) {
        self.QYHButton.hidden = NO;
    
    }
}

-(void)QYHAction{
    
    NSString *urlStr = [NSString stringWithFormat:@"https://apps.apple.com/cn/app/优惠券/id%@", @"1448205043"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
}

-(void)arrayInit
{
    _dataSourceArray = [[NSMutableArray alloc] init];
    self.expressAdViews = [[NSMutableArray alloc] init];
}

//4094 特惠
-(void)loadData
{
    [self.tb_MaterialAPIManager getTB_MaterialWithId:@"9660" andPageNum:_pageIndex];
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

#pragma mark - TableViewDelegate and DataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_hasLoadAd && indexPath.row % AD_SHOW_INDEX == 0 && indexPath.row != 0 && indexPath.row/AD_SHOW_INDEX < self.expressAdViews.count) {
        // cell 高度取 adView render 后的值，这里的值是SDK算出来的
        UIView *view = [self.expressAdViews objectAtIndex:indexPath.row / AD_SHOW_INDEX];
        return view.bounds.size.height;
    }
    
    return 106;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (_hasLoadAd) {
        NSInteger adNum = _dataSourceArray.count/AD_SHOW_INDEX;         //目前可以容纳的总广告量
        NSInteger adNum_now = self.expressAdViews.count;    //目前拉出来的总共广告量
        NSInteger showAdCount = adNum >= adNum_now ? adNum_now : adNum;
        return _dataSourceArray.count + showAdCount;
    }
    
    return _dataSourceArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_hasLoadAd && indexPath.row % AD_SHOW_INDEX == 0 && indexPath.row != 0 && indexPath.row/AD_SHOW_INDEX < self.expressAdViews.count) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SmsADCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] init];
            //        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        UIView *subView = (UIView *)[cell.contentView viewWithTag:1000];
        if ([subView superview]) {
            [subView removeFromSuperview];
        }
        UIView *view = [self.expressAdViews objectAtIndex:indexPath.row / AD_SHOW_INDEX];
        view.tag = 1000;
        [cell.contentView addSubview:view];
        return cell;
    }
    
    YHQTableViewCell *cell = (YHQTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"YHQTableViewCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"YHQTableViewCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSInteger showAdNum = indexPath.row/AD_SHOW_INDEX;
    showAdNum = showAdNum > self.expressAdViews.count ?  self.expressAdViews.count :  showAdNum;
    NSInteger dataIndex = indexPath.row - showAdNum;
    MaterialDetailModel *model = _dataSourceArray[dataIndex];
    [cell setupWithModel:model];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id cell = [tableView cellForRowAtIndexPath:indexPath];
    if (![cell isKindOfClass:[YHQTableViewCell class]]) {
        return;
    }
    
    NSInteger showAdNum = indexPath.row/AD_SHOW_INDEX;
    showAdNum = showAdNum > self.expressAdViews.count ?  self.expressAdViews.count :  showAdNum;
    NSInteger dataIndex = indexPath.row - showAdNum;
    MaterialDetailModel *infoModel = _dataSourceArray[dataIndex];
    
    HaoWuDetailViewController *vc = [[HaoWuDetailViewController alloc] init];
    vc.infoModel = infoModel;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - headRefresh & footRefresh
-(void)headRefresh
{
    _pageIndex = 1;
    [self.nativeExpressAd loadAd:10];
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
        _showTableView = [[UITableView alloc] initWithFrame:VIEW_FRAME_WITH_NAV_TABBAR style:UITableViewStylePlain];
        _showTableView.delegate = self;
        _showTableView.dataSource = self;
//        _showTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _showTableView.backgroundColor = [UIColor whiteColor];
        _showTableView.tableHeaderView = self.themeView;
        
        _showTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRefresh)];
        _showTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRefresh)];
    }
    return _showTableView;
}

-(HaoWuThemeView *)themeView {
    if (!_themeView) {
        _themeView = [[HaoWuThemeView alloc] initWithFrame:CGRectMake(0.0f, 0.0, SCREEN_WIDTH, 180)];
    }
    return _themeView;
}

-(UIButton *)QYHButton
{
    if (!_QYHButton) {
        _QYHButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 52, SCREEN_HEIGTH - 54 - TABBAR_HEIGHT, 36, 40)];
        [_QYHButton setImage:[UIImage imageNamed:@"quan_appIcon"] forState:UIControlStateNormal];
        [_QYHButton addTarget:self action:@selector(QYHAction) forControlEvents:UIControlEventTouchUpInside];
        _QYHButton.layer.cornerRadius = 10;
        _QYHButton.layer.masksToBounds = YES;
        _QYHButton.layer.shadowColor = [UIColor grayColor].CGColor;
        _QYHButton.layer.shadowOffset = CGSizeMake(1, 1);
        _QYHButton.layer.shadowOpacity = 0.8;
        _QYHButton.hidden = YES;
    }
    return _QYHButton;
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
