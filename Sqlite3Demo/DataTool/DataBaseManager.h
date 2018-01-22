//
//  DataBaseManager.h
//  Sqlite3Demo
//
//  Created by George.tan on 2018/1/22.
//  Copyright © 2018年 huawei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import <UIKit/UIKit.h>
@class Student;

@interface DataBaseManager : NSObject

/**
 实例化一个数据管理者对象

 @return 数据管理实例
 */
+(instancetype)shareInstace;

/**
 打开数据库

 @return 数据库
 */
+(sqlite3*)openDB;

/**
 关闭数据库
 */
+(void)closeDB;

/**
 批量获取数据

 @return 获取数据
 */
-(NSMutableArray*)getAllData;

/**
 根据ID获取单条数据

 @param ID 数据ID
 @return 单条数据
 */
-(Student*)getSingleDataWithID:(NSInteger)ID;

/**
 插入单条数据

 @param stu 单条数据
 @return 插入操作状态
 */
-(BOOL)inserSingleData:(Student*)stu;

/**
 根据ID删除一条数据

 @param ID 数据的ID
 @return 删除操作状态
 */
-(BOOL)deleteDataWithID:(NSInteger)ID;

@end
