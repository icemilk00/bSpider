//
//  SettingViewController.m
//  BlessingSMS
//
//  Created by hp on 16/1/20.
//  Copyright © 2016年 hxp. All rights reserved.
//

#import "SettingViewController.h"
#import "AboutSMSViewController.h"

@interface SettingViewController ()
{
    NSArray *_settingDataArray;
}
@property (strong, nonatomic) UITableView *settingTableView;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupDefaultNavWitConfig:@[KeyLeftButton]];
    
    _settingDataArray = [[NSArray alloc] initWithObjects:@"给我们评分", @"关于祝福短信", nil];
    
    [self.view addSubview:self.settingTableView];
}

#pragma mark - TableViewDelegate and DataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50.0f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _settingDataArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"settingCell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.text = _settingDataArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        NSString  * nsStringToOpen = [NSString  stringWithFormat: @"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8",@"1078083583"];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:nsStringToOpen]];
    }
    if(indexPath.row == 1)
    {
        AboutSMSViewController *aboutVC = [[AboutSMSViewController alloc] initWithNibName:@"AboutSMSViewController" bundle:nil];
        [self.navigationController pushViewController:aboutVC animated:YES];
    }
}


-(void)navLeftButtonClicked:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - setter and getter
-(UITableView *)settingTableView
{
    if (!_settingTableView) {
        _settingTableView = [[UITableView alloc] initWithFrame:VIEW_FRAME_WITH_NAV style:UITableViewStylePlain];
        _settingTableView.delegate = self;
        _settingTableView.dataSource = self;
        _settingTableView.backgroundColor = [UIColor clearColor];
        _settingTableView.tableFooterView = [[UIView alloc] init];
        
    }
    return _settingTableView;
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
