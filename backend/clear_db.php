<?php
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

// Disable foreign keys for SQLite
DB::statement('PRAGMA foreign_keys = OFF');

// Truncate tables
$tables = ['user_favorites', 'quote_likes', 'quotes', 'categories', 'users'];
foreach ($tables as $table) {
    DB::table($table)->delete();
}

DB::statement('PRAGMA foreign_keys = ON');

echo "Tables cleared successfully\n";
