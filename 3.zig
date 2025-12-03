const std = @import("std");
const print = std.debug.print;
const trim = std.mem.trim;
const splitByChar = std.mem.tokenizeScalar;

fn getMaxTwoDigitVoltage(num: []const u8) u8 {
    var max: [2]u8 = [2]u8{ '0', '0' };
    const maxDigit = getMaxDigitIndex(num);
    if (maxDigit.@"1" == num.len - 1) {
        const secondMaxDigit = getMaxDigitIndex(num[0..(num.len - 1)]);
        max[0] = secondMaxDigit.@"0";
        max[1] = maxDigit.@"0";
    } else {
        const secondMaxAfterDigit = getMaxDigitIndex(num[(maxDigit.@"1" + 1)..]);
        max[0] = maxDigit.@"0";
        max[1] = secondMaxAfterDigit.@"0";
    }
    return std.fmt.parseInt(u8, &max, 10) catch unreachable;
}

fn getMaxDigitIndex(num: []const u8) struct { u8, usize } {
    var max: u8 = '0';
    var index: usize = 0;
    for (0..num.len) |idx| {
        if (num[idx] > max) {
            max = num[idx];
            index = idx;
        }
    }
    return .{ max, index };
}

fn prob1(input: []const u8) u16 {
    var it = splitByChar(u8, input, '\n');
    var ans: u16 = 0;
    while (it.next()) |num| {
        // print("{s} -> {d}\n", .{ num, getMaxTwoDigitVoltage(num) });
        ans += getMaxTwoDigitVoltage2(num);
    }
    return ans;
}

fn getMaxTwoDigitVoltage2(num: []const u8) u8 {
    var max: [2]u8 = [2]u8{ '0', '0' };
    const first = getMaxDigitIndex(num[0..(num.len - 1)]);
    const second = getMaxDigitIndex(num[(first.@"1" + 1)..]);
    max[0] = first.@"0";
    max[1] = second.@"0";
    return std.fmt.parseInt(u8, &max, 10) catch unreachable;
}

fn getMaxTwelveDigitVoltage(num: []const u8) u128 {
    var max: [12]u8 = [_]u8{'0'} ** 12;
    var fidx: usize = 0;
    var lidx: usize = num.len - 11;
    for (0..12) |i| {
        const tmp = getMaxDigitIndex(num[fidx..lidx]);
        // print("Iteration: {d}\nfirst: {d}, second: {d}\n", .{ i, fidx, lidx });
        fidx = fidx + tmp.@"1" + 1;
        lidx = lidx + 1;
        max[i] = tmp.@"0";
    }
    return std.fmt.parseInt(u128, &max, 10) catch unreachable;
}

fn prob2(input: []const u8) u128 {
    var it = splitByChar(u8, input, '\n');
    var ans: u128 = 0;
    while (it.next()) |num| {
        // print("{s} -> {d}\n", .{ num, getMaxTwelveDigitVoltage(num) });
        ans += getMaxTwelveDigitVoltage(num);
    }
    return ans;
}

pub fn main() !void {
    const input = @embedFile("input.3.txt");
    const str = trim(u8, input, " \t\r\n");

    print("{d}\n", .{prob1(str)});
    print("{d}\n", .{prob2(str)});
    // print("{d}, {d}\n", .{ getMaxDigitIndex("8181819111112111").@"0", getMaxDigitIndex("8181819111112111").@"1" });
    // print("{d}\n", .{getMaxTwelveDigitVoltage("818181911111112111")});
}
