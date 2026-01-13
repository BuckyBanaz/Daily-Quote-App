<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Category;
use Illuminate\Support\Str;

class CategorySeeder extends Seeder
{
    public function run(): void
    {
        $categories = [
            ['name' => 'Motivation', 'slug' => 'motivation', 'icon' => '💪', 'color' => '#FF6B6B'],
            ['name' => 'Love', 'slug' => 'love', 'icon' => '❤️', 'color' => '#FF69B4'],
            ['name' => 'Success', 'slug' => 'success', 'icon' => '🏆', 'color' => '#FFD700'],
            ['name' => 'Wisdom', 'slug' => 'wisdom', 'icon' => '🦉', 'color' => '#9B59B6'],
            ['name' => 'Life', 'slug' => 'life', 'icon' => '🌟', 'color' => '#3498DB'],
            ['name' => 'Happiness', 'slug' => 'happiness', 'icon' => '😊', 'color' => '#F39C12'],
            ['name' => 'Inspiration', 'slug' => 'inspiration', 'icon' => '✨', 'color' => '#1ABC9C'],
            ['name' => 'Friendship', 'slug' => 'friendship', 'icon' => '🤝', 'color' => '#E74C3C'],
        ];

        foreach ($categories as $category) {
            Category::updateOrCreate(['slug' => $category['slug']], $category);
        }
    }
}
