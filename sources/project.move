module StreakTracker::Tracker {
    use aptos_framework::signer;
    use aptos_framework::account;

    struct Streak has key, store {
        count: u64,
        claimed: bool,
    }

    /// Initialize or increment the user's streak
    public fun increment_streak(user: &signer) acquires Streak {
        let addr = signer::address_of(user);

        if (!exists<Streak>(addr)) {
            move_to(user, Streak { count: 1, claimed: false });
        } else {
            let streak = borrow_global_mut<Streak>(addr);
            streak.count = streak.count + 1;
        }
    }

    /// Mark reward as claimed after a 7-day streak (without NFT)
    public fun claim_reward(user: &signer) acquires Streak {
        let addr = signer::address_of(user);
        let streak = borrow_global_mut<Streak>(addr);

        assert!(streak.count >= 7, 1); // Require a streak of at least 7 days
        assert!(!streak.claimed, 2);   // Prevent multiple claims

        // Mark reward as claimed
        streak.claimed = true;
    }

    /// Reset the user's streak (optional)
    public fun reset_streak(user: &signer) acquires Streak {
        let addr = signer::address_of(user);
        if (exists<Streak>(addr)) {
            let streak = borrow_global_mut<Streak>(addr);
            streak.count = 0;
            streak.claimed = false;
        }
    }
}
