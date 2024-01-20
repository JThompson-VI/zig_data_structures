const std = @import("std");
const root = @import("./root.zig");

pub fn main() !void {

    const B = root.BinarySearchTree(i32);
    var tree = B{};
    var n1 = B.Node{
        .data = 72,
    };
    var n2 = B.Node{
        .data = 30,
    };
    var n3 = B.Node{
        .data = 80,
    };
    var n4 = B.Node{
        .data = 32,
    };
    tree.insert(&n1);
    tree.insert(&n2);
    tree.insert(&n3);
    tree.insert(&n4);
    tree.dbg_print();
}

test "linkedList" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var allocator = gpa.allocator();

    const L = root.linkedList(usize);
    var list = L{};
    var bw = std.io.bufferedWriter(std.io.getStdOut().writer());
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
