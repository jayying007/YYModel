//
//  main.m
//  YYModelTest
//
//  Created by janezhuang on 2023/2/4.
//  Copyright © 2023 ibireme. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../../YYModel/YYModel.h"

@interface Dog : NSObject
@property (nonatomic) NSString *name;
@property (nonatomic) int age;
@end
@implementation Dog
@end

@interface Person : NSObject
@property (nonatomic) Dog *pet;
@property (nonatomic) NSArray *hobby;
@property (nonatomic, readonly) int age; // 查看源代码可以发现readonly属性不会处理
@property (nonatomic) NSDictionary *QA;
@property (nonatomic) NSIndexPath *indexPath;
@end

@implementation Person
//+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
//    return @{ @"hobby" : Dog.class };
//}
- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    _age = 100;
}
@end

void test1(void) {
    Dog *dog = [Dog new];
    dog.name = @"旺财";
    dog.age = 2;
    Person *person = [Person new];
    person.pet = dog;
    person.hobby = @[ @[@(1), @(3)], dog, @[ dog, @(666) ] ]; // 实际项目中应该是相同类型的元素
//    person.age = 24;
    person.QA = @{ @"这个项目是什么？" : @"一个简单的JSON和Model互转的工程", @"你真帅!" : @"谢谢~" };
    person.indexPath = [NSIndexPath indexPathWithIndex:2];
    
    NSString *str = [@[person] yy_modelToJSONString];
    
    printf("%s\n", str.UTF8String);
}

void test2(void) {
    Person *person = [Person yy_modelWithJSON:@"{\"hobby\":[[{\"name\":\"旺财\",\"age\":2}],{\"name\":\"旺财\",\"age\":2},\"Dance\",\"Programing\",6],"
                                                "\"age\":24,"
                                                "\"pet\":{\"name\":\"旺财\",\"age\":2},"
                                                "\"QA\":{"
                                                    "\"What is this project？\":\"A demo show conversion between json and model.\","
                                                    "\"You are handsome!\":\"Thanks~\"}"
                                                "}"];
    NSLog(@"%@", person);
}

void test3(void) {
    NSArray *array = [NSArray yy_modelArrayWithClass:Dog.class json:@"[{\"name\":\"旺财\",\"age\":2}]"];
    NSLog(@"%@", array);
}

int main(int argc, const char * argv[]) {
    test1();
    test2();
    test3();
    
    return 0;
}
