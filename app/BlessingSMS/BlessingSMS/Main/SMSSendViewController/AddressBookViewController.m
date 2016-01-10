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
    
    NSString *_smsSendStr;
}
@property (nonatomic, strong) UITableView *addressBookTableView;

@end

@implementation AddressBookViewController
-(id)initWithSmsContentStr:(NSString *)str
{
    self = [super init];
    if (self) {
        _smsSendStr = str;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"选择联系人";
    [self setupDefaultNavWitConfig:@[KeyLeftButton, KeyRightButton]];
    [[self defaultNavView].rightButton setTitle:@"发送" forState:UIControlStateNormal];
    [[self defaultNavView].rightButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    _allAddressBookArray = [[NSMutableArray alloc] init];
    _selectArray = [[NSMutableArray alloc] init];
    
    NSArray *tempAddressArray = [AddressBookHelper getAddressBookInfo];
    NSLog(@"addressArray = %@", tempAddressArray);
    
    for (NSDictionary *dic in tempAddressArray) {
        AddressBookModel *model = [[AddressBookModel alloc] initWithDic:dic];
        [_allAddressBookArray addObject:model];
    }
    
    [self.view addSubview:self.addressBookTableView];
}

#pragma mark - TableViewDelegate and DataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60.0f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _allAddressBookArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SmsSendCell *cell = (SmsSendCell*)[tableView dequeueReusableCellWithIdentifier:@"SmsSendCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SmsSendCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell updateUIWithData:_allAddressBookArray[indexPath.row]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressBookModel *model = _allAddressBookArray[indexPath.row];
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