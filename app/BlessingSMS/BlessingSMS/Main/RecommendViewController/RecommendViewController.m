//
//  RecommendViewController.m
//  BlessingSMS
//
//  Created by hp on 2017/5/22.
//  Copyright © 2017年 hxp. All rights reserved.
//

#import "RecommendViewController.h"
#import "RecommendCollectionView.h"
#import "RecommendInfoModel.h"
#import "RecommendCell.h"

@interface RecommendViewController ()
{
    NSMutableArray *_dataSourceArray;
    NSInteger _pageIndex;
}
@property (strong, nonatomic) TB_FavoritesItemAPIManager *tb_FavoritesItemApiManager;
@property (strong, nonatomic) RecommendCollectionView *recommendCollectView;

@end

@implementation RecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = RGB_COLOR(250,245,245);
    self.title = @"好品推荐";
    _pageIndex = 1;
    
    [self setupDefaultNavWitConfig:@[KeyLeftButton]];
    
    [self arrayInit];
    
    [self.view addSubview:self.recommendCollectView];
    
    [self loadData];
    
    
}

-(void)arrayInit
{
    _dataSourceArray = [[NSMutableArray alloc] init];
}

-(void)loadData
{
    [self.tb_FavoritesItemApiManager getTB_FavoritesItem:@"5580797" andPageNum:_pageIndex];
}

#pragma mark - collectionView delegate & datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataSourceArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    RecommendInfoModel *model = _dataSourceArray[indexPath.row];
    RecommendCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RecommendCell" forIndexPath:indexPath];
    [cell setupWithModel:model];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    RecommendInfoModel *model = _dataSourceArray[indexPath.row];
    
    id<AlibcTradePage> page = [AlibcTradePageFactory page:model.click_url];
//    [AlibcTradePageFactory itemDetailPage:@"45281461519"];
    id<AlibcTradeService> service = [AlibcTradeSDK sharedInstance].tradeService;
    AlibcTradeShowParams *showParams = [[AlibcTradeShowParams alloc] init];
    showParams.openType = AlibcOpenTypeAuto;

    [service
     show:showParams.isNeedPush ? self.navigationController : self
     page:page
     showParams:showParams
     taoKeParams:nil
     trackParam:nil
     tradeProcessSuccessCallback:^(AlibcTradeResult * _Nullable result) {

     } tradeProcessFailedCallback:^(NSError * _Nullable error) {
         
     }];
    
    
    return;
}

- (NSDictionary *)trackParams {
    return @{@"track_hp": @"track_1066936453"};
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
    if (manager == self.tb_FavoritesItemApiManager) [self getTbFavItemSuccessWithManager:manager];
}

-(void)APIManagerDidFailed:(BaseAPIManager *)manager
{
    //    NSLog(@"请求失败: %@", manager.requestError.description);
    [_recommendCollectView.mj_header endRefreshing];
    [_recommendCollectView.mj_footer endRefreshing];
}

-(void)getTbFavItemSuccessWithManager:(BaseAPIManager *)apiManager
{

    if (_pageIndex == 1 && _dataSourceArray.count > 0) {
        [_dataSourceArray removeAllObjects];
    }
    
    NSDictionary *dic = apiManager.dataSourceDic;
    NSArray *resultArray = dic[@"tbk_uatm_favorites_item_get_response"][@"results"][@"uatm_tbk_item"];
    
    if (resultArray.count > 0) {
        _pageIndex ++;
    }
    
    for (NSDictionary *dataDic in resultArray) {
        RecommendInfoModel *model = [RecommendInfoModel mj_objectWithKeyValues:dataDic];
        [_dataSourceArray addObject:model];
    }
    
    [_recommendCollectView reloadData];
    
    [_recommendCollectView.mj_header endRefreshing];
    [_recommendCollectView.mj_footer endRefreshing];
}


-(TB_FavoritesItemAPIManager *)tb_FavoritesItemApiManager
{
    if (!_tb_FavoritesItemApiManager) {
        _tb_FavoritesItemApiManager = [[TB_FavoritesItemAPIManager alloc] init];
        _tb_FavoritesItemApiManager.delegate = self;
    }
    return _tb_FavoritesItemApiManager;
}

-(RecommendCollectionView *)recommendCollectView
{
    if (!_recommendCollectView) {
        RecommendCollectionViewFlowLayout *layout = [[RecommendCollectionViewFlowLayout alloc] init];
        
        self.recommendCollectView = [[RecommendCollectionView alloc] initWithFrame:CGRectMake(0.0f, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGTH - NAVIGATIONBAR_HEIGHT) collectionViewLayout:layout];
        _recommendCollectView.backgroundColor = [UIColor clearColor];
        _recommendCollectView.delegate = self;
        _recommendCollectView.dataSource = self;
        [_recommendCollectView registerNib:[UINib nibWithNibName:@"RecommendCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"RecommendCell"];
        
        _recommendCollectView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRefresh)];
        _recommendCollectView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRefresh)];
    }
    return _recommendCollectView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
