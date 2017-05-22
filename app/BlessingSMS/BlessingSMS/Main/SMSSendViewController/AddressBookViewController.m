//
//  AddressBookViewController.m
//  BlessingSMS
//
//  Created by hp on 16/1/7.
//  Copyright © 2016年 hxp. All rights reserved.
//

#import "AddressBookViewController.h"
#import "SmsSendCell.h"


@interface AddressBookViewController ()
{
    NSMutableArray *_selectArray;
    NSMutableArray *_allAddressBookArray;
    
    NSString *_smsCategoryID;
    NSString *_smsID;
    NSString *_smsSendStr;
    
    NSMutableDictionary *_dataSourceDic;
    NSMutableArray *_indexArray;
    NSArray *_baseCharsArray;
}
@property (nonatomic, strong) UITableView *addressBookTableView;

@end

@implementation AddressBookViewController
-(id)initWithSmsInfo:(SMSInfoModel *)smsInfoModel
{
    self = [super init];
    if (self) {
        _smsCategoryID = smsInfoModel.category_id;
        _smsID = smsInfoModel.id;
        _smsSendStr = smsInfoModel.content;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"选择联系人";
    [self setupDefaultNavWitConfig:@[KeyLeftButton, KeyRightButton]];
    [[self defaultNavView].rightButton setTitle:@"发送" forState:UIControlStateNormal];
    
    [self arrayInit];
    
    NSArray *tempAddressArray = [AddressBookHelper getAddressBookInfo];
    NSLog(@"addressArray = %@", tempAddressArray);
    
    for (NSDictionary *dic in tempAddressArray) {
        AddressBookModel *model = [[AddressBookModel alloc] initWithDic:dic];
        [_allAddressBookArray addObject:model];
    }
    
    [self makeDataSourceWithDataArray:_allAddressBookArray];
    [self.view addSubview:self.addressBookTableView];
}

-(void)arrayInit
{
    _allAddressBookArray = [[NSMutableArray alloc] init];
    _selectArray = [[NSMutableArray alloc] init];
    
    _baseCharsArray = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#"];
    _indexArray = [[NSMutableArray alloc] init];
    _dataSourceDic = [[NSMutableDictionary alloc] init];
    
}

-(void)makeDataSourceWithDataArray:(NSArray *)dataArray
{
    for (NSString *baseChar in _baseCharsArray) {
        NSMutableArray *tempDataArray = [[NSMutableArray alloc] init];
        
        if ([baseChar isEqualToString:@"#"]) {
            for (AddressBookModel *model in dataArray) {
                
                if (!model || !model.firstCharacter || model.firstCharacter.length <= 0) {
                    [tempDataArray addObject:model];
                    continue;
                }
                
                const char *c_pinYinFirst = [model.firstCharacter cStringUsingEncoding:NSASCIIStringEncoding];
                
                if (c_pinYinFirst == nil) {
                    [tempDataArray addObject:model];
                    continue;
                }
                
                if (!( c_pinYinFirst[0] <= 'Z' && c_pinYinFirst[0] >= 'A') && !( c_pinYinFirst[0] <= 'z' && c_pinYinFirst[0] >= 'a')) {
                    [tempDataArray addObject:model];
                }
            }
        }
        else
        {
            for (AddressBookModel *model in dataArray) {
                
                if (!model || !model.firstCharacter) {
                    continue;
                }
                
                if ([model.firstCharacter isEqualToString:baseChar]) {
                    [tempDataArray addObject:model];
                }
            }
        }
        
        
        if (tempDataArray.count > 0) {
            [_dataSourceDic setObject:tempDataArray forKey:baseChar];
            [_indexArray addObject:baseChar];
        }
        
    }
}

#pragma mark - TableViewDelegate and DataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60.0f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return ((NSArray *)(_dataSourceDic[_indexArray[section]])).count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SmsSendCell *cell = (SmsSendCell*)[tableView dequeueReusableCellWithIdentifier:@"SmsSendCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SmsSendCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    [cell updateUIWithData:[((NSArray *)(_dataSourceDic[_indexArray[indexPath.section]])) objectAtIndex:indexPath.row]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressBookModel *model = ((NSArray *)(_dataSourceDic[_indexArray[indexPath.section]]))[indexPath.row];
    if (model.isSelected) {
        if ([_selectArray containsObject:model]) {
            [_selectArray removeObject:model];
        }
    }
    else
    {
        if (![_selectArray containsObject:model]) {
            [_selectArray addObject:model];
        }
    }
    
    [(SmsSendCell *)[tableView cellForRowAtIndexPath:indexPath] sendSelectedWithModel:model
     ];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _indexArray.count;
}

//返回索引数组

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _indexArray;
}

//返回每个索引的内容

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return _indexArray[section];
}

#pragma mark - nav button action
-(void)navLeftButtonClicked:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)navRightButtonClicked:(UIButton *)sender
{
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
    if (messageClass != nil) {
        // Check whether the current device is configured for sending SMS messages
        if ([messageClass canSendText]) {
            [self displaySMSComposerSheet];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该设备不支持短信功能" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"ios版本太低" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void)displaySMSComposerSheet
{
    [AnalyticsManager eventSmsSendWithPlatform:eventSMSSendSecond withCategoryID:_smsCategoryID withSMSID:_smsID];
    
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    picker.messageComposeDelegate = self;
    
    picker.body = _smsSendStr;
    
    NSMutableArray *phoneNumArray = [[NSMutableArray alloc] init];
    for (AddressBookModel *model in _selectArray) {
        NSString *phoneNum = model.phoneNum;
        [phoneNumArray addObject:phoneNum];
    }
    picker.recipients = phoneNumArray;
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result {
    
    switch (result)
    {
        case MessageComposeResultCancelled:
            break;
        case MessageComposeResultSent:
            break;
        case MessageComposeResultFailed:
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - setter and getter
-(UITableView *)addressBookTableView
{
    if (!_addressBookTableView) {
        _addressBookTableView = [[UITableView alloc] initWithFrame:VIEW_FRAME_WITH_NAV style:UITableViewStylePlain];
        _addressBookTableView.delegate = self;
        _addressBookTableView.dataSource = self;
    }
    return _addressBookTableView;
}

#pragma mark - rightButtonconfig

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
