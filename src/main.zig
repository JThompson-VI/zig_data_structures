const std = @import("std");
const root = @import("./root.zig");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var allocator = gpa.allocator();

    const L = root.linkedList(usize);
    var list = L{};
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    const n1 = try allocator.create(L.Node);
    defer allocator.destroy(n1);
    n1.* = .{
        .data = 72,
    };

    var n2 = L.Node{
        .data = 43,
    };
    var n3 = L.Node{
        .data = 34,
    };
    list.append(n1);
    list.append(&n2);
    list.prepend(&n3);

    var node = list.root;
    while (node) |n| {
        try stdout.print("{} -> ", .{n.data});
        node = node.?.next;
    } else {
        try stdout.print("NULL\n", .{});
    }
    try bw.flush();
}
