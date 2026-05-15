module ECommerce

-- ============================================================
-- SIGNATURES
-- ============================================================
sig Customer {}
sig Product {
    inventory : one Int
}
sig Order {
    customer : one Customer,
    product  : one Product,
    quantity : one Int,
    status   : one Status
}

-- ============================================================
-- ORDER STATUS
-- ============================================================
abstract sig Status {}
one sig Pending extends Status {}
one sig Shipped extends Status {}
one sig Delivered extends Status {}
one sig Cancelled extends Status {}

-- ============================================================
-- FACTS (SYSTEM CONSTRAINTS)
-- ============================================================
fact NoNegativeInventory {
    all p : Product |
        p.inventory >= 0
}
fact PositiveQuantity {
    all o : Order |
        o.quantity > 0
}
fact NoDeliveredCancellation {
    no o : Order |
        o.status = Delivered and
        o.status = Cancelled
}

-- ============================================================
-- PREDICATES / OPERATIONS
-- ============================================================
pred happyPath {
    some o : Order, p : Product, c : Customer |
        o.customer = c and
        o.product = p and
        o.status = Delivered and
        p.inventory >= o.quantity
}

pred invalidState {
    some o : Order |
        o.status = Delivered and
        o.status = Cancelled
}

pred placeOrder[o : Order, p : Product] {
    o.product = p
    o.status = Pending
    p.inventory > 0
}

pred cancelOrder[o : Order] {
    o.status = Pending
}

pred shipOrder[o : Order] {
    o.status = Pending
}

pred deliverOrder[o : Order] {
    o.status = Shipped
}

-- ============================================================
-- ASSERTIONS
-- ============================================================
assert InventoryNeverNegative {
    all p : Product |
        p.inventory >= 0
}

assert NoInvalidState {
    no o : Order |
        o.status = Delivered and
        o.status = Cancelled
}

-- ============================================================
-- RUN AND CHECK
-- ============================================================
run happyPath for 3
run invalidState for 3
check InventoryNeverNegative for 5
check NoInvalidState for 5
