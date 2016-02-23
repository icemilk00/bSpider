//
//  DataStore.m
//  BlessingSMS
//
//  Created by hp on 16/2/22.
//  Copyright © 2016年 hxp. All rights reserved.
//

#import "DataStore.h"

@implementation DataStore

+(id)dataStoreWithName:(NSString *)name{
    
    NSString *docPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:@"/plistData"];
    NSFileManager *fm = [NSFileManager defaultManager];
    if(![fm fileExistsAtPath:docPath])
    {
        BOOL val = [fm createDirectoryAtPath:docPath withIntermediateDirectories:YES attributes:nil error:nil];
        if (val == false) {
            NSLog(@"create folder failed!");
        }
    }
    
    NSString *filePath = [docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",name]];
    //如果当前用到的plist文件与之前打开的plist文件不同，则重新初始化一个datastore

    DataStore *dataStore = [[DataStore alloc]init];
    if(![fm fileExistsAtPath:filePath])
    {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict writeToFile:filePath atomically:YES];
    }
    
    dataStore.dictonary = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    dataStore.savePath = filePath;
    return dataStore;
}

-(void)saveDic:(NSDictionary *)dic
{
    self.dictonary = [[NSMutableDictionary alloc] initWithDictionary:dic];
    [self.dictonary writeToFile:self.savePath atomically:YES];
}

-(void)addObject:(id)object forKey:(NSString *)key
{
    if([self.dictonary objectForKey:key])
    {
        [self.dictonary[key] addObject:object];
    }
    else
    {
        [self.dictonary setObject:[NSMutableArray arrayWithObject:object] forKey:key];
    }
    
    [self.dictonary writeToFile:self.savePath atomically:YES];
}

-(void)removeObject:(id)object ForKey:(NSString *)key
{
    
    NSMutableArray *dataArray = self.dictonary[key];
    if (dataArray && dataArray.count > 0) {
        
        if ([dataArray containsObject:object]) {
            [dataArray removeObject:object];
        }
        
        if (dataArray.count <= 0) {
            [self.dictonary removeObjectForKey:key];
        }
        
        [self.dictonary writeToFile:self.savePath atomically:YES];
    }
}

-(void)editObject:(id)object ForKey:(NSString *)key withIndex:(NSInteger)index
{

    NSMutableArray *dataArray = self.dictonary[key];
    if (dataArray && dataArray.count > index) {
        
        [dataArray removeObjectAtIndex:index];
        [dataArray insertObject:object atIndex:index];
        
        [self.dictonary writeToFile:self.savePath atomically:YES];
    }
    
    
}

@end
