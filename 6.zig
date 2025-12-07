const std = @import("std");
const print = std.debug.print;

pub fn main() !void {
    const input = @embedFile("input.6.txt");
    const str = std.mem.trim(u8, input, " \t\r\n");

    const allocator = std.heap.page_allocator;
    print("Problem 1: {d}\n", .{prob1(allocator, str) catch unreachable});
}

fn prob1(allocator: std.mem.Allocator, str: []const u8) !u128 {
    var iter = std.mem.tokenizeScalar(u8, str, '\n');
    var list: std.ArrayList([][]const u8) = .empty;
    defer list.deinit(allocator);
    while (iter.next()) |token| {
        var tmp_itr = std.mem.tokenizeScalar(u8, token, ' ');
        var tmp_list: std.ArrayList([]const u8) = .empty;
        while (tmp_itr.next()) |num_str| {
            try tmp_list.append(allocator, num_str);
        }
        try list.append(allocator, tmp_list.items);
    }

    const ops = list.getLast();
    var ans: u128 = 0;
    for (0..list.items[0].len) |idx| {
        switch (ops[idx][0]) {
            '+' => {
                var tmp: u128 = 0;
                for (0..(list.items.len - 1)) |j| {
                    tmp += try std.fmt.parseInt(u128, list.items[j][idx], 10);
                }
                ans += tmp;
            },
            '*' => {
                var tmp: u128 = 1;
                for (0..(list.items.len - 1)) |j| {
                    tmp *= try std.fmt.parseInt(u128, list.items[j][idx], 10);
                }
                ans += tmp;
            },
            else => unreachable,
        }
    }

    for (list.items) |item| {
        allocator.free(item);
    }

    return ans;
}
