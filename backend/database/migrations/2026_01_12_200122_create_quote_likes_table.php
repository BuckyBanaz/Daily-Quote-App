<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('quote_likes', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('user_id');
            $table->uuid('quote_id');
            $table->timestamps();

            $table->foreign('user_id')->references('id')->on('users')->onDelete('cascade');
            $table->foreign('quote_id')->references('id')->on('quotes')->onDelete('cascade');
            
            // Ensure a user can only like a quote once
            $table->unique(['user_id', 'quote_id']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('quote_likes');
    }
};
