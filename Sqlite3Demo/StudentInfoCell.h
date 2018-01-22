//
//  StudentInfoCell.h
//  Sqlite3Demo
//
//  Created by George.tan on 2018/1/22.
//  Copyright © 2018年 huawei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StudentInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *idLb;
@property (weak, nonatomic) IBOutlet UILabel *photoLb;
@property (weak, nonatomic) IBOutlet UILabel *ageLb;
@property (weak, nonatomic) IBOutlet UILabel *sexLb;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;

@end
