//
//  Student.h
//  Sqlite3Demo
//
//  Created by George.tan on 2018/1/22.
//  Copyright © 2018年 huawei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Student:NSObject

@property (nonatomic,assign) int ID;

@property (nonatomic,copy) NSString* name;

@property (nonatomic,copy) NSString *sex;

@property (nonatomic,assign) int age;

@property (nonatomic,strong) UIImage *photo;

@end
