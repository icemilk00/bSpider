//
//  DataStore.h
//  BlessingSMS
//
//  Created by hp on 16/2/22.
//  Copyright © 2016年 hxp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataStore : NSObject

@property(strong, nonatomic)NSMutableDictionary *dictonary;
@property(strong, nonatomic)NSString *savePath;

+(id)dataStoreWithName:(NSString *)name;

-(void)saveDic:(NSDictionary *)dic;
-(void)addObject:(id)object forKey:(NSString *)key;
-(void)removeObject:(id)object ForKey:(NSString *)key;
-(void)editObject:(id)object ForKey:(NSString *)key withIndex:(NSInteger)index;
@end
