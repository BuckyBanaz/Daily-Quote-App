<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\User;
use Illuminate\Support\Facades\Hash;

class UserSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // Create test user
        User::updateOrCreate(
            ['email' => 'jhon@example.com'],
            [
                'name' => 'John Doe',
                'password' => Hash::make('Secret123'),
                'fcm_token' => null,
            ]
        );

        // Create another test user
        User::updateOrCreate(
            ['email' => 'test@test.com'],
            [
                'name' => 'Test User',
                'password' => Hash::make('password'),
                'fcm_token' => null,
            ]
        );
    }
}
