//
//  DataBaseManager.m
//  Sqlite3Demo
//
//  Created by George.tan on 2018/1/22.
//  Copyright © 2018年 huawei. All rights reserved.
//

#import "DataBaseManager.h"
#import "Student.h"
#define FILE_NAME @"Database.sqlite"
#define TABLE_NAME @"student"
static sqlite3 *db = nil;

@implementation DataBaseManager
/**
 实例化一个数据管理者对象
 
 @return 数据管理实例
 */
+(instancetype)shareInstace{
    static DataBaseManager *_dataBaseManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dataBaseManager = [[self alloc] init];
    });
    return _dataBaseManager;
}

/**
 打开数据库
 
 @return 数据库
 */
+(sqlite3*)openDB{
    if (!db) {
        //1.获取document文件夹的路径
        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        //2.获取数据库文件的路径
        NSString *dbPath = [docPath stringByAppendingPathComponent:FILE_NAME];
        NSFileManager *fm = [NSFileManager defaultManager];
        if (![fm fileExistsAtPath:dbPath]) {
            NSString *boundlePath = [[NSBundle mainBundle] pathForResource:@"DataBase" ofType:@"sqlite"];
            NSError *error = nil;
            BOOL result = [fm copyItemAtPath:boundlePath toPath:dbPath error:&error];
            if (!result) {
                NSLog(@"%@,数据库路径:%@",error,dbPath);

            }
        }
        //打开数据库
        sqlite3_open([dbPath UTF8String], &db);
    }
    return db;
}

/**
 关闭数据库
 */
+(void)closeDB{
    sqlite3_close(db);
    db = nil;
}

/**
 批量获取数据
 
 @return 获取数据
 */
-(NSMutableArray*)getAllData{
    NSMutableArray *array = [NSMutableArray array];
    //打开数据库
    sqlite3 *db = [DataBaseManager openDB];
    //获取数据操作指针stm
    sqlite3_stmt *stm = nil;
    //验证sql语句的正确性  参数1：数据库指针  参数2：sql语句  参数3：sql语句长度,-1表示不限制长度  参数4：返回数据库操作指针   参数5：扩展字段,可设置为null
    NSString *sqlStr = [NSString stringWithFormat:@"select * from %@",TABLE_NAME];
//    const char *sql = NULL;
//    if ([sqlStr canBeConvertedToEncoding:NSUTF8StringEncoding]) {
//        sql = [sqlStr cStringUsingEncoding:NSUTF8StringEncoding];
//    }
    int result = sqlite3_prepare_v2(db, [sqlStr UTF8String], -1, &stm, NULL);
    //判断sql执行结果
    if (result == SQLITE_OK) {
        while (sqlite3_step(stm) == SQLITE_ROW) {//存在一行数据
            int ID = sqlite3_column_int(stm, 0);
            const unsigned char *name = sqlite3_column_text(stm, 1);
            const unsigned char *sex = sqlite3_column_text(stm, 2);
            int age = sqlite3_column_int(stm, 3);
            
            //blob类型的数据获取
            //1.获取长度
            int length = sqlite3_column_bytes(stm, 4);
            //2.获取数据
            const void *photo = sqlite3_column_blob(stm, 4);
            //3.转成data
            NSData *photoData = [NSData dataWithBytes:photo length:length];
            //4.转成UIImage
            UIImage *image = [UIImage imageWithData:photoData];
            //封装成Student模型
            Student *stu = [[Student alloc] init];
            stu.ID = ID;
            stu.name = [NSString stringWithUTF8String:(const char*)name];
            stu.sex = [NSString stringWithUTF8String:(const char*)sex];
            stu.age = age;
            stu.photo = image;
            [array addObject:stu];
        }
    }
    //释放stmt指针
    sqlite3_finalize(stm);
    //关闭数据库
    [DataBaseManager closeDB];
    return array;
}

/**
 根据ID获取单条数据
 
 @param ID 数据ID
 @return 单条数据
 */
-(Student*)getSingleDataWithID:(NSInteger)ID{
    Student *stu = [[Student alloc] init];
    sqlite3 *db = [DataBaseManager openDB];
    sqlite3_stmt *stm = NULL;
    NSString *sql = [NSString stringWithFormat:@"select * from %@ where id = %d",TABLE_NAME,stu.ID];
    int result = sqlite3_prepare_v2(db, [sql UTF8String], -1,&stm,NULL);
    if (result == SQLITE_OK) {
        if (sqlite3_step(stm) == SQLITE_DONE) {
            int ID = sqlite3_column_int(stm,0);
            NSString *name = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(stm, 1)];
            NSString *sex = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stm, 2)];
            int age = sqlite3_column_int(stm, 3);
            
            int length = sqlite3_column_bytes(stm, 4);
            const void *data = sqlite3_column_blob(stm, 4);
            NSData *photoData = [NSData dataWithBytes:data length:length];
            UIImage *image = [UIImage imageWithData:photoData];
            
            stu.ID = ID;
            stu.name = name;
            stu.sex = sex;
            stu.age = age;
            stu.photo = image;
        }
    }
    sqlite3_finalize(stm);
    [DataBaseManager closeDB];
    return stu;
}

/**
 插入单条数据
 
 @param stu 单条数据
 @return 插入操作状态
 */
-(BOOL)inserSingleData:(Student*)stu{
    sqlite3* db = [DataBaseManager openDB];
    sqlite3_stmt *stm = nil;
    NSString *sql = [NSString stringWithFormat:@"insert into %@ (ID,name, sex, age,) values ('%d','%@', '%@', '%d')",TABLE_NAME,stu.ID,stu.name,stu.sex,stu.age];
    int result = sqlite3_prepare_v2(db, [sql UTF8String], -1, &stm, NULL);
    if (result == SQLITE_OK) {
        //判断语句执行完成了没有
        if (sqlite3_step(stm) == SQLITE_DONE) {
            sqlite3_finalize(stm);
            [DataBaseManager closeDB];
            return YES;
        }
    }
    sqlite3_finalize(stm);
    [DataBaseManager closeDB];
    return NO;
}

/**
 根据ID删除一条数据
 
 @param ID 数据的ID
 @return 删除操作状态
 */
-(BOOL)deleteDataWithID:(NSInteger)ID{
    sqlite3 *db = [DataBaseManager openDB];
    NSString *sql = [NSString stringWithFormat:@"delete from %@ where ID = %ld",TABLE_NAME,ID];
    sqlite3_stmt *stm = NULL;
    int result = sqlite3_prepare_v2(db, [sql UTF8String], -1, &stm, NULL);
    if (result == SQLITE_OK) {
        if (sqlite3_step(stm) == SQLITE_ROW && sqlite3_step(stm) == SQLITE_DONE) {
            sqlite3_finalize(stm);
            [DataBaseManager closeDB];
            return YES;
        }
    }
    sqlite3_finalize(stm);
    [DataBaseManager closeDB];
    return NO;
}
@end
