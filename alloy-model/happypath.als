module ECommerce

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

abstract sig Status {}
one sig Pending extends Status {}
one sig Shipped extends Status {}
one sig Delivered extends Status {}
one sig Cancelled extends Status {}

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

pred happyPath {
    some o : Order, p : Product, c : Customer |
        o.customer = c and
        o.product = p and
        o.status = Delivered and
        p.inventory >= o.quantity
}

run happyPath for 3
