const std = @import("std");

pub fn main() !void {
    const input = @embedFile("input.9.txt");
    const str = std.mem.trim(u8, input, " \t\r\n");

    std.debug.print("Problem 1: {d}\n", .{prob1(str) catch unreachable});
}

fn prob1(coord: []const u8) !u128 {
    const rn = try createRanges(std.heap.page_allocator, coord);
    var max: u128 = 0;
    for (0..rn.len) |i| {
        for (i + 1..rn.len) |j| {
            const l = if (rn[i][1] > rn[j][1]) rn[i][1] - rn[j][1] + 1 else rn[j][1] - rn[i][1] + 1;
            const b = if (rn[i][0] > rn[j][0]) rn[i][0] - rn[j][0] + 1 else rn[j][0] - rn[i][0] + 1;
            const area = l * b;
            if (area > max) max = area;
        }
    }
    return max;
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
        var itr = std.mem.tokenizeScalar(u8, ran, ',');
        const first = try std.fmt.parseInt(u128, itr.next().?, 10);
        const second = try std.fmt.parseInt(u128, itr.next().?, 10);

        ranges[i][0] = first;
        ranges[i][1] = second;

        i += 1;
    }

    return ranges;
}
