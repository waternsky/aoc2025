const std = @import("std");

fn prob1(str: []const u8) u128 {
    var it = std.mem.tokenizeScalar(u8, std.mem.trim(u8, str, " \t\r\n"), ',');
    var ans: u128 = 0;

    while (it.next()) |token| {
        const rn = getRange(token) catch unreachable;
        var tmp = rn[0];
        while (tmp <= rn[1]) : (tmp += 1) {
            const digits = numOfDigits(tmp);
            if (digits % 2 == 1) continue;
            const chk = std.math.pow(u128, 10, digits / 2) + 1;
            if (tmp % chk == 0) {
                ans += tmp;
            }
        }
    }
    return ans;
}

fn prob2(str: []const u8) u128 {
    var it = std.mem.tokenizeScalar(u8, std.mem.trim(u8, str, " \t\r\n"), ',');
    var ans: u128 = 0;

    while (it.next()) |token| {
        const rn = getRange(token) catch unreachable;
        var tmp = rn[0];
        while (tmp <= rn[1]) {
            const digits = numOfDigits(tmp);
            const maxdigitrep = digits / 2;
            for (1..(maxdigitrep + 1)) |r| {
                if (digits % r != 0) continue;
                const rep = digits / r;
                var chk: u128 = 1;
                for (1..rep) |i| {
                    chk += std.math.pow(u128, 10, i * r);
                }
                if (tmp % chk == 0) {
                    ans += tmp;
                    break;
                }
            }
            tmp += 1;
        }
    }
    return ans;
}

fn numOfDigits(num: u128) usize {
    if (num == 0) return 1;
    var n = num;
    var count: usize = 0;
    while (n > 0) : (n /= 10) {
        count += 1;
    }
    return count;
}

fn getRange(token: []const u8) ![2]u128 {
    var split = std.mem.tokenizeScalar(u8, token, '-');
    const first = std.fmt.parseInt(u128, split.next() orelse return error.MissingFirstPart, 10) catch unreachable;
    const second = std.fmt.parseInt(u128, split.next() orelse return error.MissingSecondPart, 10) catch unreachable;
    return .{ first, second };
}

pub fn main() !void {
    const input = @embedFile("input.2.txt");

    std.debug.print("{d}\n", .{prob1(input)});
    std.debug.print("{d}\n", .{prob2(input)});
}
