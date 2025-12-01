const std = @import("std");

fn prob1(str: []const u8) u16 {
    var it = std.mem.tokenizeScalar(u8, str, '\n');
    var dial: i16 = 50;
    var pass: u16 = 0;
    while (it.next()) |token| {
        const num = std.fmt.parseInt(i16, token[1..], 10) catch unreachable;
        if (token[0] == 'L') {
            dial = @mod(dial - num, 100);
        } else if (token[0] == 'R') {
            dial = @mod(dial + num, 100);
        } else {
            unreachable;
        }
        if (dial == 0) {
            pass += 1;
        }
    }
    return pass;
}

// 6284 wrong
fn prob2(str: []const u8) u16 {
    var it = std.mem.tokenizeScalar(u8, str, '\n');
    var dial: i16 = 50;
    var pass: u16 = 0;
    while (it.next()) |token| {
        const num = std.fmt.parseInt(i16, token[1..], 10) catch unreachable;
        if (token[0] == 'L') {
            if (num < dial) {
                dial = dial - num;
                continue;
            }
            if (dial == 0) {
                pass += @divTrunc(@abs(dial - num), 100);
            } else {
                pass += @divTrunc(@abs(dial - num), 100) + 1;
            }
            dial = @mod(dial - num, 100);
        } else if (token[0] == 'R') {
            pass += @divTrunc(@abs(dial + num), 100);
            dial = @mod(dial + num, 100);
        } else {
            unreachable;
        }
    }
    return pass;
}

pub fn main() !void {
    const input = @embedFile("input.1.txt");
    std.debug.print("Problem 1: {d}\n", .{prob1(input)});
    std.debug.print("Problem 2: {d}\n", .{prob2(input)});
}
