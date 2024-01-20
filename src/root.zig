const std = @import("std");

pub fn linkedList(comptime T: type) type {
    return struct {
        const Self = @This();

        length: usize = 0,
        root: ?*Node = null,
        tail: ?*Node = null,

        pub const Node = struct {
            data: T,
            next: ?*Node = null,
            prev: ?*Node = null,
        };
        pub fn insertAfter(self: *Self, node: *Node, new_node: *Node) *Node {
            new_node.next = node.next;
            node.next = new_node;
            new_node.prev = node;
            self.length += 1;
            return new_node;
        }

        pub fn append(self: *Self, node: *Node) void {
            // if last not null
            // add to last.next
            // otherwise set first and last to node
            if (self.tail) |tail| {
                tail.next = node;
                node.prev = tail;
            } else {
                self.root = node;
                node.prev = null;
            }
            node.next = null;
            self.tail = node;
            self.length += 1;
        }
        pub fn prepend(self: *Self, node: *Node) void {
            if (self.root) |r| {
                node.next = r;
                r.prev = node;
                node.prev = null;
                self.root = node;
                self.length += 1;
            } else {
                self.append(node);
            }
        }
    };
}

test "test insertAfter" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var allocator = gpa.allocator();

    const L = linkedList(usize);
    var list = L{};

    list.root = try allocator.create(L.Node);
    list.root.?.* = .{
        .data = 72,
    };
    list.length = 1;
    for (0..10) |it| {
        const new_node = try allocator.create(L.Node);
        new_node.*.data = it;
        _ = list.insertAfter(list.root.?, new_node);
    }
    try std.testing.expectEqual(list.root.?.data, 72);
    try std.testing.expectEqual(list.root.?.next.?.data, 9);
    try std.testing.expectEqual(list.root.?.next.?.next.?.data, 8);
}

test "append" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var allocator = gpa.allocator();

    const L = linkedList(usize);
    var list = L{};

    const n1 = try allocator.create(L.Node);
    defer allocator.destroy(n1);
    n1.* = .{
        .data = 72,
    };

    var n2 = L.Node{
        .data = 43,
    };

    list.append(n1);
    try std.testing.expectEqual(list.root.?.data, 72);
    try std.testing.expectEqual(list.tail.?.data, 72);
    list.append(&n2);
    try std.testing.expectEqual(list.tail.?.data, 43);
    try std.testing.expectEqual(list.length, 2);
    var n3 = L.Node{
        .data = 32,
    };
    list.prepend(&n3);
    try std.testing.expectEqual(list.length, 3);
    try std.testing.expectEqual(list.root.?.data, 32);
}
