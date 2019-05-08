//
//  HaoWuViewController.m
//  BlessingSMS
//
//  Created by hp on 2019/5/8.
//  Copyright © 2019 hxp. All rights reserved.
//

#import "HaoWuViewController.h"

@interface HaoWuViewController ()
{
    NSMutableArray *_dataSourceArray;
    NSInteger _pageIndex;
    NSString *_favID;
}
@property (strong, nonatomic) TB_JuanListAPIManager *tb_JuanListAPIManager;
//@property (strong, nonatomic) RecommendCollectionView *recommendCollectView;

@end

@implementation HaoWuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"好物";
    _pageIndex = 1;

    [self setupDefaultNavWitConfig:@[]];
    
    [self arrayInit];
    
//    [self.view addSubview:self.recommendCollectView];
    
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

#pragma mark - APIManagerDelegate
-(void)APIManagerDidSucess:(BaseAPIManager *)manager
{
    if (manager == self.tb_JuanListAPIManager){
        if (_pageIndex == 1 && _dataSourceArray.count > 0) {
            [_dataSourceArray removeAllObjects];
        }
        
        NSDictionary *dic = manager.dataSourceDic;
//        NSArray *resultArray = dic[@"tbk_uatm_favorites_item_get_response"][@"results"][@"uatm_tbk_item"];
//        
//        if (resultArray.count > 0) {
//            _pageIndex ++;
//        }
        
//        for (NSDictionary *dataDic in resultArray) {
//            RecommendInfoModel *model = [RecommendInfoModel mj_objectWithKeyValues:dataDic];
//            [_dataSourceArray addObject:model];
//        }
//
//        [_recommendCollectView reloadData];
//
//        [_recommendCollectView.mj_header endRefreshing];
//        [_recommendCollectView.mj_footer endRefreshing];
    }
}

-(void)APIManagerDidFailed:(BaseAPIManager *)manager
{
    //    NSLog(@"请求失败: %@", manager.requestError.description);
//    [_recommendCollectView.mj_header endRefreshing];
//    [_recommendCollectView.mj_footer endRefreshing];
}


-(TB_JuanListAPIManager *)tb_JuanListAPIManager
{
    if (!_tb_JuanListAPIManager) {
        _tb_JuanListAPIManager = [[TB_JuanListAPIManager alloc] init];
        _tb_JuanListAPIManager.delegate = self;
    }
    return _tb_JuanListAPIManager;
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
