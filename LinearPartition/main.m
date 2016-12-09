//
//  main.m
//  LinearPartition
//
//  Created by Andrey Yastrebov on 08.12.16.
//  Copyright © 2016 Andrey Yastrebov. All rights reserved.
//

#import <Foundation/Foundation.h>

NSArray<NSArray<NSNumber *> *> *linearPartition(NSArray<NSNumber *> *seq, NSInteger k);
NSArray<NSArray<NSNumber *> *> *buildPartitionTable(NSArray<NSNumber *> *seq, NSInteger k);

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSArray *input = @[@9,@2,@6,@3,@8,@5,@8,@1,@7,@3,@4];
        NSArray *linear = linearPartition(input, 3);
        NSLog(@"Input: %@", input);
        NSLog(@"Result: %@", linear);
    }
    return 0;
}

NSArray<NSArray<NSNumber *> *> *linearPartition(NSArray<NSNumber *> *seq, NSInteger k) {

    NSMutableArray<NSMutableArray<NSNumber *> *> *result = [NSMutableArray array];

    if (k <= 0) {
        NSMutableArray<NSNumber *> *partition = [NSMutableArray array];
        [partition addObjectsFromArray:seq];
        [result addObject:partition];
        return result;
    }

    NSUInteger n = seq.count - 1;

    if (k > n) {
        for (NSNumber *value in seq) {
            NSMutableArray<NSNumber *> *partition = [NSMutableArray array];
            [partition addObject:value];
            [result addObject:partition];
        }
        return result;
    }

    NSArray<NSArray<NSNumber *> *> *table = buildPartitionTable(seq, k);

    k = k-2;

    while (k >= 0) {
        NSMutableArray<NSNumber *> *partition = [NSMutableArray array];

        for (NSInteger i = table[n-1][k].integerValue + 1; i < n + 1; i++) {
            [partition addObject:seq[i]];
        }

        [result insertObject:partition atIndex:0];
        n = table[n-1][k].integerValue;
        k = k-1;
    }

    NSMutableArray<NSNumber *> *partition = [NSMutableArray array];

    for (NSInteger i = 0; i < n+1; i++) {
        [partition addObject:seq[i]];
    }

    [result insertObject:partition atIndex:0];

    return result.copy;
}

NSArray<NSArray<NSNumber *> *> *buildPartitionTable(NSArray<NSNumber *> *seq, NSInteger k) {

    NSUInteger n = seq.count;

    NSMutableArray<NSMutableArray<NSNumber *> *> *table = [NSMutableArray arrayWithCapacity:n];
    for (NSInteger i = 0; i < n; i++) {
        [table addObject:[NSMutableArray arrayWithCapacity:k]];
    }

    NSMutableArray<NSMutableArray<NSNumber *> *> *solution = [NSMutableArray arrayWithCapacity:n - 1];
    for (NSInteger i = 0; i < n - 1; i++) {
        [solution addObject:[NSMutableArray arrayWithCapacity:k - 1]];
    }

    for (NSInteger i = 0; i < n; i++) {
        table[i][0] = @(seq[i].integerValue + ((i > 0) ? (table[i-1][0].integerValue) : 0));
    }

    for (NSInteger j = 0; j < k; j++) {
        table[0][j] = seq[0];
    }

    for (NSInteger i = 1; i < n; i++) {
        for (NSInteger j = 1; j < k; j++) {
            table[i][j] = @NSUIntegerMax;
            for (NSInteger x = 0; x < i; x++) {
                float cost = MAX(table[x][j-1].floatValue, table[i][0].floatValue - table[x][0].floatValue);
                if (table[i][j].floatValue > cost) {
                    table[i][j] = @(cost);
                    solution[i-1][j-1] = @(x);
                }
            }
        }
    }

    return solution.copy;
}

