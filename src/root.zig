const std = @import("std");
const Order = std.math.Order;

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

pub fn BinarySearchTree(comptime T: type) type {
    return struct {
        const Self = @This();

        root: ?*Node = null,

        fn compare(a: T, b: T) Order {
            if (a < b) {
                return Order.lt;
            } else if (a > b) {
                return Order.gt;
            } else {
                return Order.eq;
            }
        }

        pub const Node = struct {
            data: T,
            right: ?*Node = null,
            left: ?*Node = null,
        };

        pub fn insert(self: *Self, node: *Node) void {
            if (self.root == null) {
                self.root = node;
                return;
            }
            var parent: ?*Node = self.root;
            while (parent) |p| {
                switch (compare(p.data, node.data)) {
                    .gt => {
                        if (p.left) |p_left| {
                            parent = p_left;
                        } else {
                            p.left = node;
                            return;
                        }
                    },
                    .lt => {
                        if (p.right) |p_right| {
                            parent = p_right;
                        } else {
                            p.right = node;
                            return;
                        }
                    },
                    .eq => {
                        if (p.right == null) {
                            p.right = node;
                        } else if (p.left == null) {
                            p.left = node;
                        } else {
                            // TODO: arbitrarily picked left
                            parent = p.left;
                        }
                    },
                }
            }
        }

        fn dbg_print_inner(self: *Self, node: ?*Node) void {
            // data -> left: data, right: data
            if (node) |n| {
                const left_data = blk: {
                    if (n.left) |left| {
                        break :blk left.data;
                    } else {
                        break :blk null;
                    }
                };
                const right_data = blk: {
                    if (n.right) |right| {
                        break :blk right.data;
                    } else {
                        break :blk null;
                    }
                };
                std.debug.print("{} -> left: {?}, right: {?}\n", .{
                    n.data,
                    left_data,
                    right_data,
                });
                self.dbg_print_inner(node.?.left);
                self.dbg_print_inner(node.?.right);
            }
        }
        pub fn dbg_print(self: *Self) void {
            dbg_print_inner(self, self.root);
        }

        pub fn remove(self: *Self, node: *Node) void {
            _ = node;
            _ = self;
        }

        pub fn search(self: *Self, data: T) ?Node {
            _ = data;
            _ = self;
        }
        // insert nodes
        // remove nodes
        // have size
        // rebalance
        // maybe some some constructors
    };
}

test "insert" {
    const testing = std.testing;
    const B = BinarySearchTree(i32);
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
    tree.insert(&n1);
    tree.insert(&n2);
    tree.insert(&n3);
    try testing.expectEqual(tree.root.?.data, 72);
    try testing.expect(tree.root.?.left != null);
    try testing.expect(tree.root.?.right != null);
}
