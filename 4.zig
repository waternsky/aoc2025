const std = @import("std");
const print = std.debug.print;

pub fn main() void {
    const input = @embedFile("input.4.txt");
    const inp = std.mem.trim(u8, input, " \t\r\n");

    const allocator = std.heap.page_allocator;
    const mat = create2DArray(allocator, inp) catch unreachable;

    print("Problem 1: {d}\n", .{prob1(mat)});
}

fn prob1(matrix: [][]u8) usize {
    const rows = matrix.len;
    const cols = matrix[0].len;
    var count: usize = 0;
    for (0..rows) |ro| {
        for (0..cols) |co| {
            const curr = matrix[ro][co];
            if (curr != '@') continue;
            var tmp: u8 = 0;
            if (ro == 0) {
                if (co == 0) {
                    if (matrix[ro][co + 1] == '@') tmp += 1;
                    if (matrix[ro + 1][co + 1] == '@') tmp += 1;
                } else if (co == cols - 1) {
                    if (matrix[ro][co - 1] == '@') tmp += 1;
                    if (matrix[ro + 1][co - 1] == '@') tmp += 1;
                } else {
                    if (matrix[ro][co + 1] == '@') tmp += 1;
                    if (matrix[ro][co - 1] == '@') tmp += 1;
                    if (matrix[ro + 1][co - 1] == '@') tmp += 1;
                    if (matrix[ro + 1][co + 1] == '@') tmp += 1;
                }
                if (matrix[ro + 1][co] == '@') tmp += 1;
            } else if (ro == rows - 1) {
                if (co == 0) {
                    if (matrix[ro][co + 1] == '@') tmp += 1;
                    if (matrix[ro - 1][co + 1] == '@') tmp += 1;
                } else if (co == cols - 1) {
                    if (matrix[ro][co - 1] == '@') tmp += 1;
                    if (matrix[ro - 1][co - 1] == '@') tmp += 1;
                } else {
                    if (matrix[ro][co + 1] == '@') tmp += 1;
                    if (matrix[ro][co - 1] == '@') tmp += 1;
                    if (matrix[ro - 1][co - 1] == '@') tmp += 1;
                    if (matrix[ro - 1][co + 1] == '@') tmp += 1;
                }
                if (matrix[ro - 1][co] == '@') tmp += 1;
            } else {
                if (co == 0) {
                    if (matrix[ro - 1][co + 1] == '@') tmp += 1;
                    if (matrix[ro + 1][co + 1] == '@') tmp += 1;
                    if (matrix[ro][co + 1] == '@') tmp += 1;
                } else if (co == cols - 1) {
                    if (matrix[ro][co - 1] == '@') tmp += 1;
                    if (matrix[ro - 1][co - 1] == '@') tmp += 1;
                    if (matrix[ro + 1][co - 1] == '@') tmp += 1;
                } else {
                    if (matrix[ro][co + 1] == '@') tmp += 1;
                    if (matrix[ro][co - 1] == '@') tmp += 1;
                    if (matrix[ro - 1][co - 1] == '@') tmp += 1;
                    if (matrix[ro - 1][co + 1] == '@') tmp += 1;
                    if (matrix[ro + 1][co - 1] == '@') tmp += 1;
                    if (matrix[ro + 1][co + 1] == '@') tmp += 1;
                }
                if (matrix[ro - 1][co] == '@') tmp += 1;
                if (matrix[ro + 1][co] == '@') tmp += 1;
            }
            if (tmp < 4) count += 1;
        }
    }
    return count;
}

fn create2DArray(allocator: std.mem.Allocator, str: []const u8) ![][]u8 {
    var iter = std.mem.tokenizeScalar(u8, str, '\n');
    const cols = iter.peek().?.len;
    // need to add +1 in str.len because we trim the input
    const rows = (1 + str.len) / (1 + cols);

    const matrix = try allocator.alloc([]u8, rows);
    for (matrix) |*row| {
        row.* = try allocator.alloc(u8, cols);
    }

    var i: usize = 0;
    while (iter.next()) |token| {
        for (0..token.len) |j| {
            matrix[i][j] = token[j];
        }

        i += 1;
    }

    return matrix;
}
