//
//  AddressBookHelper.m
//  BlessingSMS
//
//  Created by hp on 16/1/7.
//  Copyright © 2016年 hxp. All rights reserved.
//

#import "AddressBookHelper.h"
#import <AddressBook/AddressBook.h>

@implementation AddressBookHelper

+(NSArray *)getAddressBookInfo
{
    ABAddressBookRef addressBook = nil;
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0)
    {
        addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        //等待同意后向下执行
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error)
                                                 {
                                                     dispatch_semaphore_signal(sema);
                                                 });
        
        
        
        
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }
    else
    {
        addressBook = ABAddressBookCreate();
    }
    
    CFArrayRef personArray = ABAddressBookCopyArrayOfAllPeople(addressBook);
    
    long allPhoneFriendNum = CFArrayGetCount(personArray);
    
    
    NSMutableArray *addressBookArray = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < allPhoneFriendNum; i++)
    {
        NSString *name = @"";
        ABRecordRef person = CFArrayGetValueAtIndex(personArray, i);
        //读取lastname
        NSString *lastname = (__bridge NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty);
        if(lastname != nil)
            name = [name stringByAppendingFormat:@"%@",lastname];
        //读取middlename
        NSString *middlename = (__bridge NSString*)ABRecordCopyValue(person, kABPersonMiddleNameProperty);
        if(middlename != nil)
            name = [name stringByAppendingFormat:@"%@",middlename];
        //读取firstname
        NSString *personName = (__bridge NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
        if(personName != nil)
            name = [name stringByAppendingFormat:@"%@",personName];
        
        NSLog(@"name = %@", name);
        if (name == nil) {
            continue;
        }
        
        //读取照片
//        NSData *imageData = (__bridge NSData*)ABPersonCopyImageData(person);
//        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//        if (imageData != nil) {
//            [dic setObject:imageData forKey:name];
//        }
        
        //读取电话多值
        NSString *phoneNum = nil;
        ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
        int k = 0;

        //获取电话Label
        NSString * personPhoneLabel = (__bridge NSString*)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(phone, k));
        //获取該Label下的电话值
        NSString * personPhone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phone, k);
        
        if (personPhone == nil) {
            personPhone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phone, k+1);
            if (personPhone == nil) {
                continue;
            }
        }
        
        phoneNum = [NSString stringWithFormat:@"%@", personPhone];
        NSLog(@"phone = %@:%@", personPhoneLabel,personPhone);
        //    开始判断并且替换字符串
        phoneNum = [AddressBookHelper getOutStr:@"-" from:phoneNum];
        phoneNum = [AddressBookHelper getOutStr:@"+86" from:phoneNum];
        NSLog(@"phonenum = %@", phoneNum);
        //        }
        
        
        NSMutableDictionary *userDic = [[NSMutableDictionary alloc] init];
        
        [userDic setObject:phoneNum forKey:@"phoneNum"];
        [userDic setObject:name forKey:@"name"];
        
        [addressBookArray addObject:userDic];
        
    }
    
    CFRelease(personArray);
    CFRelease(addressBook);
    
    return addressBookArray;

}

+(NSString *)getOutStr:(NSString *)outStr from:(NSString *)sourceStr
{
    NSRange range = [sourceStr rangeOfString:outStr];
    if (range.location != NSNotFound) {
        NSMutableString *string = [NSMutableString stringWithString:sourceStr];
        [string replaceCharactersInRange:[string rangeOfString:outStr] withString:@""];
        sourceStr = [NSString stringWithString:string];
        
        sourceStr = [AddressBookHelper getOutStr:outStr from:sourceStr];
    }
    
    
    return sourceStr;
}

@end
