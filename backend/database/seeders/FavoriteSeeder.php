<?php

namespace Database\Seeders;

use App\Models\Quote;
use App\Models\User;
use App\Models\UserFavorite;
use Illuminate\Database\Seeder;

class FavoriteSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $user = User::where('email', 'jhon@example.com')->first();
        if (!$user) {
            $user = User::first();
        }

        if ($user) {
            // Get some random quotes
            $quotes = Quote::inRandomOrder()->limit(5)->get();

            foreach ($quotes as $quote) {
                $exists = \Illuminate\Support\Facades\DB::table('user_favorites')
                    ->where('user_id', $user->id)
                    ->where('quote_id', $quote->id)
                    ->exists();

                if (!$exists) {
                    \Illuminate\Support\Facades\DB::table('user_favorites')->insert([
                        'user_id' => $user->id,
                        'quote_id' => $quote->id,
                        'created_at' => now(),
                        'updated_at' => now(),
                    ]);
                }
            }
        }
    }
}
