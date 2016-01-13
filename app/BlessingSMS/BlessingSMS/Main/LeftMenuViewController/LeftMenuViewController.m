//
//  LeftMenuViewController.m
//  BlessingSMS
//
//  Created by hp on 15/12/30.
//  Copyright © 2015年 hxp. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "SMSCategoryModel.h"
#import "SMSCategoryCell.h"

@interface LeftMenuViewController ()
{
    NSMutableArray *_dataSourceArray;
}

@property (nonatomic, strong) UITableView *leftTableView;
@property (strong, nonatomic) SMSCategoryAPIManager *smsCategoryAPIManager;
@property (strong, nonatomic) SMSCategoryReformer *smsCategoryReformer;

@end

@implementation LeftMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:246/255.0f green:56/255.0f blue:56/255.0f alpha:1];
    
    [self arrayInit];
    [self loadData];
    
//    [self setupBgView];
    [self.view addSubview:self.leftTableView];
}

-(void)arrayInit
{
    _dataSourceArray = [[NSMutableArray alloc] init];
}

-(void)loadData
{
    [self.smsCategoryAPIManager getSmsCategory];
}

#pragma mark - APIManagerDelegate
-(void)APIManagerDidSucess:(BaseAPIManager *)manager
{
    if (manager == self.smsCategoryAPIManager) [self getCategorySuccessWithManager:manager];
}

-(void)APIManagerDidFailed:(BaseAPIManager *)manager
{
    //    NSLog(@"请求失败: %@", manager.requestError.description);
}

-(void)getCategorySuccessWithManager:(BaseAPIManager *)apiManager
{
    if ([apiManager.retCode integerValue] != RTAPIManagerErrorTypeSuccess) {
        return;
    }
    
    NSArray *dataArray = [apiManager fetchDataWithReformer:self.smsCategoryReformer];
    
    [_dataSourceArray addObjectsFromArray:dataArray];
    [_leftTableView reloadData];
    
}

#pragma mark - TableViewDelegate and DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataSourceArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50.0f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1 + [SMSCategoryReformer rowsCountOfExpandInArray:_dataSourceArray withIndex:section];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SMSCategoryCell *cell = (SMSCategoryCell*)[tableView dequeueReusableCellWithIdentifier:@"SMSCategoryCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SMSCategoryCell" owner:self options:nil] lastObject];
        cell.backgroundColor = [UIColor clearColor];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    SMSCategoryModel *model = [self modelAtIndexPath:indexPath];
    
    [cell updateWithModel:model andIsSubCategory:indexPath.row == 0 ? NO : YES];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SMSCategoryModel *model = [self modelAtIndexPath:indexPath];
    
    if (model.isHasChildCategory) {
        //说明是有扩展的cell，执行展开或收缩操作
        if (model.isExpand)
        {
            //执行收起操作
            model.isExpand = !model.isExpand;
            
            NSMutableArray *insertArray = [[NSMutableArray alloc] init];
            for (int i = 1; i <= [(NSArray *)(model.categoryValue) count]; i ++) {
                NSIndexPath *insertIndexPath = [NSIndexPath indexPathForRow:i inSection:indexPath.section];
                [insertArray addObject:insertIndexPath];
            }
            
            [tableView deleteRowsAtIndexPaths:insertArray withRowAnimation:NO];
            
            [(SMSCategoryCell *)[tableView cellForRowAtIndexPath:indexPath] setAccessImageViewType:CategoryCellAccessShowDown];
        }
        else
        {
            //执行展开操作
            model.isExpand = !model.isExpand;
            
            NSMutableArray *insertArray = [[NSMutableArray alloc] init];
            for (int i = 1; i <= [(NSArray *)(model.categoryValue) count]; i ++) {
                NSIndexPath *insertIndexPath = [NSIndexPath indexPathForRow:i inSection:indexPath.section];
                [insertArray addObject:insertIndexPath];
            }
            
            [tableView insertRowsAtIndexPaths:insertArray withRowAnimation:NO];
            
            
            [(SMSCategoryCell *)[tableView cellForRowAtIndexPath:indexPath] setAccessImageViewType:CategoryCellAccessShowUp];
        }
    }
    else
    {
        
        MainShowViewController *contentVC = (MainShowViewController *)((UINavigationController *)(self.sideMenuViewController.contentViewController)).topViewController;
        
        if ([contentVC respondsToSelector:@selector(loadDataWithCategoryId:andCategoryName:)]) {
            [contentVC loadDataWithCategoryId:model.categoryValue andCategoryName:model.categoryName];
        }
        [self.sideMenuViewController hideMenuViewController];
    }
}

-(SMSCategoryModel *)modelAtIndexPath:(NSIndexPath *)indexPath
{
    SMSCategoryModel *model = nil;
    if (indexPath.row == 0) {
        model = _dataSourceArray[indexPath.section];
    }
    else
    {
        SMSCategoryModel *parentModel = _dataSourceArray[indexPath.section];
        model = parentModel.categoryValue[indexPath.row - 1];
    }
    
    return model;
}

#pragma mark - getter and setter
-(SMSCategoryAPIManager *)smsCategoryAPIManager
{
    if (!_smsCategoryAPIManager) {
        _smsCategoryAPIManager = [[SMSCategoryAPIManager alloc] init];
        _smsCategoryAPIManager.delegate = self;
    }
    return _smsCategoryAPIManager;
}

-(SMSCategoryReformer *)smsCategoryReformer
{
    if (!_smsCategoryReformer) {
        _smsCategoryReformer = [[SMSCategoryReformer alloc] init];
    }
    return _smsCategoryReformer;
}

-(UITableView *)leftTableView
{
    if (!_leftTableView) {
        _leftTableView = [[UITableView alloc] initWithFrame:VIEW_FRAME_WITH_NAV style:UITableViewStylePlain];
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _leftTableView.backgroundColor = [UIColor clearColor];

    }
    return _leftTableView;
}

-(void)setupBgView
{
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bgImageView.image = [UIImage imageNamed:@"left_bg"];
    [self.view addSubview:bgImageView];
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
