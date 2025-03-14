module GroupTravel::Planning {

    use aptos_framework::signer;
    use aptos_framework::coin::{transfer, Coin};
    use aptos_framework::aptos_coin::AptosCoin;
    use std::vector;

    struct Trip has store, key {
        organizer: address,
        total_cost: u64,
        contributions: vector<(address, u64)>, // (contributor, amount)
        expenses: vector<(vector<u8>, u64)>, // (expense_description, amount)
    }

    // Function to create a new group trip
    public fun create_trip(account: &signer, total_cost: u64) {
        let organizer = signer::address_of(account);
        let trip = Trip {
            organizer,
            total_cost,
            contributions: vector::empty(),
            expenses: vector::empty(),
        };
        move_to(account, trip);
    }

    // Function to contribute to a group trip
    public fun contribute(account: &signer, trip_owner: address, amount: u64) acquires Trip {
        let contributor = signer::address_of(account);
        let trip = borrow_global_mut<Trip>(trip_owner);

        // Transfer the contribution amount to the trip organizer
        transfer<AptosCoin>(account, trip_owner, amount);

        // Record the contribution
        // vector::push_back(&mut trip.contributions, (contributor, amount));
    }
}
