const std = @import("std");

pub fn main() !void {
    const input = @embedFile("input.5.txt");
    const str = std.mem.trim(u8, input, " \t\r\n");

    var iter = std.mem.tokenizeSequence(u8, str, "\n\n");

    const ranges = iter.next().?;
    const ids = iter.next().?;

    const allocator = std.heap.page_allocator;

    const rn = createRanges(allocator, ranges) catch unreachable;

    std.debug.print("Problem 1: {d}\n", .{prob1(ids, rn)});

    allocator.free(rn);
}

fn prob1(ids: []const u8, ranges: [][2]u128) u16 {
    var id_itr = std.mem.tokenizeScalar(u8, ids, '\n');
    var fresh: u16 = 0;
    while (id_itr.next()) |num_str| {
        const num = std.fmt.parseInt(u128, num_str, 10) catch unreachable;
        for (ranges) |r| {
            if (r[0] <= num and num <= r[1]) {
                fresh += 1;
                break;
            }
        }
    }
    return fresh;
}

fn createRanges(allocator: std.mem.Allocator, range: []const u8) ![][2]u128 {
    const rn = std.mem.trim(u8, range, " \t\r\n");
    // we trim it so need to add 1, (instead just start with 1)
    var length: usize = 1;
    for (rn) |i| {
        if (i == '\n') length += 1;
    }
    var ranges = try allocator.alloc([2]u128, length);
    var iter = std.mem.tokenizeScalar(u8, rn, '\n');

    var i: usize = 0;
    while (iter.next()) |ran| {
        var itr = std.mem.tokenizeScalar(u8, ran, '-');
        const first = try std.fmt.parseInt(u128, itr.next().?, 10);
        const second = try std.fmt.parseInt(u128, itr.next().?, 10);

        ranges[i][0] = first;
        ranges[i][1] = second;

        i += 1;
    }

    return ranges;
}
